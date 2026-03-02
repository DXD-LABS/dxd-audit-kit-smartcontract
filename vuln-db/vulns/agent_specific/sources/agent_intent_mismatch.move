#[allow(unused_variable, lint(unused_variable))]
module agent_specific::agent_intent_mismatch {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::hash;
    use std::vector;
    use std::bcs;

    const EIntentMismatch: u64 = 1;

    public struct AgentWallet has key {
        id: UID,
        balance: coin::Coin<SUI>,
    }

    public fun init_agent(fund: Coin<SUI>, ctx: &mut TxContext) {
        let wallet = AgentWallet {
            id: object::new(ctx),
            balance: fund,
        };
        transfer::share_object(wallet);
    }

    /// Vulnerable: Does not cryptographically tie the execution to the approved off-chain hash
    public entry fun execute_vulnerable(
        wallet: &mut AgentWallet,
        target: address,
        amount: u64,
        offchain_intent_hash: vector<u8>, 
        ctx: &mut TxContext
    ) {
        // Attacker ignores the off-chain intent hash entirely and executes arbitrarily
        let extracted = coin::split(&mut wallet.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    /// Fixed: Requires the off-chain intent hash to match the on-chain execution parameters
    public entry fun execute_fixed(
        wallet: &mut AgentWallet,
        target: address,
        amount: u64,
        offchain_intent_hash: vector<u8>,
        ctx: &mut TxContext
    ) {
        // Calculate on-chain hash of the executed action
        let mut payload = vector::empty<u8>();
        vector::append(&mut payload, bcs::to_bytes(&target));
        vector::append(&mut payload, bcs::to_bytes(&amount));
        let onchain_hash = hash::blake2b256(&payload);

        // Mitigation: Abort if mismatch
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
