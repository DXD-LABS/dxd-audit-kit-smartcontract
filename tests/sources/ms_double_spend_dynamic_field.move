module vuln_db::ms_double_spend_dynamic_field {
    use sui::object::UID;
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::dynamic_field;

    /// ❌ VULNERABLE: Logic error allowing re-adding without checking amount or source
    public fun vuln_reallocate_value(parent: &mut UID, key: vector<u8>) {
        if (dynamic_field::exists_(parent, key)) {
            let val: Balance<SUI> = dynamic_field::remove(parent, key);
            // In a real exploit, the attacker might swap 'val' for a different one here
            dynamic_field::add(parent, key, val);
        };
    }

    /// ✅ FIXED: Strictly validate the value being added back
    public fun fixed_reallocate_value(parent: &mut UID, key: vector<u8>, val: Balance<SUI>) {
        // Validation check should be here
        assert!(balance::value(&val) > 0, 0); 
        dynamic_field::add(parent, key, val);
    }
}
