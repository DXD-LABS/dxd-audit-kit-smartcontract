#[allow(lint(coin_field))]
module agent_specific::agent_no_verifiable_intent {
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    const EMissingIntentProof: u64 = 1;

    public struct AgentWallet has key {
        id: UID,
        balance: Coin<SUI>,
        owner: address,
    }

    public fun init_agent(fund: Coin<SUI>, ctx: &mut TxContext) {
        let wallet = AgentWallet {
            id: object::new(ctx),
            balance: fund,
            owner: ctx.sender(),
        };
        transfer::share_object(wallet);
    }

    /// Vulnerable: Agent executes an action with no verifiable proof of user intent.
    public fun execute_action_vulnerable(
        wallet: &mut AgentWallet,
        target: address,
        amount: u64,
        ctx: &mut TxContext,
    ) {
        // ❌ Rogue agent executes freely — no proof required
        let extracted = coin::split(&mut wallet.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    /// Represents a verified intent (e.g., MSL invariant passing or zkTLS proof valid)
    public struct IntentProof has drop {
        is_valid: bool,
    }

    /// Helper to mint a proof for testing
    #[test_only]
    public fun verify_intent(is_valid: bool): IntentProof {
        IntentProof { is_valid }
    }

    /// Fixed: Requires a verifiable intent proof parameter
    public fun execute_action_fixed(
        wallet: &mut AgentWallet,
        target: address,
        amount: u64,
        proof: IntentProof,
        ctx: &mut TxContext,
    ) {
        // ✅ Agent can only execute when a valid intent proof is supplied
        assert!(proof.is_valid, EMissingIntentProof);
        let extracted = coin::split(&mut wallet.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    #[test_only]
    public fun init_test(ctx: &mut TxContext) {
        let coin = coin::mint_for_testing<SUI>(100_000, ctx);
        init_agent(coin, ctx);
    }
}
