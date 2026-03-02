#[allow(unused_variable, lint(unused_variable))]
module agent_specific::agent_unauthorized_tool_call {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use std::string::{Self, String, utf8};

    /// Error codes
    const EUnauthorizedAction: u64 = 1;

    /// The Agent's Wallet representing treasury funds they manage.
    public struct AgentWallet has key {
        id: UID,
        balance: coin::Coin<SUI>,
        owner: address,
    }

    /// Represents an AI agent's execution intent generated off-chain (e.g., via LLM).
    public struct AgentIntent has store, drop {
        action: String,
        target: address,
        amount: u64,
        prompt_injected: bool
    }

    /// Create a new AgentWallet funded with some SUI.
    public fun create_wallet(fund: Coin<SUI>, ctx: &mut TxContext) {
        let wallet = AgentWallet {
            id: object::new(ctx),
            balance: fund,
            owner: tx_context::sender(ctx)
        };
        transfer::share_object(wallet);
    }

    /// Vulnerable tool execution: Trusts the `intent` blindly without verifying it matches user constraints
    /// or checking if a prompt injection flag is true.
    public entry fun execute_tool_vulnerable(
        wallet: &mut AgentWallet,
        action_name: String,
        target: address,
        amount: u64,
        ctx: &mut TxContext
    ) {
        // Vulnerability: No check to see if the action is authorized or if intent is spoofed/injected!
        // We just act on the supplied intent.
        
        let extracted = coin::split(&mut wallet.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    /// Fixed tool execution: Ensures programmable guardrails or invariants hold.
    public entry fun execute_tool_fixed(
        wallet: &mut AgentWallet,
        action_name: String,
        target: address,
        amount: u64,
        intent_verified: bool, // Required MSL-like verification proof
        ctx: &mut TxContext
    ) {
        // Mitigation: Require a verifiable proof that intent matches the user's actual request.
        assert!(intent_verified == true, EUnauthorizedAction);

        let extracted = coin::split(&mut wallet.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    #[test_only]
    public fun init_test(ctx: &mut TxContext) {
        let coin = coin::mint_for_testing<SUI>(100_000, ctx);
        create_wallet(coin, ctx);
    }
}
