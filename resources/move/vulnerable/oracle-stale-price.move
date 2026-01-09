/// Module: vuln::oracle_stale
/// Description: 
/// EN: VULNERABILITY - Using stale oracle prices leads to price manipulation attacks.
/// VI: LỖ HỔNG - Sử dụng giá oracle cũ dẫn đến các cuộc tấn công thao túng giá.
/// ZH: 漏洞 - 使用过时的预言机价格会导致价格操纵攻击。

module vuln::oracle_stale {
    public fun get_price(price_data: &PriceData): u64 {
        price_data.price  // LỖ HỔNG/VULN: No timestamp check → attacker uses old price (未检查时间戳)
    }
}

// Risk: High – Oracle manipulation
// Fix: 
// EN: Always verify the timestamp: assert!(current_time - price_timestamp <= max_age, EPriceStale);
// VI: Luôn kiểm tra timestamp: assert!(current_time - price_timestamp <= max_age, EPriceStale);
// ZH: 务必验证时间戳：assert!(current_time - price_timestamp <= max_age, EPriceStale);