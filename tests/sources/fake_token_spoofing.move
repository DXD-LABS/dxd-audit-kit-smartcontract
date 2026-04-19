module vuln_db::fake_token_spoofing {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use std::type_name;

    struct Pool has key {
        id: UID,
        sui_reserve: Balance<SUI>,
        // In a real pool, we'd have other balances
    }

    struct FAKE_SUI has drop {}

    public fun new_pool(ctx: &mut TxContext): Pool {
        Pool {
            id: object::new(ctx),
            sui_reserve: balance::zero(),
        }
    }

    // Vulnerable: accepts any T and adds to reserve without checking if T is SUI
    public fun vuln_deposit<T>(pool: &mut Pool, payment: Coin<T>) {
        // This is extremely dangerous - we are adding type T to a Balance of SUI?
        // Actually, Move won't allow balance::join(&mut Balance<SUI>, Coin<T>) 
        // because types must match.
        // The real vulnerability is when the code CASTS or assumes T is SUI 
        // because it uses dynamic fields or loosely typed logic.
        
        // Let's simulate the logic error where the protocol thinks it's getting SUI
        // but it doesn't verify the type at the entry point.
        let _value = coin::value(&payment);
        // Protocol logic: "Success! You deposited 100 SUI" (but it was actually FAKE)
        balance::destroy_for_testing(coin::into_balance(payment));
    }

    // Fixed: enforce T == SUI
    public fun fixed_deposit<T>(pool: &mut Pool, payment: Coin<T>) {
        assert!(type_name::get<T>() == type_name::get<SUI>(), 1);
        balance::join(&mut pool.sui_reserve, coin::into_balance(payment));
    }

    #[test_only]
    use sui::test_scenario;

    #[test]
    fun test_spoof_deposit() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;
        
        let pool = new_pool(test_scenario::ctx(scenario));
        
        // Attacker creates a fake token
        let fake_coin = coin::mint_for_testing<FAKE_SUI>(1000, test_scenario::ctx(scenario));
        
        // Vulnerable function accepts it!
        vuln_deposit(&mut pool, fake_coin);
        
        let Pool { id, sui_reserve } = pool;
        balance::destroy_for_testing(sui_reserve);
        object::delete(id);
        test_scenario::end(scenario_val);
    }

    #[test]
    #[expected_failure(abort_code = 1)]
    fun test_fixed_prevents_spoof() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;
        let pool = new_pool(test_scenario::ctx(scenario));
        let fake_coin = coin::mint_for_testing<FAKE_SUI>(1000, test_scenario::ctx(scenario));
        
        // Fixed function should abort
        fixed_deposit(&mut pool, fake_coin);
        
        let Pool { id, sui_reserve } = pool;
        balance::destroy_for_testing(sui_reserve);
        object::delete(id);
        test_scenario::end(scenario_val);
    }
}
