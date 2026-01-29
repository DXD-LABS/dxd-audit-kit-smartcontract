#[allow(lint(public_entry))]
module vuln_db::hamsterwheel_dos {
    const E_DOS: u64 = 2;
    const MAX_STEPS: u64 = 10000;

    public fun vuln_validate_cfg(steps: u64): bool {
        // Missing upper bound allows adversarially large graphs.
        steps > 0
    }

    public fun fixed_validate_cfg(steps: u64): bool {
        if (steps > MAX_STEPS) abort E_DOS;
        steps > 0
    }

    #[test]
    fun test_exploit() {
        let ok = vuln_validate_cfg(1_000_000);
        assert!(ok, 0);
    }

    #[test]
    #[expected_failure(abort_code = E_DOS, location = vuln_db::hamsterwheel_dos)]
    fun test_fixed() {
        fixed_validate_cfg(1_000_000);
    }

    public entry fun exploit() {
        let ok = vuln_validate_cfg(1_000_000);
        assert!(ok, 0);
    }
}
