# Checklist Audit OpenZeppelin Move (v0.1.0 - Tháng 2/2025)

## Tổng quan
Checklist này tập trung vào các mô hình bảo mật cụ thể cho các ứng dụng tích hợp thư viện **OpenZeppelin Move**.

---

## 1. Tiêu chuẩn Token (Coin)
- [ ] **Quyền Đúc (Minting Authority)**: Xác minh rằng `TreasuryCap` (Sui) hoặc Mint Capability tương đương được bảo vệ chặt chẽ và không bị lộ qua các hàm `public` hoặc `entry` mà không có kiểm tra `init` hoặc `AdminCap`.
- [ ] **Tính Bất biến của Metadata**: Đảm bảo `CoinMetadata` đã được đóng băng (frozen) hoặc `UpdateCap` của nó được giữ bởi một multisig/DAO an toàn.
- [ ] **Xác minh Đốt (Burn Verification)**: Xác minh rằng việc đốt token làm giảm đúng `total_supply` nếu sử dụng bộ theo dõi nguồn cung.
- [ ] **Triển khai DenyList**: Kiểm tra xem `DenyCap` có được sử dụng chính xác để ngăn chặn các tác nhân độc hại tương tác với token (đặc thù của Sui).

## 2. Quản lý Tài nguyên
- [ ] **Bảo mật Kiểu Phantom**: (MS-010) Đảm bảo tất cả các struct generic liên quan đến Coin đều sử dụng từ khóa `phantom` cho các tham số kiểu để ngăn chặn các cuộc tấn công thay thế kiểu.
- [ ] **Rò rỉ Dynamic Field**: (MS-001) Nếu sử dụng các phần mở rộng account/vault dựa trên OZ, hãy đảm bảo các dynamic field được trích xuất trước khi xóa đối tượng cha.
- [ ] **Đóng băng Có chủ đích**: (MS-011) Xác minh rằng hàm `public_freeze_object` không được gọi trên bất kỳ đối tượng nào cần nâng cấp trong tương lai.

## 3. Kiểm soát Truy cập (Access Control)
- [ ] **Bao bọc Capability**: (MS-004) Audit bất kỳ logic nào bao bọc một capability `AccessControl` của OZ vào một đối tượng khác. Đảm bảo hàm 'mở bao' (unwrapper) được phân quyền chính xác.
- [ ] **Phơi bày Hàm Entry**: (MS-012) Audit tất cả các hàm `entry`. Đảm bảo chúng là các lớp bọc mỏng quanh logic nội bộ và thực hiện kiểm tra người gửi `TxContext` nghiêm ngặt.
- [ ] **Tích hợp Multi-Sig**: Đảm bảo rằng các hành động có đặc quyền cao (nâng cấp, đúc tiền) được bảo vệ bởi Multi-Sig (ví dụ: `sui::multisig`).

## 4. Số học & Logic
- [ ] **Hướng Làm tròn**: Xác minh rằng các phép toán (đặc biệt là trong DEX/Lending) tuân theo các thực hành tốt nhất của OZ (ví dụ: làm tròn lên cho nợ, làm tròn xuống cho tài sản thế chấp).
- [ ] **Bảo mật Bitwise**: (MS-005) Nếu sử dụng đóng gói bit để tối ưu hóa gas, hãy xác minh các ranh giới mặt nạ (mask) và dịch bit (shift).

## 5. Khả năng Nâng cấp
- [ ] **Phân phiên Package**: Đảm bảo contract kiểm tra phiên bản của chính nó so với một đối tượng `VersionControl` để ngăn chặn các lệnh gọi contract 'cũ' sau khi nâng cấp.
- [ ] **Di chuyển Capability**: Xác minh rằng các phiên bản mới của package có thể tiêu thụ chính xác các Capability được cấp bởi phiên bản cũ.

---
*Tham chiếu: OpenZeppelin Move Research Release (Feb 2025) & MoveScanner 2026.*
