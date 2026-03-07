#[allow(lint(coin_field))]
module agent_specific::agent_delegated_cap_misuse {
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    const EMisusedCap: u64 = 1;

    /// Represent a sensitive admin action capability delegated to the agent
    public struct AdminCap has key, store {
        id: UID,
    }

    /// The agent holding the cap for limited purposes
    public struct AgentContext has key {
        id: UID,
        delegate_cap: Option<AdminCap>,
        treasury: Coin<SUI>,
    }

    public fun init_agent(fund: Coin<SUI>, ctx: &mut TxContext) {
        let agent = AgentContext {
            id: object::new(ctx),
            delegate_cap: std::option::none(),
            treasury: fund,
        };
        transfer::share_object(agent);
    }

    /// Agent receives the cap for a specific workflow
    public fun delegate_cap(agent: &mut AgentContext, cap: AdminCap) {
        std::option::fill(&mut agent.delegate_cap, cap);
    }

    /// Vulnerable: Agent uses the capability to do an action outside of the intended scope
    /// (e.g., extracting treasury funds instead of specific intended admin functions)
    public fun misuse_cap_vulnerable(
        agent: &mut AgentContext,
        target: address,
        amount: u64,
        ctx: &mut TxContext,
    ) {
        // ❌ If the agent has the capability, it arbitrarily abuses it for extraction
        assert!(std::option::is_some(&agent.delegate_cap), EMisusedCap);
        let extracted = coin::split(&mut agent.treasury, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    /// Represents a verified intent proof
    public struct IntentProof has drop {
        is_valid: bool,
    }

    #[test_only]
    public fun verify_intent(is_valid: bool): IntentProof {
        IntentProof { is_valid }
    }

    /// Fixed: Binds the capability to explicit, verified intents.
    public fun use_cap_fixed(
        agent: &mut AgentContext,
        target: address,
        amount: u64,
        proof: IntentProof,
        ctx: &mut TxContext,
    ) {
        assert!(std::option::is_some(&agent.delegate_cap), EMisusedCap);
        // ✅ Enforce MSL invariant: only execute if intent explicitly verified
        assert!(proof.is_valid, EMisusedCap);
        let extracted = coin::split(&mut agent.treasury, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    #[test_only]
    public fun init_test(ctx: &mut TxContext): AdminCap {
        let coin = coin::mint_for_testing<SUI>(100_000, ctx);
        init_agent(coin, ctx);
        AdminCap { id: object::new(ctx) }
    }
}
