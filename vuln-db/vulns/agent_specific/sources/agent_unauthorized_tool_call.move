#[allow(lint(coin_field))]
module agent_specific::agent_unauthorized_tool_call {
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use std::string::String;

    const EUnauthorizedAction: u64 = 1;

    /// The Agent's Wallet representing treasury funds they manage.
    public struct AgentWallet has key {
        id: UID,
        balance: Coin<SUI>,
        owner: address,
    }

    /// Represents an AI agent's execution intent generated off-chain (e.g., via LLM).
    public struct AgentIntent has drop {
        action: String,
        target: address,
        amount: u64,
        prompt_injected: bool,
    }

    #[test_only]
    public fun create_intent(action: String, target: address, amount: u64, prompt_injected: bool): AgentIntent {
        AgentIntent { action, target, amount, prompt_injected }
    }

    /// Create a new AgentWallet funded with some SUI.
    public fun create_wallet(fund: Coin<SUI>, ctx: &mut TxContext) {
        let wallet = AgentWallet {
            id: object::new(ctx),
            balance: fund,
            owner: ctx.sender(),
        };
        transfer::share_object(wallet);
    }

    /// Vulnerable: Trusts the `intent` blindly without verifying it matches user constraints
    public fun execute_tool_vulnerable(
        wallet: &mut AgentWallet,
        _action_name: String,
        target: address,
        amount: u64,
        ctx: &mut TxContext,
    ) {
        // ❌ No check — action is executed regardless of whether intent is spoofed/injected
        let extracted = coin::split(&mut wallet.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    /// Fixed: Requires a verifiable proof that intent matches the user's actual request.
    public fun execute_tool_fixed(
        wallet: &mut AgentWallet,
        intent: AgentIntent,
        ctx: &mut TxContext,
    ) {
        // ✅ Require a verifiable proof object directly representing the request
        assert!(!intent.prompt_injected, EUnauthorizedAction);
        let extracted = coin::split(&mut wallet.balance, intent.amount, ctx);
        transfer::public_transfer(extracted, intent.target);
    }

    #[test_only]
    public fun init_test(ctx: &mut TxContext) {
        let coin = coin::mint_for_testing<SUI>(100_000, ctx);
        create_wallet(coin, ctx);
    }
}
