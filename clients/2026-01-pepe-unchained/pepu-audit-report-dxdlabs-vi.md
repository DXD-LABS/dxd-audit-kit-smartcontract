# DXDLABS – Báo cáo Kiểm tra Bảo mật Smart Contract

> **Phiên bản:** 1.2 (Review mã nguồn nội bộ Token.sol)  
> **Ngôn ngữ:** Tiếng Anh / Tiếng Việt / Tiếng Trung (Giản thể)

---

### Ghi chú cập nhật (04/01/2026)
Phiên bản 1.2 được thực hiện dựa trên mã nguồn `Token.sol` do khách hàng cung cấp. So với phiên bản được audit trên Etherscan trước đó, mã nguồn này đã **loại bỏ hoàn toàn logic thuế (tax)** và các hàm quản trị nhạy cảm như `setTax`, `openTrading`. Điều này làm giảm đáng kể rủi ro Honeypot cho nhà đầu tư.

---

### 1. Tổng quan

- **Tên dự án:** Pepe Unchained (PEPU)  
- **Khách hàng:** Đội ngũ Pepe Unchained  
- **Kho lưu trữ / Mã nguồn:** Tệp `Token.sol` nội bộ.
- **Ngày kiểm định:** 04/01/2026  
- **Kiểm định viên:** DXDLABS

**Phạm vi kiểm định:**

- **Mạng lưới:** Ethereum Mainnet
- **Hợp đồng / Thư mục được kiểm tra:**
    - `Token.sol`
- **Ngoài phạm vi:**
    - Các dịch vụ off-chain.

---

### 2. Tóm tắt điều hành

- **Đánh giá tổng thể:** ĐẠT (An toàn cao về mặt logic token)
- **Tóm tắt rủi ro:**

| Mức độ nghiêm trọng | Số lượng |
| :--- | :--- |
| Nghiêm trọng (Critical) | 0 |
| Cao (High) | 0 |
| Trung bình (Medium) | 0 |
| Thấp (Low) | 1 |
| Thông tin (Informational) | 2 |

- **Quan sát chính:**
    - **Cải thiện đáng kể:** Logic thuế đã bị loại bỏ. Hợp đồng hiện tại là một token ERC20 chuẩn, minh bạch và không có cơ chế chặn bán hay thu phí giao dịch ẩn.
    - **Nguồn cung cố định:** Toàn bộ 8 tỷ token được mint một lần duy nhất trong constructor cho các ví dự phòng. Không có hàm mint sau khi triển khai.
    - **Quyền sở hữu:** Vẫn sử dụng `Ownable`, nhưng các hàm quyền lực đã giảm bớt, chủ yếu chỉ còn quản lý quyền sở hữu hợp đồng.
    - **Chất lượng mã:** Cấu trúc ERC20 tự viết (không dùng thư viện OpenZeppelin trực tiếp) nhưng tuân thủ đúng tiêu chuẩn EIP-20.

---

### 3. Phương pháp kiểm định

DXDLABS đã sử dụng kết hợp các công cụ tự động và đánh giá thủ công:

- **Đánh giá kiến trúc & thiết kế:**
    - Xem xét việc triển khai ERC20 và cơ chế phân bổ token ban đầu.
- **Phân tích tĩnh:**
    - Công cụ: Slither.
- **Đánh giá thủ công từng dòng mã:**
    - Kiểm tra logic `_transfer`, `_mint`, `_burn` và phân bổ nguồn cung.

---

### 4. Phân loại rủi ro

DXDLABS sử dụng các mức độ nghiêm trọng sau:

- **Nghiêm trọng (Critical):** Gây mất mát tài sản trực tiếp hoặc chiếm quyền điều khiển giao thức.
- **Cao (High):** Tác động tài chính hoặc chức năng đáng kể.
- **Trung bình (Medium):** Tác động tài chính hoặc chức năng có giới hạn.
- **Thấp (Low):** Các vấn đề nhỏ, phiên bản cũ, hiệu quả gas kém.
- **Thông tin (Informational):** Các thực hành tốt nhất, sự rõ ràng hoặc khả năng bảo trì.

---

### 5. Tóm tắt các phát hiện

| ID | Mức độ | Tiêu đề | Trạng thái |
| :--- | :--- | :--- | :--- |
| DXD-01 | Thấp | Sử dụng phiên bản Solidity cũ (0.8.9) | Chưa giải quyết |
| DXD-02 | Thông tin | Hardcode địa chỉ ví trong Constructor | Chưa giải quyết |
| DXD-03 | Thông tin | Thiếu hàm nhận (receive/fallback) cho ETH | Chưa giải quyết |

