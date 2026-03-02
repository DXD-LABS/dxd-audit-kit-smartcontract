#[allow(unused_variable, lint(unused_variable))]
module agent_specific::agent_delegated_cap_misuse {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
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
        treasury: coin::Coin<SUI>,
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
    public entry fun delegate_cap(agent: &mut AgentContext, cap: AdminCap) {
        std::option::fill(&mut agent.delegate_cap, cap);
    }

    /// Vulnerable: Agent uses the capability to do an action outside of the intended scope 
    /// (e.g., extracting treasury funds instead of specific intended admin functions)
    public entry fun misuse_cap_vulnerable(
        agent: &mut AgentContext,
        target: address,
        amount: u64,
        ctx: &mut TxContext
    ) {
        // Attack: If the agent has the capability, it arbitrarily abuses it for extraction without intent check
        assert!(std::option::is_some(&agent.delegate_cap), EMisusedCap);
        
        let extracted = coin::split(&mut agent.treasury, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    /// Fixed: Binds the capability to explicit, verified intents.
    public entry fun use_cap_fixed(
        agent: &mut AgentContext,
        target: address,
        amount: u64,
        intent_verified: bool,
        ctx: &mut TxContext
    ) {
        assert!(std::option::is_some(&agent.delegate_cap), EMisusedCap);
        assert!(intent_verified == true, EMisusedCap); // Enforce MSL invariant 
        
        // ... execute the specific narrow scope action (example below is dummy transfer)
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
