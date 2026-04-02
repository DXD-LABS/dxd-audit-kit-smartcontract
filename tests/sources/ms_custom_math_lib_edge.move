module vuln_db::ms_custom_math_lib_edge {
    /// ❌ VULNERABLE: Standard integer division rounds down, 
    /// which might be favorable to the borrower in debt calculation.
    public fun vuln_calc_interest(principal: u64, rate: u64): u64 {
        (principal * rate) / 10000
    }

    /// ✅ FIXED: Explicitly round up for debt/interest to favor protocol solvency
    public fun fixed_calc_interest(principal: u64, rate: u64): u64 {
        let scaled = principal * rate;
        let result = scaled / 10000;
        if (scaled % 10000 > 0) result = result + 1;
        result
    }
}
