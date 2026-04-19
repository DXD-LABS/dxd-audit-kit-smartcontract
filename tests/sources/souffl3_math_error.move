module vuln_db::souffl3_math_error {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;

    struct Vault has key {
        id: UID,
        assets: Balance<SUI>,
        total_shares: u64,
    }

    public fun new_vault(ctx: &mut TxContext): Vault {
        Vault {
            id: object::new(ctx),
            assets: balance::zero(),
            total_shares: 0,
        }
    }

    // Vulnerable shares to amount: always rounds down
    public fun shares_to_amount_vuln(vault: &Vault, shares: u64): u64 {
        let total_assets = balance::value(&vault.assets);
        let total_shares = vault.total_shares;
        if (total_shares == 0) return shares;
        (shares * total_assets) / total_shares
    }

    // Fixed: explicit rounding direction
    public fun shares_to_amount_fixed(vault: &Vault, shares: u64, round_up: bool): u64 {
        let total_assets = balance::value(&vault.assets);
        let total_shares = vault.total_shares;
        if (total_shares == 0) return shares;
        
        let numerator = (shares as u128) * (total_assets as u128);
        let denominator = (total_shares as u128);
        
        if (round_up && (numerator % denominator > 0)) {
            ((numerator / denominator) + 1 as u64)
        } else {
            (numerator / denominator as u64)
        }
    }

    #[test_only]
    use sui::test_scenario;
    #[test_only]
    use sui::coin;

    #[test]
    fun test_rounding_exploit() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;
        
        let vault = new_vault(test_scenario::ctx(scenario));
        
        // Initial state: 100 assets, 100 shares
        let initial_coin = coin::mint_for_testing<SUI>(100, test_scenario::ctx(scenario));
        balance::join(&mut vault.assets, coin::into_balance(initial_coin));
        vault.total_shares = 100;

        // User wants to withdraw 1.5 worth of assets with 1 share? 
        // No, let's say 1 share should be worth 1 asset.
        // If assets = 105, shares = 100. 1 share = 1.05 assets.
        let extra_coin = coin::mint_for_testing<SUI>(5, test_scenario::ctx(scenario));
        balance::join(&mut vault.assets, coin::into_balance(extra_coin));
        
        // shares_to_amount_vuln(1) -> (1 * 105) / 100 = 1 (rounds down, GOOD for vault)
        // Wait, the exploit is usually when rounding favors the USER.
        // For example, in REDEEM, rounding DOWN favors the VAULT.
        // In DEPOSIT, rounding DOWN favors the USER (fewer shares for same assets? No.)
        
        // Let's check another case: shares_to_amount for WITHDRAWAL.
        // If I have 1 share, I get 1 asset. 0.05 stays in vault.
        // If I do this 100 times, the vault loses less? No.
        
        // Correct logic for exploit:
        // Rounding FAVORING USER: 
        // 1. Withdrawal: Rounding UP (User gets more assets for same shares) -> BAD
        // 2. Deposit: Rounding DOWN (User gets more shares for same assets) -> BAD
        
        // Souffl3's bug was that they rounded in the wrong direction for the specific operation.
        let amount = shares_to_amount_vuln(&vault, 1);
        assert!(amount == 1, 0); 
        
        let amount_fixed_up = shares_to_amount_fixed(&vault, 1, true);
        assert!(amount_fixed_up == 2, 0); // Correctly rounds up to 2 if specified

        let Vault { id, assets, total_shares: _ } = vault;
        balance::destroy_for_testing(assets);
        object::delete(id);
        test_scenario::end(scenario_val);
    }
}
