module vuln_db::shared_object_race {
    struct SharedObj has key, store {
        id: sui::object::UID,
        value: u64,
        version: u64
    }

    const E_RACE: u64 = 101;

    // Vulnerable: No version check, prone to race conditions in parallel execution
    public fun vuln_update_shared(obj: &mut SharedObj) {
        obj.value = obj.value + 1;
    }

    // Fixed: Enforce version check to ensure sequential updates
    public fun fixed_update_shared(obj: &mut SharedObj, expected_version: u64) {
        assert!(obj.version == expected_version, E_RACE);
        obj.value = obj.value + 1;
        obj.version = obj.version + 1;
    }
}
