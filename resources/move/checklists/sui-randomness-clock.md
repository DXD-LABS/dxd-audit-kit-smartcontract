# Sự ngẫu nhiên (Randomness) & Thời gian (Clock) | Randomness & Clock | 随机性与时间

Trên Sui, nhà phát triển có thể sử dụng `sui::random` cho tính ngẫu nhiên an toàn và `sui::clock` cho thời gian on-chain. Nếu sử dụng sai, chúng vẫn có thể mở ra con đường cho kẻ tấn công. | On Sui, developers can use `sui::random` for secure randomness and `sui::clock` for on-chain time. If misused, they can still open paths for attackers. | 在 Sui 上，开发人员可以使用 `sui::random` 获取安全的随机性，使用 `sui::clock` 获取链上时间。如果使用不当，它们仍然会为攻击者打开通道。

## 1. Randomness (sui::random) | 随机性

Tính ngẫu nhiên thường bị lợi dụng qua tấn công MEV hoặc front-running. | Randomness is often exploited via MEV attacks or front-running. | 随机性经常被通过 MEV 攻击或抢先交易漏洞利用。

- [ ] **Lỗi "Revert on Loss" | "Revert on Loss" Bug | 亏损回滚漏洞:** Nếu kết quả ngẫu nhiên bất lợi, hợp đồng có cho phép giao dịch Abort để revert trạng thái không? Kẻ tấn công có thể thử đi thử lại bằng cách abort nếu không thắng. | If the random result is unfavorable, does the contract allow the transaction to Abort to revert state? Attackers can retry by aborting until they win. | 如果随机结果不利，合约是否允许交易 Abort 以恢复状态？攻击者可以通过中止交易重试，直到获胜。
- [ ] **Check Argument `&Random` | 检查参数 `&Random`:** Hàm có đảm bảo gọi trực tiếp từ `sui::random` không hay họ có thể luồn một state generator đã bị can thiệp vào? | Does the function ensure it takes input directly from `sui::random`, or can an tampered state generator be injected? | 函数是否确保直接从 `sui::random` 接收输入，还是可以注入被篡改的状态生成器？
- [ ] **Sử dụng cho Logic cốt lõi | Use in Core Logic | 用于核心逻辑:** Lấy độ ngẫu nhiên trực tiếp trong giao dịch thay vì Commit/Reveal có bị lạm dụng không? | Is taking randomness directly in the transaction rather than a Commit/Reveal model being abused? | 在交易中直接获取随机性而不是使用提交/揭示模式是否被滥用？

## 2. Clock (sui::clock) | 时钟

`sui::clock` được truyền dưới dạng `&Clock`. | `sui::clock` is passed as `&Clock`. | `sui::clock` 作为 `&Clock` 传递。

- [ ] **Xác thực phiên bản thời gian | Time Version Validation | 时间版本验证:** Code có đang gán `Clock` vào bên trong một struct không? `Clock` chỉ nên là tham số hàm. | Is the code assigning `Clock` inside a struct? `Clock` should only be a function parameter. | 代码是否在结构内分配 `Clock`？`Clock` 只能是函数的参数。
- [ ] **Rủi ro Timestamp Manipulation | Timestamp Manipulation Risk | 时间戳操纵风险:** Logic dApp (Ví dụ Vesting) có nhạy cảm đến mức 1-2 giây lệch cũng tạo ra lỗi không? | Is the dApp logic (e.g., Vesting) sensitive enough that a 1-2 second deviation causes errors? | dApp 逻辑（例如发行）是否足够敏感，以至于 1-2 秒的偏差就会导致错误？
- [ ] **Vesting/Locking | 锁定:** Có chắc chắn `Clock` được dùng để block rút tiền chứ không phải là điều kiện được thả nổi? | Are you sure `Clock` is used to block withdrawals rather than as a floating condition? | 你确定 `Clock` 是用来阻挡提款，而不是作为一个浮动条件吗？

## 3. Lỗi dùng Object ID để sinh số ngẫu nhiên | Using Object ID to generate randomness | 使用对象 ID 生成随机数的错误

- [ ] **Tuyệt đối cấm | Strictly Forbidden | 严禁:** DApp có dùng `tx_hash`, `Object ID`, hoặc thuộc tính của `TxContext` làm seed không? Những giá trị này có thể tính toán trước được ngoài chuỗi. | Does the DApp use `tx_hash`, `Object ID`, or `TxContext` properties as seeds? These values can be pre-calculated off-chain. | DApp 是否使用 `tx_hash`、`Object ID` 或 `TxContext` 的属性作为种子？这些值可以在链下预先计算。
