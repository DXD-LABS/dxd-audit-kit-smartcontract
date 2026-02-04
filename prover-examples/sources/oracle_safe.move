module prover_examples::oracle_safe {

    struct OraclePrice has copy, drop { value: u64, timestamp: u64 }

    /// Get price if fresh enough
    public fun get_price(oracle: &OraclePrice, max_age: u64, current_time: u64): u64 {
        assert!(current_time - oracle.timestamp <= max_age, 200);
        oracle.value
    }

    spec module {
        pragma verify = true;
    }

    spec get_price {
        aborts_if current_time - oracle.timestamp > max_age;
        ensures result == oracle.value;
    }
}