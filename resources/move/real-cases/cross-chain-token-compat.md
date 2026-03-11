# Real-World Audit Case: Cross-chain Token Compatibility Vulnerability (Sui 2024) | 真实审计案例：跨链代币兼容性漏洞 (Sui 2024) | Thực tế: Lỗ hổng tương thích Token Cross-chain (Sui 2024)

**Sự cố thực tế**: MoveBit phát hiện lỗi trong các protocol bridge trên Sui khi xử lý các token từ các chain khác không tuân thủ chuẩn Move Coin hoàn toàn (ví dụ: các token không trả về kết quả boolean khi transfer thành công). | **Real-world Incident**: MoveBit discovered vulnerabilities in bridge protocols on Sui when handling tokens from other chains that don't fully comply with Move Coin standards (e.g., tokens not returning a boolean result on successful transfer). | **实际事件**：MoveBit 在处理来自其他链的、不完全符合 Move Coin 标准的代币（例如，在交易成功时不返回布尔结果的代币）时，发现了 Sui 上的跨链协议漏洞。

**Vuln pattern**Exploitation Scenario**:

```move
// Unsafe: Assuming every transfer returns a success signal
// Unsafe: Giả định mọi lệnh transfer đều trả về tín hiệu thành công
public fun handle_bridge_transfer(token: &mut Coin<T>, recipient: address) {
    let result = coin::transfer(token, recipient); // May fail silently if T is non-standard
}
```

**Secure Fix (best practice)**:

- Luôn sử dụng wrapper `SafeTransfer` hoặc kiểm tra balance của người nhận trước và sau khi thực hiện lệnh.
- Validate chặt chẽ các token được bridge vào hệ sinh thái.

| Always use `SafeTransfer` wrappers or verify recipient balance changes. Strictly validate bridged tokens. | 始终使用 `SafeTransfer` 包装器或验证接收者的余额变化。严格验证跨链代币。

**Lesson**: Sự tương thích giữa các chain là nguồn gốc của nhiều lỗi tinh vi. Luôn giả định các thành phần bên ngoài có thể không tuân thủ chuẩn. | **Lesson**: Cross-chain compatibility is a source of subtle bugs. Always assume external components may be non-compliant. | **教训**：跨链兼容性是微妙漏洞的来源。始终假设外部组件可能不合规。
