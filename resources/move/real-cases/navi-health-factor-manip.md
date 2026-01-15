# Real-World Audit Case: NAVI Protocol Health Factor Manipulation | 真实审计案例：NAVI 协议健康系数操控

**Sự cố thực tế**: Giả lập kịch bản NAVI bị tấn công thao túng Health Factor. Attacker lợi dụng việc cập nhật giá Oracle chậm trễ hoặc sai lệch giữa các pool để vay vượt quá mức tài sản thế chấp (under-collateralized loans). | **Real-world Incident**: Simulated scenario of a NAVI health factor manipulation attack. An attacker exploits delayed Oracle price updates or discrepancies between pools to take out under-collateralized loans. | **实际事件**：模拟 NAVI 健康系数 (Health Factor) 操控攻击场景。攻击者利用预言机 (Oracle) 价格更新延迟或不同池之间的价差来进行超额借贷（抵押不足的贷款）。

**Vuln pattern**:
```move
// Unsafe: Thiếu check Oracle staleness | Unsafe: Missing Oracle staleness check | 不安全：缺少预言机时效性检查
public fun calculate_health_factor(user: address, oracle: &PriceOracle): u64 {
    let price = oracle::get_price(oracle, SUI_TOKEN); // Timestamp not checked
    let collateral = get_user_collateral(user);
    let debt = get_user_debt(user);
    (collateral * price) / debt
}
```

**Secure Fix**:
```move
public fun safe_calculate_health_factor(user: address, oracle: &PriceOracle, clock: &Clock): u64 {
    let (price, timestamp) = oracle::get_price_with_time(oracle, SUI_TOKEN);
    // Enforce Oracle Freshness (e.g., < 60s) | 强制执行预言机新鲜度检查（例如 < 60秒）
    assert!(clock::timestamp_ms(clock) - timestamp < 60000, EStalePrice);
    
    let collateral = get_user_collateral(user);
    let debt = get_user_debt(user);
    (collateral * price) / debt
}
```

**Lesson**: Luôn kiểm tra tính mới của dữ liệu Oracle (Staleness check) trong các giao thức Lending để tránh thao túng giá. | **Lesson**: Always verify the freshness of Oracle data (Staleness check) in lending protocols to prevent price manipulation. | **教训**：在借贷协议中始终验证预言机数据的实时性（Staleness check），以防止价格操控。
