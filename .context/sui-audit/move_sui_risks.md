# Enterprise Smart Contract Audit Knowledge Base

Tài liệu này đóng vai trò là cơ sở tri thức (Knowledge Base) cốt lõi dành cho AI Agent và các chuyên gia bảo mật khi thực hiện Audit các dự án Web3 quy mô doanh nghiệp (Enterprise-grade), đặc biệt tập trung vào hệ sinh thái **Sui / Move**.

---

## Phần 1: Tổng quan về Audit Smart Contract Doanh Nghiệp (Enterprise Auditing Overview)

Khi tiến hành audit cho một giao thức tài chính hoặc hệ thống quy mô lớn, việc chỉ tìm lỗi code (code-level bugs) là không đủ. Một audit doanh nghiệp yêu cầu đánh giá toàn diện dựa trên **Threat Model** toàn hệ thống.

### 1.1. Các nguyên tắc cốt lõi (Core Principles)

1. **Defense in Depth (Phòng thủ nhiều lớp):** Không phụ thuộc vào một mảng bảo vệ duy nhất. Hệ thống cần có Access Control nghiêm ngặt, Limiters (Rate Limit/Caps), Pause mechanism (Kill switch), và Upgradeability delay (Timelocks).
2. **Business Logic vs. Code Implementation:** Rất nhiều lỗ hổng nghiêm trọng nằm ở việc thiết kế sai logic kinh tế (Flawed Tokenomics, Bad Debt creation, Oracle Manipulation) chứ không phải do code sai cú pháp.
3. **Invariants (Bất biến hệ thống):** Xác định các quy tắc toán học hoặc trạng thái không bao giờ được phép vi phạm. Ví dụ: `Total Borrows <= Total Deposits + Yield`. Mọi thay đổi state đều phải giữ nguyên invariants này.

### 1.2. Các nhóm rủi ro chung trong Web3 (General Web3 Risks)

- **Centralization Risk (Rủi ro tập quyền):** Admin có quá nhiều quyền lực (vd: instant upgrade, rug pull funds). *Mitigation:* Multisig, Timelocks, DAO Governance.
- **Oracle Manipulation:** Sự phụ thuộc vào nguồn giá bên ngoài (Push/Pull oracles). Dễ bị tấn công Flash-loan hoặc thao túng thanh khoản thấp.
- **Economic Exploit:** Tấn công thông qua cơ chế thanh lý (Liquidation), trượt giá (Slippage), hoặc thao túng AMM.
- **Integration Dependencies:** Rủi ro đến từ các smart contract bên thứ ba (vd: LST tokens depeg, Bridges bị hack).

---

## Phần 2: Rủi ro đặc thù cốt lõi trên Sui và Move (Sui/Move Specific Risks)

Ngôn ngữ Move được thiết kế để giải quyết nhiều vấn đề của Solidity (đặc biệt là Reentrancy nhờ cơ chế mượn/Borrow Checker và Resource-oriented architecture). Tuy nhiên, kiến trúc độc đáo của Sui lại tạo ra những Vector tấn công (Attack Vectors) hoàn toàn mới.

### 2.1. Object Model & Ownership Leaks

Sui xoay quanh các Objects. Việc quản lý quyền sở hữu (ownership) là yếu tố sống còn.

- **Misuse of `store`, `copy`, `drop` Abilities:**
  - Nếu một object tài chính (như `Debt`, `Collateral`, `AdminBadge`) vô tình có `drop`, người dùng có thể tự huỷ bỏ khoản nợ.
  - Nếu có `copy`, người dùng có thể nhân bản token/tài sản.
  - Nếu có `store`, object có thể bị wrap vào một object khác và gửi đi nơi khác, vượt qua các ràng buộc (policy) của giao thức.
- **Object Leakage (Rò rỉ object nhạy cảm):** Việc các hàm public trả về (return) các object chứa quyền Admin hoặc các Capability quan trọng khiến bất kỳ ai cũng có thể chiếm đoạt.

### 2.2. Programmable Transaction Blocks (PTBs) & Flash-loan Patterns

Sui sử dụng PTBs, cho phép nhóm tới 1024 thao tác thành một giao dịch nguyên tử (atomic transaction).

- **Rủi ro:** Một cuộc tấn công thao túng giá (Price Manipulation) hoặc vay khống (Flash-loan-like) có thể diễn ra gọn gàng trong 1 PTB.
- **Kiểm tra (Check):** Các kiến trúc "Hot Potato" (pattern bắt buộc phải giải quyết một Struct không có `drop`/`store` trong cùng 1 transaction) phải được implement chặt chẽ để đảm bảo khoản mượn (borrow) luôn đi kèm với khoản trả (repay).

### 2.3. Shared Objects & Concurrency (Trạng thái chia sẻ)

Các đối tượng được chia sẻ (Shared Objects) cho phép nhiều người dùng tương tác đồng thời.

- **Race Conditions:** Các hàm thay đổi trạng thái của Shared Object (vd: Cập nhật tỷ lệ lãi suất, Thay đổi cấu hình) có thể dẫn tới Race Conditions hoặc MEV (Miner/Validator Extractable Value) nếu không được tính toán thứ tự kỹ lưỡng.
- **Griefing/DoS:** Kẻ tấn công có thể spam giao dịch vào một Shared Object để gây tắc nghẽn (congruence) và chặn user khác thanh lý (liquidate).

### 2.4. Upgrades & Version Control (Cơ chế nâng cấp)

Move trên Sui hỗ trợ nâng cấp (Package Upgrades).

- **Rủi ro vỡ cấu trúc bộ nhớ (Memory Layout Breaking):** Thay đổi cấu trúc dữ liệu (`struct`) ở phiên bản mới có thể gây lỗi tương thích với các object đã tạo ở phiên bản cũ.
- **Version Compatibility:** Cấu trúc tốt phải có field `version` trong các Shared Objects cốt lõi và kiểm tra `assert!(current_version == expected, ERROR)` ở mỗi hàm public để tránh người dùng gọi các hàm từ package cũ đã bị deprecate.

### 2.5. Time & Oracle Staleness (Rủi ro thời gian và giá trị)

- **Sui Clock (`0x6::clock::Clock`):** Contract bắt buộc phải mượn `Clock` shared object để biết thời gian. Cần kiểm tra kỹ việc sử dụng thời gian để tính lãi, giới hạn (rate limits).
- **Stale Price (Giá quá hạn):** Khi đọc giá từ Oracle (Switchboard, Pyth, Supra), nếu contract không kiểm tra `timestamp` của bản cập nhật giá gần nhất, kẻ tấn công có thể lợi dụng những lúc mạng nghẽn hoặc oracle chết để thanh lý (liquidate) tài sản với mức giá cũ có lợi cho chúng.

---

## Phần 3: Best Practices cho Code Review trên Move

1. **Kiểm soát chặt Visibility:** Sử dụng `public(package)` thay vì `public` cho các hàm nội bộ.
2. **Luôn dùng \`Hot Potato\` pattern** cho các luồng vay mượn ngắn hạn (flash loans).
3. **Mô hình hoá State Machine:** Rõ ràng các trạng thái của hệ thống (Active, Paused, Liquidating) và ai có quyền chuyển đổi trạng thái đó.
4. **Tránh xử lý vòng lặp lớn (Unbounded Loops):** Gây ra nguy cơ cạn kiệt Gas (Gas Limit/Out Of Gas) hoặc làm giao dịch bị huỷ (abort).
