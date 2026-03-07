#[allow(lint(coin_field))]
module agent_specific::agent_spend_limit_bypass {

    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    const EOverSpendLimit: u64 = 1;

    /// Agent configuration holding a global spend limit.
    public struct AgentConfig has key {
        id: UID,
        spend_limit: u64,
        treasury: Coin<SUI>,
        // Vulnerable: Off-chain memory poisoning can manipulate this state if not properly isolated
        current_spent: u64,
        memory_tainted: bool,
    }

    public fun init_agent(limit: u64, fund: Coin<SUI>, ctx: &mut TxContext) {
        let config = AgentConfig {
            id: object::new(ctx),
            spend_limit: limit,
            treasury: fund,
            current_spent: 0,
            memory_tainted: false,
        };
        transfer::share_object(config);
    }

    /// Vulnerable: Relies on off-chain state that can be poisoned.
    public fun execute_workflow_step_vulnerable(
        config: &mut AgentConfig,
        amount: u64,
        target: address,
        ctx: &mut TxContext,
    ) {
        // ❌ Simulate memory poisoning: attacker resets current_spent via tainted flag
        if (config.memory_tainted) {
            config.current_spent = 0;
        };
        assert!(config.current_spent + amount <= config.spend_limit, EOverSpendLimit);
        let extracted = coin::split(&mut config.treasury, amount, ctx);
        transfer::public_transfer(extracted, target);
        config.current_spent = config.current_spent + amount;
    }

    /// Attacker function to simulate off-chain memory poisoning (e.g., via compromised RAG).
    public fun poison_memory(config: &mut AgentConfig) {
        config.memory_tainted = true;
    }

    /// Fixed: Hard enforcement via invariant limits that cannot be bypassed by memory state.
    public fun execute_workflow_step_fixed(
        config: &mut AgentConfig,
        amount: u64,
        target: address,
        ctx: &mut TxContext,
    ) {
        // ✅ Always enforce cumulative limit — ignores transient mutable flags
        assert!(config.current_spent + amount <= config.spend_limit, EOverSpendLimit);
        let extracted = coin::split(&mut config.treasury, amount, ctx);
        transfer::public_transfer(extracted, target);
        config.current_spent = config.current_spent + amount;
    }

    #[test_only]
    public fun init_test(ctx: &mut TxContext) {
        let coin = coin::mint_for_testing<SUI>(100_000, ctx);
        init_agent(10_000, coin, ctx);
    }
}
