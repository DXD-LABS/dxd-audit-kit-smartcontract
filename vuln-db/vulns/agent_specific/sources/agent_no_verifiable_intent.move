#[allow(unused_variable, lint(unused_variable))]
module agent_specific::agent_no_verifiable_intent {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    const EMissingIntentProof: u64 = 1;

    public struct AgentWallet has key {
        id: UID,
        balance: coin::Coin<SUI>,
        owner: address
    }

    public fun init_agent(fund: Coin<SUI>, ctx: &mut TxContext) {
        let wallet = AgentWallet {
            id: object::new(ctx),
            balance: fund,
            owner: tx_context::sender(ctx)
        };
        transfer::share_object(wallet);
    }

    /// Vulnerable: Agent executes an action based entirely on a prompt/off-chain trigger 
    /// without any verifiable zero knowledge or cryptographic proof proving it matched 
    /// a user's signed intent.
    public entry fun execute_action_vulnerable(
        wallet: &mut AgentWallet,
        target: address,
        amount: u64,
        ctx: &mut TxContext
    ) {
        // Attack: Rogue agent just executes this because there is no proof required
        let extracted = coin::split(&mut wallet.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    /// Represents a verified intent (e.g., MSL invariant passing or zkTLS proof valid)
    public struct IntentProof has drop {
        is_valid: bool
    }

    /// Helper for testing to mint a valid proof
    public fun verify_intent(is_valid: bool): IntentProof {
        IntentProof { is_valid }
    }

    /// Fixed: Requires a verifiable intent proof parameter
    public fun execute_action_fixed(
        wallet: &mut AgentWallet,
        target: address,
        amount: u64,
        proof: IntentProof,
        ctx: &mut TxContext
    ) {
        // Mitigation: Agent cannot execute arbitrarily unless a valid intent proof is supplied
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
