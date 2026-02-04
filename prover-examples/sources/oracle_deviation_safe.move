module examples::oracle_deviation_safe {
    struct OraclePrice has copy, drop { value: u64, timestamp: u64 }

    const MAX_DEVIATION: u64 = 5;  // % deviation allowed
    const MAX_AGE: u64 = 300;      // seconds

    public fun safe_price_check(current: &OraclePrice, reference: &OraclePrice, current_time: u64): u64 {
        assert!(current_time - current.timestamp &lt;= MAX_AGE, 500);  // Fresh
        let deviation = if (reference.value &gt; current.value) {
            (reference.value - current.value) * 100 / reference.value
        } else {
            (current.value - reference.value) * 100 / current.value
        };
        assert!(deviation &lt;= MAX_DEVIATION, 501);  // No excessive deviation
        current.value
    }

    spec module {
        pragma verify = true;
    }

    spec safe_price_check {
        aborts_if current_time - current.timestamp &gt; MAX_AGE;
        aborts_if deviation(current, reference) &gt; MAX_DEVIATION;
        ensures result == current.value;
        // Invariant: Price chỉ accept nếu fresh &amp; trong deviation bound
    }

    spec fun deviation(p1: OraclePrice, p2: OraclePrice): u64 {
        if (p1.value &gt; p2.value) { (p1.value - p2.value) * 100 / p2.value } else { (p2.value - p1.value) * 100 / p1.value }
    }
}