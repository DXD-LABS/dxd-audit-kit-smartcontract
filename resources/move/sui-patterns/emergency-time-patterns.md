# Sui Pattern: Circuit Breaker | 熔断模式 | Mẫu thiết kế : Circuit Breaker

Thêm flag dừng khẩn cấp để ngăn chặn exploit trong khi chờ bảo trì. | Add emergency stop flag to prevent further exploits during maintenance. | 添加紧急停止标志，以在等待维护期间防止进一步的漏洞利用。

## Vuln Mitigated: AGENT-005 (Unchecked Withdrawal)

Cho phép admin tạm dừng các giao dịch đáng ngờ của Agent.

```move
module examples::circuit_breaker {
    public fun action(state: &ContractState) {
        assert!(!state.paused, E_PAUSED);
    }
}

---

## 🕒 Time Incentivization Pattern | 时间激励模式 | Mẫu thiết kế : Time Incentivization

Sử dụng `sui::clock` để xác thực tính tươi mới của dữ liệu và tính toán phần thưởng dựa trên thời gian. | Use `sui::clock` to verify data freshness and calculate time-based rewards. | 使用 `sui::clock` 验证数据新鲜度并计算基于时间的奖励。

## Vuln Mitigated: AGENT-012 (Oracle Manip)
Giúp kiểm tra xem giá từ Oracle có quá cũ hay không (stale price).

---

## 🚪 Escapability Pattern | 逃逸模式 | Mẫu thiết kế : Escapability

Cơ chế rút tiền khẩn cấp cho người dùng khi hệ thống gặp sự cố. | Emergency withdrawal mechanism for users when the system encounters issues. | 当系统遇到问题时，为用户提供紧急提币机制。

## Vuln Mitigated: AGENT-005 (Memory Poisoning)
Cho phép người dùng "escape" tài sản trước khi các lệnh độc hại từ Agent bị nhiễm độc thực thi.
