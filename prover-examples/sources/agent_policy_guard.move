/// AgentPolicyGuard: Prove spend <= policy.limit + intent_verified
/// Invariant: Tổng spend không vượt limit, và mỗi action cần intent verified.
module prover_examples::agent_policy_guard {

    /// Agent policy với spend limit và intent verification
    struct AgentPolicy has drop {
        owner: address,
        spend_limit: u64,
        spent: u64,
        intent_verified: bool,  // Flag từ off-chain/Seal/Nautilus verify
    }

    /// Action agent muốn execute
    struct AgentAction has drop {
        amount: u64,
    }

    // Error codes
    const E_INTENT_NOT_VERIFIED: u64 = 100;
    const E_EXCEED_LIMIT: u64 = 101;
    const E_OVERFLOW: u64 = 102;
    const E_INVALID_LIMIT: u64 = 103;

    // Constants
    const MAX_U64: u64 = 18446744073709551615;

    /// Create new agent policy
    public fun create_policy(owner: address, spend_limit: u64): AgentPolicy {
        // Spend limit must be > 0
        assert!(spend_limit > 0, E_INVALID_LIMIT);
        AgentPolicy {
            owner,
            spend_limit,
            spent: 0,
            intent_verified: false,
        }
    }

    /// Verify intent (called by Seal/Nautilus or user signature)
    public fun verify_intent(policy: &mut AgentPolicy) {
        policy.intent_verified = true;
    }

    /// Create action
    public fun create_action(amount: u64): AgentAction {
        AgentAction { amount }
    }

    /// Function agent execute action (e.g., spend for trade/pay)
    public fun execute_action(policy: &mut AgentPolicy, action: AgentAction) {
        // Require intent verified (từ Seal/Nautilus hoặc user sign)
        assert!(policy.intent_verified, E_INTENT_NOT_VERIFIED);

        // Check overflow first
        assert!(policy.spent <= MAX_U64 - action.amount, E_OVERFLOW);

        // Check spend limit
        assert!(policy.spent + action.amount <= policy.spend_limit, E_EXCEED_LIMIT);

        // Simulate execute (e.g., transfer or tool call)
        policy.spent = policy.spent + action.amount;

        // Reset intent sau execute (one-time use)
        policy.intent_verified = false;
    }

    /// Get current spent amount
    public fun get_spent(policy: &AgentPolicy): u64 {
        policy.spent
    }

    /// Get spend limit
    public fun get_spend_limit(policy: &AgentPolicy): u64 {
        policy.spend_limit
    }

    // ============ MOVE SPECIFICATION LANGUAGE (MSL) ============

    spec module {
        pragma verify = true;
    }

    spec create_policy {
        // Pre-condition: limit must be valid
        requires spend_limit > 0;
        
        // Abort if invalid limit
        aborts_if spend_limit == 0 with E_INVALID_LIMIT;
        
        // Post-conditions
        ensures result.spent == 0;
        ensures result.spend_limit == spend_limit;
        ensures result.owner == owner;
        ensures result.intent_verified == false;
    }

    spec verify_intent {
        ensures policy.intent_verified == true;
    }

    spec execute_action {
        // Pre-conditions
        requires policy.intent_verified;
        requires policy.spent <= policy.spend_limit;
        
        // Abort nếu không verify intent
        aborts_if !policy.intent_verified with E_INTENT_NOT_VERIFIED;

        // Abort nếu overflow
        aborts_if policy.spent > MAX_U64 - action.amount with E_OVERFLOW;

        // Abort nếu vượt limit
        aborts_if policy.spent + action.amount > policy.spend_limit with E_EXCEED_LIMIT;

        // Modifies: explicit state changes
        modifies policy.spent;
        modifies policy.intent_verified;

        // Post: Spend tăng đúng amount
        ensures policy.spent == old(policy.spent) + action.amount;

        // Invariant giữ: Spent luôn <= limit sau execute
        ensures policy.spent <= policy.spend_limit;

        // Intent reset sau execute
        ensures policy.intent_verified == false;
    }

    // Global invariant cho AgentPolicy: Mọi AgentPolicy có spent <= limit
    spec AgentPolicy {
        invariant spent <= spend_limit;
        invariant spend_limit > 0;
    }
}
