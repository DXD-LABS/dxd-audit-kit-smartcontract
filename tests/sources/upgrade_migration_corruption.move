module vuln_db::upgrade_migration_corruption {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};

    struct Vault has key {
        id: UID,
        version: u64,
        is_locked: bool,
    }

    public fun new_vault(ctx: &mut TxContext): Vault {
        Vault {
            id: object::new(ctx),
            version: 1,
            is_locked: false,
        }
    }

    // Vulnerable: anyone can trigger migration to next version
    public fun vuln_migrate(vault: &mut Vault) {
        vault.version = vault.version + 1;
        // Migration logic might do dangerous things like unlocking
        vault.is_locked = false;
    }

    // Fixed: would normally require UpgradeCap, but here we'll mock with an Admin Check
    // In a real Sui upgrade, it might check package ID or use a custom Admin Cap.
    public fun fixed_migrate(vault: &mut Vault, admin_check: bool) {
        assert!(admin_check == true, 1);
        vault.version = vault.version + 1;
        vault.is_locked = false;
    }

    #[test_only]
    use sui::test_scenario;

    #[test]
    fun test_unauthorized_migration() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;
        
        let vault = new_vault(test_scenario::ctx(scenario));
        vault.is_locked = true;

        // Hacker triggers migration
        test_scenario::next_tx(scenario, @0x666);
        vuln_migrate(&mut vault);
        
        assert!(vault.version == 2, 0);
        assert!(vault.is_locked == false, 0);

        let Vault { id, version: _, is_locked: _ } = vault;
        object::delete(id);
        test_scenario::end(scenario_val);
    }
}
