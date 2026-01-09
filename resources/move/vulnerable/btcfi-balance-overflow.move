/// Module: vuln::btcfi_balance_abuse
/// Description: 
/// EN: VULNERABILITY - Custom balance logic leading to overflow/underflow.
/// VI: LỖ HỔNG - Logic balance tùy chỉnh dẫn đến tràn số (overflow/underflow).
/// ZH: 漏洞 - 自定义余额逻辑导致溢出/欠载。

module vuln::btcfi_balance_abuse {
    struct UnsafeBalance has store { value: u64 }

    public entry fun add_balance(b: &mut UnsafeBalance, amount: u64) {
        b.value = b.value + amount; // LỖ HỔNG/VULN: Overflow if u64 max (溢出)
    }
}

// Fix:
// EN: Use sui::balance::Balance<T> which has built-in safety checks.
// VI: Sử dụng sui::balance::Balance<T> đã có sẵn các kiểm tra an toàn.
// ZH: 使用具有内置安全检查的 sui::balance::Balance<T>。