#[allow(lint(public_entry))]
module vuln_db::upgrade_abort {
    const E_VERSION_MISMATCH: u64 = 5;

    public fun vuln_can_upgrade(_cap_version: u64, _target_version: u64): bool {
        // Missing strict version equality check.
        true
    }

    public fun fixed_can_upgrade(cap_version: u64, target_version: u64): bool {
        if (cap_version != target_version) abort E_VERSION_MISMATCH;
        true
    }

    #[test]
    fun test_exploit() {
        let ok = vuln_can_upgrade(1, 2);
        assert!(ok, 0);
    }

    #[test]
    #[expected_failure(abort_code = E_VERSION_MISMATCH, location = vuln_db::upgrade_abort)]
    fun test_fixed() {
        fixed_can_upgrade(1, 2);
    }

    public entry fun exploit() {
        let ok = vuln_can_upgrade(1, 2);
        assert!(ok, 0);
    }
}
