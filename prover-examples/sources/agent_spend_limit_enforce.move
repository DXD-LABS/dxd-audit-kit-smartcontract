module prover_examples::agent_spend_limit_enforce {

    struct AgentPolicy has drop {
        limit: u64,
        spent: u64,
    }

    struct Action has drop {
        amount: u64,
    }

    const E_SPEND_LIMIT_EXCEEDED: u64 = 1;
    const E_OVERFLOW: u64 = 2;

    const MAX_U64: u64 = 18446744073709551615;

    public fun execute_action(policy: &mut AgentPolicy, action: Action) {
        assert!(policy.spent <= MAX_U64 - action.amount, E_OVERFLOW);
        assert!(action.amount + policy.spent <= policy.limit, E_SPEND_LIMIT_EXCEEDED);
        policy.spent = policy.spent + action.amount;
    }

    spec execute_action {
        pragma aborts_if_is_partial;
        aborts_if policy.spent > MAX_U64 - action.amount with E_OVERFLOW;
        aborts_if action.amount + policy.spent > policy.limit with E_SPEND_LIMIT_EXCEEDED;
        ensures policy.spent == old(policy.spent) + action.amount;
        modifies policy.spent;
    }

    spec AgentPolicy {
        invariant spent <= limit;
    }
}
