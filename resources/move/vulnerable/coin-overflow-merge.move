/// Module: vuln::coin_overflow
/// Description: LỖI – Custom balance merge → overflow | ERROR – Custom balance merge → overflow | 错误 – 自定义余额合并 → 溢出

module vuln::coin_overflow {
    struct UnsafeCoin has store { balance: u64 }

    public entry fun unsafe_merge(dest: &mut UnsafeCoin, source: UnsafeCoin) {
        dest.balance = dest.balance + source.balance; // LỖ HỔNG: u64 overflow | VULNERABILITY: u64 overflow | 漏洞：u64 溢出
    }
}

// Risk: High – Balance overflow → infinite mint | Risk: High – Balance overflow → infinite mint | 风险：高 – 余额溢出 → 无限铸造
// Fix: Dùng sui::coin::Coin<T> built-in check. | Fix: Use built-in sui::coin::Coin<T> checks. | 修复：使用内置的 sui::coin::Coin<T> 检查。