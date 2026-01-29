#[allow(lint(public_entry))]
module vuln_db::oracle_manipulation {
    const E_STALE: u64 = 3;
    const E_TIME: u64 = 4;
    const MAX_STALE_SECS: u64 = 60;

    public fun vuln_price(price: u64, _last_updated: u64, _now: u64): u64 {
        // Missing staleness guard accepts old prices.
        price
    }

    public fun fixed_price(price: u64, last_updated: u64, now: u64): u64 {
        if (now < last_updated) abort E_TIME;
        if (now - last_updated > MAX_STALE_SECS) abort E_STALE;
        price
    }

    #[test]
    fun test_exploit() {
        let result = vuln_price(100, 0, 1000);
        assert!(result == 100, 0);
    }

    #[test]
    #[expected_failure(abort_code = E_STALE, location = vuln_db::oracle_manipulation)]
    fun test_fixed() {
        fixed_price(100, 0, 1000);
    }

    public entry fun exploit() {
        let result = vuln_price(100, 0, 1000);
        assert!(result == 100, 0);
    }
}
