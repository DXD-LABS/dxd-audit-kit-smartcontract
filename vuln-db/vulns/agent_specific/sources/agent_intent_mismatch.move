#[allow(lint(coin_field))]
module agent_specific::agent_intent_mismatch {

    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::hash;
    use std::bcs;

    const EIntentMismatch: u64 = 1;

    public struct AgentWallet has key {
        id: UID,
        balance: Coin<SUI>,
    }

    public fun init_agent(fund: Coin<SUI>, ctx: &mut TxContext) {
        let wallet = AgentWallet {
            id: object::new(ctx),
            balance: fund,
        };
        transfer::share_object(wallet);
    }

    /// Vulnerable: Does not cryptographically tie the execution to the approved off-chain hash
    public fun execute_vulnerable(
        wallet: &mut AgentWallet,
        target: address,
        amount: u64,
        _offchain_intent_hash: vector<u8>,
        ctx: &mut TxContext,
    ) {
        // ❌ Off-chain intent hash is accepted but completely ignored
        let extracted = coin::split(&mut wallet.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    /// Fixed: Requires the off-chain intent hash to match the on-chain execution parameters
    public fun execute_fixed(
        wallet: &mut AgentWallet,
        target: address,
        amount: u64,
        offchain_intent_hash: vector<u8>,
        ctx: &mut TxContext,
    ) {
        // ✅ Derive on-chain hash from actual execution parameters
        let mut payload = bcs::to_bytes(&target);
        let amount_bytes = bcs::to_bytes(&amount);
        payload.append(amount_bytes);
        let onchain_hash = hash::blake2b256(&payload);
        // ✅ Abort if parameters were tampered vs. approved intent
        assert!(onchain_hash == offchain_intent_hash, EIntentMismatch);
        let extracted = coin::split(&mut wallet.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    #[test_only]
    public fun init_test(ctx: &mut TxContext) {
        let coin = coin::mint_for_testing<SUI>(100_000, ctx);
        init_agent(coin, ctx);
    }
}
