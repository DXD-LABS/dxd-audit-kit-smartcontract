module vuln_db::ms_parallel_race_object_dependency {
    use sui::object::{Self, UID};

    struct Oracle has key, store {
        id: UID,
        price: u64,
        last_update: u64,
    }

    /// ❌ VULNERABLE: No sequence_number or timestamp check; 
    /// parallel tx might overwrite newer price with older one.
    public fun vuln_update_oracle(oracle: &mut Oracle, price: u64) {
        oracle.price = price;
    }

    /// ✅ FIXED: Enforce monotonic updates via timestamp
    public fun fixed_update_oracle(oracle: &mut Oracle, price: u64, timestamp: u64) {
        assert!(timestamp > oracle.last_update, 0); // E_STALE_UPDATE
        oracle.price = price;
        oracle.last_update = timestamp;
    }
}
