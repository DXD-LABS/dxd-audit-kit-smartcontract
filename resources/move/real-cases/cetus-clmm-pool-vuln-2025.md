# Real-World Audit Case: Cetus CLMM Pool Exploit (Sui 2025) | 真实审计案例：Cetus CLMM 池漏洞 (Sui 2025)

**Sự cố thực tế**: Tháng 5/2025, Cetus bị exploit $223M do lỗ hổng spoof-token trong pricing logic (không check token authenticity trước liquidity add). Attacker drain pool mà không trigger alarm. | **Real-world Incident**: In May 2025, Cetus was exploited for $223M due to a spoof-token vulnerability in its pricing logic (failure to check token authenticity before adding liquidity). The attacker drained the pool without triggering alarms. | **实际事件**：2025 年 5 月，Cetus 因定价逻辑中的伪造代币 (spoof-token) 漏洞被利用，损失 2.23 亿美元（在添加流动性前未检查代币真实性）。攻击者在未触发报警的情况下抽干了资金池。

**Vuln pattern (Zellic/OtterSec report)**:
```move
// Unsafe: Không check token type/authenticity | Unsafe: No token type/authenticity check | 不安全：未检查代币类型/真实性
public entry fun add_liquidity(pool: &mut Pool, token: Coin<FakeToken>) {
    pool.liquidity = pool.liquidity + token.value;
}
```

**Secure Fix (best practice)**:
```move
public entry fun safe_add_liquidity(pool: &mut Pool, token: Coin<SUI>, amount: u64) {
    assert!(coin::value(&token) == amount, EInvalidAmount);
    // Chỉ accept Coin<SUI> chuẩn | Only accept genuine Coin<SUI> | 仅接受标准的 Coin<SUI>
    pool.liquidity = pool.liquidity + amount;
    coin::destroy_zero(token);
}
```

**Lesson**: Luôn enforce token type/authenticity + use built-in Coin<T> check. Reference: Zellic Cetus audit, SlowMist report 2025. | **Lesson**: Always enforce token type/authenticity and use built-in `Coin<T>` checks. | **教训**：始终强制执行代币类型/真实性检查，并使用内置的 `Coin<T>` 检查。
