module vuln_db::dynamic_field_collision {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::dynamic_field;
    use std::string::{String};

    struct Registry has key {
        id: UID,
    }

    struct UserConfig has store, drop {
        value: u64,
    }

    public fun new_registry(ctx: &mut TxContext): Registry {
        Registry { id: object::new(ctx) }
    }

    // Vulnerable: allows overwriting any field if name is known
    public fun vuln_set_config(reg: &mut Registry, name: String, value: u64) {
        if (dynamic_field::exists_(&reg.id, name)) {
            let config = dynamic_field::borrow_mut<String, UserConfig>(&mut reg.id, name);
            config.value = value; // OVERWRITES WITHOUT AUTH
        } else {
            dynamic_field::add(&mut reg.id, name, UserConfig { value });
        }
    }

    // Fixed: uses sender address as the unique key to prevent collisions
    public fun fixed_set_config(reg: &mut Registry, value: u64, ctx: &TxContext) {
        let sender = tx_context::sender(ctx);
        
        if (dynamic_field::exists_(&reg.id, sender)) {
            let config = dynamic_field::borrow_mut<address, UserConfig>(&mut reg.id, sender);
            config.value = value;
        } else {
            dynamic_field::add(&mut reg.id, sender, UserConfig { value });
        }
    }

    #[test_only]
    use sui::test_scenario;
    #[test_only]
    use std::string;

    #[test]
    fun test_collision_exploit() {
        let scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;
        
        let reg = new_registry(test_scenario::ctx(scenario));
        let field_name = string::utf8(b"shared_config");

        // Admin sets initial config
        vuln_set_config(&mut reg, field_name, 100);
        
        // Hacker overwrites it
        test_scenario::next_tx(scenario, @0x666);
        vuln_set_config(&mut reg, field_name, 0); // Malicious overwrite
        
        let config = dynamic_field::borrow<String, UserConfig>(&reg.id, field_name);
        assert!(config.value == 0, 0);

        let Registry { id } = reg;
        object::delete(id);
        test_scenario::end(scenario_val);
    }
}
