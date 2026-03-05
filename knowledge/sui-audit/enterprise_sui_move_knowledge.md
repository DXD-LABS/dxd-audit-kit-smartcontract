# Ngân hàng Rủi ro Đặc thù trên Sui/Move (Sui-Specific Risk Bank)

Tài liệu này tổng hợp chi tiết các lỗ hổng thực tế (real-world vulnerabilities) đã từng xảy ra hoặc cấu thành nên rủi ro lớn nhất đối với các giao thức trên Sui Blockchain.

## 1. Programmable Transaction Blocks (PTB) Flash-Loan Attack

Là cơ chế mạnh nhất của Sui, PTB kết hợp được hàng nghìn lệnh trong một giao dịch duy nhất nguyên tử (atomic transaction).

- **Attack Vector:** Mượn nhanh (Flash loan) một khoản khổng lồ -> Gọi Swap Pool AMM để đẩy lệch giá Token A / Token B -> Bơm thanh khoản vào Lending Protocol và thế chấp Token B theo mức giá bị đẩy lệch (Manipulated Price) -> Vay ra Token thật (như USDC) -> Dùng 1 phần USDC vừa vay để trả lại Flash Loan -> Kẻ thù lấy được USDC thật, bỏ lại khoản nợ xấu (Bad Debt) trong hệ thống Lending.
- **Phòng chống (Mitigation):**
  - Đảm bảo việc cập nhật giá Oracle (Oracle Price Update) và Trạng thái vay (Borrow) không nằm trong cùng một kịch bản bị thao túng. Tách khối hoặc kiểm tra trượt giá.
  - Sử dụng pattern `Hot Potato` để kiểm soát nghiêm ngặt việc một lệnh vay không được phép bị vượt qua (bypass) nếu chưa trả đủ (với `Drop`/`Store` abilities bị khoá chặt).

## 2. Object Ownership & Capability Misuse

Object là nền tảng của Sui (thay thế cho Address-balance của EVM). Có 4 Ability cốt lõi: `copy`, `drop`, `store`, `key`.

- **Rò rỉ (Leakage) các Object quản trị:** Nếu một hàm public (ví dụ `init` hoặc `create_pool`) trả về (`return`) một object quản trị cấp độ cao (`AdminCap` hoặc `MintCap`), bất cứ ai cũng có thể chiếm quyền tạo tiền hoặc rút thanh khoản.
- **Wrap/Store bọc mã độc:** Kẻ thủ xảo quyệt có thể dùng lệnh `store` trên một tài sản để bọc (wrap) nó vào một Object khác nhằm tránh né các đoạn code kiểm tra tính hợp lệ của hệ thống (Ví dụ: Chuyển NFT bị phong toả (Frozen) sang ví khác qua trung gian 1 NFT được phép `store`).

## 3. Quản lý Shared Objects và Race Conditions

Shared Object có thể được tất cả mọi người truy cập cùng lúc (Concurrency). Tuy nhiên, nếu thao tác trên Object thay đổi trạng thái (Mutating State), hệ thống phải xếp hàng (Sequencing).

- **Rủi ro Griefing (Tấn công từ chối thanh lý):** Giả sử ai đó đang bị nợ xấu, thay vì chờ bot thanh lý (liquidator), họ liên tục gửi hàng vạn giao dịch vô nghĩa tác động vào cùng Shared Object "Tài khoản của họ". Việc này gây tắc nghẽn cục bộ (Local Congestion), những giao dịch thanh lý của Liquidation Bot luôn bị báo lỗi (abort) do hết hạn hoặc Race conditions. Khoản nợ bốc hơi mà người dùng không bị mất tài sản thế chấp.
- **Thứ tự thực thi MEV:** Một người chốt sổ trượt giá thấp có thể bị Front-run (chạy trước) bởi người khác, gây thiệt hại nghiêm trọng (với AMM/DEX là Slippage Attack). Phải giới hạn (Slippage bounds).

## 4. Rủi ro Nâng cấp (Smart Contract Upgrades)

Move on Sui cho phép lập trình viên công bố package. Tuy nhiên, nếu bạn tạo ra biến (Fields) mới, những Object cũ sinh ra ở "Version 1" sẽ bị lỗi không tương thích (Struct mismatch).

- Kẻ chủ mưu (Malicious Admin) có thể lợi dụng điều này nâng cấp Protocol lên Ver 2 với cấu trúc cố tình làm "kẹt hỏng" các Struct rút tiền cũ. Toàn bộ tài sản bị giam vô thời hạn (Lock funds).

## 5. Clock & Stale Oracles (Thời gian và Bộ chỉ báo giá)

- Hàm tính lãi dựa vào biến `0x6::clock::Clock`. Nếu một hàm public không xác minh rõ khoảng thời gian `Time delta`, lãi vay (Interest Rate) có thể tích tụ bằng 0.
- Oracle staleness attack. Một mức giá được cập nhật từ 5 tiếng trước (do Supra, Pyth bị lag mạng lưới hoặc tắt node) sẽ được kẻ thù dùng làm con cờ để đẩy lệnh chênh lệch giá. Bắt buộc mọi hàm liên quan đến "tính tiền" phải có `max_staleness` = (Ví dụ 60 giây). Vượt qua 60 giây, giao dịch bị huỷ (abort).
