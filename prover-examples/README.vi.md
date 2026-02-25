# Move Prover Examples (Vietnamese)

Các ví dụ thực hành cho Move Prover formal verification sử dụng MSL specs.

## Hướng dẫn Setup & Run

### Prerequisites (Tiền đề)
- **Sui CLI**: `cargo install --locked sui --git https://github.com/MystenLabs/sui.git`
- **Z3 Solver**:
  - Ubuntu: `sudo apt update && sudo apt install z3 libz3-dev`
  - Mac: `brew install z3`
  - Windows: Tải từ Microsoft Z3 GitHub releases, thêm thư mục bin vào PATH
- **Boogie**: `dotnet tool install -g boogie` (yêu cầu .NET SDK)

### Chạy Prover
```bash
cd prover-examples
sui move prove
```

Nếu tất cả specs verified OK, sẽ không có thông báo lỗi.

### Các Ví dụ
- **safe_transfer.move**: Verify transfer coin an toàn, abort nếu không đủ số dư, không double-spend (số dư cũ = số dư mới + số tiền đã chuyển).
- **no_double_spend.move**: Invariant số dư không âm, rút tiền abort nếu không đủ số dư.
- **flash_loan_safe.move**: Verify việc bắt buộc hoàn trả flash loan (kiểu DeepBook, hot potato bị hủy nếu hoàn trả đủ).
- **lending_collateral.move**: Chỉ cho vay nếu siêu thế chấp 150%, bảo vệ invariant không bị thiếu thế chấp.
- **oracle_safe.move**: Kiểm tra độ tươi của giá Oracle (abort nếu timestamp cũ > max_age).
- **no_double_spend_transfer.move**: Chuyển coin không double-spend (abort nếu thiếu số dư, số dư người gửi -= amount, người nhận += amount, tổng lượng coin được bảo toàn).
- **liquidation_safe.move**: Kiểm tra thanh lý an toàn (needs_liquidation chỉ true khi thiếu thế chấp >120%, abort nếu thanh lý vị thế khỏe mạnh).
- **oracle_deviation_safe.move**: Kiểm tra độ tươi + độ lệch Oracle (abort nếu giá cũ >300s hoặc độ lệch >5%).

### Xử lý lỗi
- "Z3 not found": Thêm Z3 bin vào PATH, khởi động lại terminal.
- "Boogie error": Kiểm tra đã cài đặt .NET SDK chưa.
- Specs fail: Kiểm tra logic code hoặc spec có khớp với tài liệu Sui không (docs.sui.io/move/prover).
- Verbosity cao: Chỉnh Prover.toml verbosity = "High".

---
*Phát triển bởi DXD Labs.*
