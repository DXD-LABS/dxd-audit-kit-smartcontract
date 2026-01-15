# Real-World Audit Case: Scallop Isolation Mode Bypass | 真实审计案例：Scallop 隔离模式绕过

**Sự cố thực tế**: Giả lập kịch bản Scallop bị bypass cơ chế Isolation Mode. Isolation mode ngăn chặn việc dùng các tài sản rủi ro cao làm tài sản thế chấp để vay các tài sản chính (Blue-chip). Lỗ hổng xảy ra khi logic kiểm tra bị bỏ sót trong hàm `multi-asset collateral`. | **Real-world Incident**: Simulated scenario where the Scallop Isolation Mode mechanism is bypassed. Isolation mode prevents high-risk assets from being used as collateral to borrow major (Blue-chip) assets. The vulnerability occurs when checking logic is omitted in the `multi-asset collateral` function. | **实际事件**：模拟 Scallop 隔离模式 (Isolation Mode) 机制被绕过的场景。隔离模式防止高风险资产被用作抵押品来借入主流（蓝筹）资产。当 `multi-asset collateral` 函数中遗漏了检查逻辑时，就会发生该漏洞。

**Vuln pattern**:
```move
// Unsafe: Cho phép add nhiều loại collateral mà không check Isolation Mode | Unsafe: Allows adding multiple collateral types without checking Isolation Mode | 不安全：允许添加多种抵押品而未检查隔离模式
public fun add_collateral(pool: &mut Pool, coin: Coin<T>) {
    // Missing logic to check if asset T is isolated
    let amount = coin::value(&coin);
    update_user_collateral(pool, T, amount);
}
```

**Secure Fix**:
```move
public fun safe_add_collateral(pool: &mut Pool, coin: Coin<T>) {
    // Check Isolation Policy | 检查隔离策略
    assert!(is_allowed_in_isolation_mode(pool, type_to_name<T>()), EIsolationBypass);
    
    let amount = coin::value(&coin);
    update_user_collateral(pool, T, amount);
}
```

**Lesson**: Nghiêm ngặt tuân thủ Isolation Policy cho các tài sản mới/rủi ro cao trong DeFi Lending. | **Lesson**: Strictly adhere to the Isolation Policy for new or high-risk assets in DeFi Lending. | **教训**：在 DeFi 借贷中，对新资产或高风险资产必须严格遵守隔离策略 (Isolation Policy)。
