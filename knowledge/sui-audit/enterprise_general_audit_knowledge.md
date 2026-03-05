# Cơ sở tri thức Audit Smart Contract mảng DeFi & Tài sản Số

Tri thức chung dành cho Hệ thống AI Audit và Chuyên viên Bảo mật cấp cao khi tiếp cận bất kỳ Smart Contract Framework nào (EVM, SVM, MoveVM).

## 1. Phương pháp đánh giá rủi ro cấp Doanh nghiệp (Enterprise Risk Assessment)

- **Tách biệt Business Logic khỏi Implementation:**
  - Implementation là việc code chạy đúng thiết kế (Code syntax, Access modifiers, Gas optimization).
  - Business Logic là việc thiết kế chạy đúng mong muốn kinh tế (Economic stability, Incentive alignment, Invariants).
  - -> Lỗi lớn nhất ($100M+) thường nằm ở Business Logic.

- **Mô hình DFD (Data Flow Diagram) & Trust Boundaries:**
  - Audit luôn bắt đầu từ việc vẽ các vùng biên (Boundary). Ví dụ: User bình thường -> Protocol -> External Protocol (như AMM Dex pool).
  - Tại mỗi biên, cần kiểm tra: input sanitization (lọc dữ liệu đầu vào) và authorization (uỷ quyền).

## 2. Các Mảng Rủi ro Cốt lõi (Core Risk Vectors)

### 2.1. Rủi ro Toán học và Độ chính xác (Math & Precision Loss)

- Lỗi làm tròn (Rounding differences) khi tính số lượng cổ phần (Shares) hoặc Lãi vay (Interest) theo chu kỳ. Kẻ tấn công có thể lợi dụng việc làm tròn xuống (round down) về 0 của hệ thống để rút cạn quỹ qua hàng trăm ngàn giao dịch vi mô (dust attack).
- Khác biệt số thập phân (Decimals): Sai số giữa Token 6 số thập phân (như USDC) và 18 số (như ETH).

### 2.2. Khủng hoảng thanh khoản & Oracle (Liquidity & Price Dependency)

- **TWAP Manipulation:** Nếu giá được tính dựa trên Trung bình khối lượng theo thời gian (TWAP) nhưng khung thời gian (Window) quá ngắn.
- **Spot Price Manipulation:** Đọc thẳng giá Spot từ AMM. Bạn có thể dùng một Flash Loan hàng trăm triệu USD để ép giá Pool lệch xa thực tế trong 1 block, rồi dùng giá đó vay toàn bộ tiền của Lending Protocol.

### 2.3. Củng cố Centralization Vectors (Timelock & Roles)

- Administrator có quyền pause system? Có thể nâng cấp (upgrade)?
- => "Rug pull" legal nấp dưới danh nghĩa Admin role. Mặc định mọi thay đổi biến số sinh tử đều phải đi qua một độ trễ thời gian công khai (Public Timelock delay >= 24h).

## 3. Reference Frameworks

- OWASP Smart Contract Top 10
- Khung DREAD: Đánh giá thiệt hại (Damage), Khả năng tạo ra (Reproducibility), Cách thức khai thác (Exploitability), Đối tượng bị ảnh hưởng (Affected users), Tính dễ phát hiện (Discoverability).
