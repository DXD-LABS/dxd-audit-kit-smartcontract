# Real-World Audit Case: Nemo Protocol Pricing Logic Exploit (Sui 2025) | 真实审计案例：Nemo Protocol 定价逻辑漏洞 (Sui 2025) | Thực tế: Lỗi Logic Định giá Nemo Protocol (Sui 2025)

**Sự cố thực tế**: Tháng 9/2025, Nemo Protocol bị exploit $2.4M. Attacker lợi dụng lỗ hổng trong hàm tính toán giá của pool dự trữ USDC để rút cạn quỹ qua các lệnh swap không cân xứng. | **Real-world Incident**: In September 2025, Nemo Protocol was exploited for $2.44 million. The attacker leveraged a pricing function vulnerability in the USDC reserve pool to drain funds through unbalanced swaps. | **实际事件**：2025 年 9 月，Nemo Protocol 被利用，损失 244 万美元。攻击者利用 USDC 储备池中的定价函数漏洞，通过不平衡的交易抽干了资金。

## Exploitation Scenario

```move
// Unsafe: Pricing logic based on internal balance without slippage protection
// Unsafe: Logic định giá dựa trên balance nội bộ không có bảo vệ slippage
public fun get_price(pool: &Pool): u64 {
    pool.reserve_usdc / pool.reserve_token // Potential manipulation | Dễ bị thao túng
}
```

**Secure Fix (best practice)**:

## Remediation

- Sử dụng Oracle bên ngoài (Pyth/Switchboard) kết hợp với kiểm tra độ lệch (Slippage/Deviation check).
- Sử dụng công thức hằng số sản phẩm (AMM) chuẩn và đảm bảo độ chính xác toán học.
| Use external Oracles combined with deviation checks. Ensure mathematical precision in AMM formulas. | 使用外部预言机并结合偏差检查。确保 AMM 公式中的数学精度。

**Lesson**: Đừng bao giờ tin tưởng hoàn toàn vào giá nội bộ của pool, đặc biệt là các pool có thanh khoản thấp. | **Lesson**: Never rely solely on internal pool pricing, especially for low-liquidity pools. | **教训**：永远不要完全依赖资金池的内部定价，特别是对于低流动性的资金池。
