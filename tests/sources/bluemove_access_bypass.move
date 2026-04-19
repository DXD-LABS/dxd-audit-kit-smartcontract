#[allow(lint(self_transfer))]
module vuln_db::bluemove_access_bypass {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::balance::{Self, Balance};
    use sui::transfer;

    struct Vault has key {
        id: UID,
        balance: Balance<SUI>,
        admin_id: ID,
    }

    struct AdminCap has key, store {
        id: UID,
    }

    const E_UNAUTHORIZED: u64 = 1;

    public fun initialize(ctx: &mut TxContext) {
        let admin_cap = AdminCap { id: object::new(ctx) };
        let vault = Vault {
            id: object::new(ctx),
            balance: balance::zero(),
            admin_id: object::id(&admin_cap),
        };
        transfer::transfer(admin_cap, tx_context::sender(ctx));
        transfer::share_object(vault);
    }

    // Vulnerable: missing cap check or sender check
    public fun vuln_withdraw(vault: &mut Vault, amount: u64, ctx: &mut TxContext): Coin<SUI> {
        coin::from_balance(balance::split(&mut vault.balance, amount), ctx)
    }

    // Fixed: requires AdminCap and checks ID
    public fun fixed_withdraw(vault: &mut Vault, cap: &AdminCap, amount: u64, ctx: &mut TxContext): Coin<SUI> {
        assert!(vault.admin_id == object::id(cap), E_UNAUTHORIZED);
        coin::from_balance(balance::split(&mut vault.balance, amount), ctx)
    }

    #[test_only]
    use sui::test_scenario;

    #[test]
    fun test_vuln_exploit() {
        let admin = @0xAD;
        let hacker = @0x666;
        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        // Init
        initialize(test_scenario::ctx(scenario));
        
        test_scenario::next_tx(scenario, admin);
        let vault = test_scenario::take_shared<Vault>(scenario);
        // Admin adds some funds
        let coin = coin::mint_for_testing<SUI>(1000, test_scenario::ctx(scenario));
        balance::join(&mut vault.balance, coin::into_balance(coin));
        test_scenario::return_shared(vault);

        // Hacker attempts exploit
        test_scenario::next_tx(scenario, hacker);
        let vault = test_scenario::take_shared<Vault>(scenario);
        let looted = vuln_withdraw(&mut vault, 1000, test_scenario::ctx(scenario));
        assert!(coin::value(&looted) == 1000, 0);
        transfer::public_transfer(looted, hacker);
        test_scenario::return_shared(vault);
        
        test_scenario::end(scenario_val);
    }

    #[test]
    #[expected_failure(abort_code = E_UNAUTHORIZED)]
    fun test_fixed_prevents_exploit() {
        let admin = @0xAD;
        let hacker = @0x666;
        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        initialize(test_scenario::ctx(scenario));
        
        test_scenario::next_tx(scenario, admin);
        let vault = test_scenario::take_shared<Vault>(scenario);
        let coin = coin::mint_for_testing<SUI>(1000, test_scenario::ctx(scenario));
        balance::join(&mut vault.balance, coin::into_balance(coin));
        test_scenario::return_shared(vault);

        // Hacker attempts exploit on fixed version but has NO AdminCap
        test_scenario::next_tx(scenario, hacker);
        let vault = test_scenario::take_shared<Vault>(scenario);
        // This should fail because hacker doesn't have the AdminCap to pass in
        // In a real exploit, they might try to pass a dummy AdminCap, which should also fail.
        let dummy_cap = AdminCap { id: object::new(test_scenario::ctx(scenario)) };
        let looted = fixed_withdraw(&mut vault, &dummy_cap, 1000, test_scenario::ctx(scenario));
        
        transfer::public_transfer(looted, hacker);
        let AdminCap { id } = dummy_cap;
        object::delete(id);
        test_scenario::return_shared(vault);
        test_scenario::end(scenario_val);
    }
}