---

### 6. Chi tiết các phát hiện

#### DXD-01 – Sử dụng phiên bản Solidity cũ (Thấp)

**Trạng thái:** Chưa giải quyết

**Mô tả:**  
Hợp đồng sử dụng `pragma solidity 0.8.9`. Mặc dù phiên bản 0.8.x đã tích hợp kiểm tra tràn số (overflow), nhưng phiên bản 0.8.9 đã ra mắt từ lâu và thiếu các bản sửa lỗi tối ưu hóa và bảo mật nhỏ có trong các phiên bản mới hơn.

**Tác động:**  
Rủi ro thấp, chủ yếu liên quan đến việc không tận dụng được các cải tiến về gas và bảo mật của các trình biên dịch mới (như 0.8.26+).

**Khuyến nghị:**  
Cập nhật lên phiên bản Solidity mới nhất (ví dụ: 0.8.26 hoặc 0.8.28) để đảm bảo tính tương thích và bảo mật tối đa.

---

#### DXD-02 – Hardcode địa chỉ ví trong Constructor (Thông tin)

**Trạng thái:** Chưa giải quyết

**Mô tả:**  
Các địa chỉ ví nhận token dự phòng (presale, staking, v.v.) được ghi cứng (hardcoded) trực tiếp trong constructor.

**Tác động:**  
Làm giảm tính linh hoạt. Nếu có sai sót trong địa chỉ ví hoặc cần thay đổi ví ngay trước khi deploy, mã nguồn phải được sửa đổi và biên dịch lại.

**Khuyến nghị:**  
Nên truyền các địa chỉ này như các tham số của hàm constructor khi triển khai.

---

#### DXD-03 – Thiếu hàm nhận (receive/fallback) cho ETH (Thông tin)

**Trạng thái:** Chưa giải quyết

**Mô tả:**  
Hợp đồng không có hàm `receive()` hoặc `fallback()` để nhận ETH. Nếu ai đó vô tình gửi ETH vào địa chỉ hợp đồng, giao dịch sẽ bị revert.

**Tác động:**  
Đây thực chất là một tính năng bảo mật để tránh ETH bị kẹt, nhưng trong một số trường hợp có thể gây nhầm lẫn cho người dùng.

**Khuyến nghị:**  
Duy trì trạng thái hiện tại nếu không có ý định nhận ETH, hoặc thêm hàm để xử lý nếu cần.

---

### 7. Chất lượng mã nguồn & Thực hành tốt nhất

- **Tuân thủ tiêu chuẩn:** Triển khai ERC20 rất sạch sẽ và dễ đọc.
- **Tối ưu hóa Gas:** Sử dụng `unchecked` trong các hàm giảm số dư là một thực hành tốt để tiết kiệm gas.
- **An toàn nguồn cung:** Việc mint toàn bộ nguồn cung trong constructor đảm bảo không ai có thể tạo thêm token ngoài ý muốn.

---

### 8. Góc nhìn của Nhà đầu tư thông minh

Dưới góc độ đầu tư, phiên bản `Token.sol` này mang lại sự an tâm hơn nhiều so với các bản meme token thông thường:

1.  **Không có phí ẩn:** Việc loại bỏ hoàn toàn cơ chế thuế (0% Buy/Sell Tax) là một minh chứng cho sự công bằng. Nhà đầu tư không phải lo lắng về việc bị "set tax 100%" hay các phí giao dịch cắt cổ.
2.  **Minh bạch về phân bổ:** Việc hardcode địa chỉ ví dự phòng giúp nhà đầu tư dễ dàng kiểm tra lịch trình unlock hoặc di chuyển của các quỹ này trên blockchain ngay từ đầu.
3.  **Hợp đồng tinh gọn:** Ít hàm quản trị đồng nghĩa với việc ít "bẫy" hơn. Đây là một token thuần túy phục vụ hệ sinh thái Pepe Unchained.
4.  **Lời khuyên:** Dù code an toàn, nhà đầu tư vẫn nên theo dõi các ví nắm giữ lượng lớn token (Dự trữ marketing, thanh khoản) để hiểu rõ lộ trình xả hàng của đội ngũ.

---

### 9. Phụ lục

**Môi trường:**

- **Trình biên dịch:** Solidity 0.8.9
- **EVM phiên bản:** London / Paris

**Công cụ sử dụng:**

- Slither, Đánh giá thủ công.
