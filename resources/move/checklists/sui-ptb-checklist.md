# Sui PTB (Programmable Transaction Blocks) Security Checklist | 可编程交易块 (PTB) 安全检查清单

PTB (Programmable Transaction Blocks) là một tính năng mạnh mẽ trên Sui, cho phép người dùng gộp nhiều hàm gọi vào một giao dịch duy nhất. Mặc dù tối ưu hóa UX, PTB cũng mở ra nhiều rủi ro bảo mật đặc thù nếu smart contract xử lý logic không an toàn. | Programmable Transaction Blocks (PTBs) are a powerful feature on Sui that allows users to batch multiple commands into a single transaction. While optimizing UX, PTBs also introduce specific security risks if smart contracts handle logic unsafely. | 可编程交易块 (PTB) 是 Sui 上的一项强大功能，允许用户将多个命令批量处理到单个交易中。虽然优化了用户体验，但如果智能合约处理逻辑不安全，PTB 也会引入特定的安全风险。

## 1. Hot Potato & Flashloan Abuse | 热土豆与闪电贷滥用

Trên Sui, Hot Potato là một struct không có các ability `key`, `store`, `copy`, `drop`. Rủi ro xảy ra khi trình tự tiêu thụ bị thao túng. | On Sui, a Hot Potato is a struct without `key`, `store`, `copy`, `drop` abilities. Risks arise when the consumption sequence is manipulated. | 在 Sui 上，热土豆是一个没有 `key`、`store`、`copy`、`drop` 能力的结构体。当消费顺序被操纵时就会产生风险。

- [ ] **Flashloan thao túng giá | Flashloan Price Manipulation | 闪电贷价格操纵:** Có đảm bảo Hot Potato (dùng cho flashloan) được trả lại cùng trạng thái ban đầu mà không bị chèn các lệnh thao túng oracle/pool ở giữa PTB không? | Is it ensured that the Hot Potato (used for flashloans) is returned to the initial state without inserting oracle/pool price manipulation commands in the middle of the PTB? | 是否确保热土豆（用于闪电贷）恢复到相同的初始状态，而不会在 PTB 中间插入预言机/池价格操纵命令？
- [ ] **Trình tự giải quyết | Resolution Order | 解决顺序:** Contract có giả định sai lệch rằng lệnh A phải chạy ngay sau lệnh B không? | Does the contract incorrectly assume that command A must run immediately after command B? | 合约是否错误地假设命令 A 必须在命令 B 之后立即运行？
- [ ] **Bypass logic qua gộp lệnh | Bypass logic via command batching | 通过批量命令绕过逻辑:** Kẻ tấn công có thể vay từ giao thức A, dùng làm thế chấp ở B, rồi trả lại A trong cùng 1 PTB không? | Could an attacker borrow from protocol A, use it as collateral in protocol B, and then repay protocol A within the same PTB? | 攻击者是否可以从协议 A 借款，将其用作协议 B 的抵押品，然后在同一个 PTB 内偿还协议 A？

## 2. Argument Spoofing (Giả mạo tham số) | 参数欺骗

Trong PTB, output của một command có thể được làm input cho command tiếp theo. | In a PTB, the output of one command can be used as the input for the next command. | 在 PTB 中，一个命令的输出可以用作下一个命令的输入。

- [ ] **Kiểm tra Object ID | Object ID Check | 对象 ID 检查:** Hàm có kiểm tra (assert) nghiêm ngặt rằng Object ID truyền vào đúng thuộc về chủ sở hữu hoặc là thành phần của hệ thống không? | Does the function strictly assert that the provided Object ID belongs to the owner or is a valid system component? | 函数是否严格断言提供的 Object ID 属于所有者或是一个有效的系统组件？
- [ ] **Xác thực Type Argument | Type Argument Validation | 类型参数验证:** Khi dùng PTB để swap hay rút tiền, hàm có kiểm định loại Coin/Token được truyền vào không? | When using PTBs to swap or withdraw funds, does the function validate the type of Coin/Token passed in? | 当使用 PTB 交换或提取资金时，函数是否验证传入的 Coin/Token 类型？
- [ ] **Shared Object Access | 共享对象访问:** Cẩn thận với việc người dùng truyền cùng một Shared Object vào 2 hàm khác nhau nhưng giả định là 2 object riêng biệt. | Be careful when users pass the same Shared Object into 2 different functions but assume they are 2 separate objects. | 当用户将同一个共享对象传递给 2 个不同的函数但假设它们是 2 个独立的对象时，请务必小心。

## 3. Version Compatibility & Upgrades | 版本兼容性与升级

Khi upgrade package, cấu trúc PTB của client có thể bị hỏng nếu chữ ký hàm thay đổi. | When upgrading a package, the client-side PTB structure may break if the function signature changes. | 升级包时，如果函数签名更改，客户端 PTB 结构可能会损坏。

- [ ] **Bảo vệ tính tương thích ngược | Backward Compatibility Protection | 向后兼容性保护:** Có thiết lập các script/logic fallback hợp lý chưa? | Are proper fallback scripts/logic in place? | 是否已设置适当的后备脚本/逻辑？
- [ ] **Sử dụng Version Control Object | 版本控制对象:** Dùng PTB để lấy `UpgradeCap` từ một version kiểm soát an toàn? | Use PTB to get `UpgradeCap` from a safe version-controlled object? | 使用 PTB 从安全的版本控制对象获取 `UpgradeCap`？

## 4. Bỏ qua kiểm tra Authorization | 绕过授权检查

- [ ] Mọi lệnh trong PTB đều được ký bởi `TxContext::sender()`. Hàm có lạm dụng việc kiểm tra người gửi thay vì kiểm tra Object Ownership không? | Every command in a PTB is signed by `TxContext::sender()`. Does the function abuse sender checks instead of checking Object Ownership? | PTB 中的每个命令都由 `TxContext::sender()` 签名。该函数是否滥用发送者检查而不是检查对象所有权？

**Reference | 参考:**

- Zellic Sui Security Guidelines
- Sui Documentation: Programmable Transaction Blocks
