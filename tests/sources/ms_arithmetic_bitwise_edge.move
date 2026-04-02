module vuln_db::ms_arithmetic_bitwise_edge {
    /// ❌ VULNERABLE: No check for val1 size, leading to overflow into val2's bits
    public fun vuln_pack_data(val1: u64, val2: u64): u128 {
        ((val1 as u128) << 64) | (val2 as u128)
    }

    /// ✅ FIXED: Ensure val1 fits within its bits or use a strict mask
    public fun fixed_pack_data(val1: u64, val2: u64): u128 {
        assert!(val1 <= 0xFFFFFFFFFFFFFFFF, 0); 
        ((val1 as u128) << 64) | (val2 as u128)
    }
}
