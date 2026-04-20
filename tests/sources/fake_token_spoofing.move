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
    public fun vuln_deposit<T>(_pool: &mut Pool, payment: Coin<T>, ctx: &mut TxContext) {
        // This is extremely dangerous - we are adding type T to a Balance of SUI?
        // Move won't allow balance::join(&mut Balance<SUI>, Coin<T>) because types must match.
        
        let _value = coin::value(&payment);
        // Protocol logic: "Success!" - but we just transfer the (possibly fake) coin to the sender
        // instead of actually pooling it, to show the lack of type verification.
        sui::transfer::public_transfer(payment, sui::tx_context::sender(ctx));
    }

    // Fixed: enforce T == SUI by signature
    public fun fixed_deposit(pool: &mut Pool, payment: Coin<SUI>) {
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
        vuln_deposit(&mut pool, fake_coin, test_scenario::ctx(scenario));
        
        let Pool { id, sui_reserve } = pool;
        balance::destroy_for_testing(sui_reserve);
        object::delete(id);
        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_fixed_prevents_spoof() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;
        let pool = new_pool(test_scenario::ctx(scenario));
        
        // Fixed function works with real SUI
        let real_sui = coin::mint_for_testing<SUI>(1000, test_scenario::ctx(scenario));
        fixed_deposit(&mut pool, real_sui);
        
        let Pool { id, sui_reserve } = pool;
        assert!(balance::value(&sui_reserve) == 1000, 0);
        
        balance::destroy_for_testing(sui_reserve);
        object::delete(id);
        test_scenario::end(scenario_val);
    }
}
