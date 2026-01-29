#[allow(lint(public_entry))]
module vuln_db::cetus_overflow {
    const E_OVERFLOW: u64 = 1;
    const MAX_SHIFT_FIXED: u8 = 192;

    public fun vuln_shlw(x: u64, shift: u8): u64 {
        // Wrong upper bound allows unsafe shift values.
        if (shift > 255) abort E_OVERFLOW;
        if (shift > MAX_SHIFT_FIXED) {
            // Simulate overflow effect for educational PoC.
            return x + 1000
        };
        x
    }

    public fun fixed_shlw(x: u64, shift: u8): u64 {
        if (shift > MAX_SHIFT_FIXED) abort E_OVERFLOW;
        x
    }

    #[test]
    fun test_exploit() {
        let result = vuln_shlw(1, 200);
        assert!(result == 1001, 0);
    }

    #[test]
    #[expected_failure(abort_code = E_OVERFLOW, location = vuln_db::cetus_overflow)]
    fun test_fixed() {
        fixed_shlw(1, 200);
    }

    public entry fun exploit() {
        let result = vuln_shlw(1, 200);
        assert!(result > 1, 0);
    }
}
