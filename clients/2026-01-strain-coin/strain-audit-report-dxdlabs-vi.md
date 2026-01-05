# DXDLABS – Báo cáo Kiểm tra Bảo mật Smart Contract

> **Phiên bản:** 1.0  
> **Ngôn ngữ:** Tiếng Việt (Bản dịch từ Tiếng Anh)

---

### 1. Tổng quan

- **Tên dự án:** Strain Coin ($STR)
- **Khách hàng:** Strain Coin Team
- **Địa chỉ hợp đồng:** 0xB41E129356c796FAC09640A50444041694592bC6
- **Mạng lưới:** Base Chain (Mainnet)
- **Ngày kiểm định:** 05/01/2026
- **Kiểm định viên:** DXDLABS Team

**Phạm vi kiểm định:**

- **Hợp đồng được kiểm tra:**
    - `STRAIN.sol` (Hợp đồng chính triển khai tại địa chỉ trên)

---

### 2. Tóm tắt điều hành

- **Đánh giá tổng thể:** **KHÔNG ĐẠT (FAIL)** – Do rủi ro quản trị quá cao.
- **Tóm tắt rủi ro:**

| Mức độ nghiêm trọng | Số lượng |
| :--- | :--- |
| Nghiêm trọng (Critical) | 0 |
| Cao (High) | 1 |
| Trung bình (Medium) | 1 |
| Thấp (Low) | 0 |
| Thông tin (Informational) | 1 |

- **Quan sát chính:**
    - **Quyền Mint không giới hạn:** Chủ sở hữu (Owner) có quyền tạo thêm một lượng lớn token bất kỳ lúc nào, có thể dẫn đến việc pha loãng giá trị token cực kỳ nghiêm trọng.
    - **Khả năng tạm dừng giao dịch:** Owner có quyền dừng toàn bộ hoạt động giao dịch của token, tạo ra rủi ro "Honeypot" tiềm ẩn.
    - **Tập trung sở hữu:** Phần lớn tổng cung token hiện đang nằm trong quyền kiểm soát của Owner hoặc các ví liên quan.

---

### 3. Phương pháp kiểm định

DXDLABS đã sử dụng kết hợp các công cụ tự động và đánh giá thủ công:

- **Đánh giá kiến trúc & thiết kế:** Kiểm tra các vai trò quản trị và quyền hạn của Owner.
- **Phân tích tĩnh:** Sử dụng các bộ phân tích để phát hiện các mẫu thiết kế rủi ro.
- **Đánh giá thủ công:** Phân tích logic của hàm `mint()` và `pause()` trong ngữ cảnh an toàn cho nhà đầu tư.

---

### 4. Phân loại rủi ro

- **Cao (High):** Tác động tài chính hoặc chức năng đáng kể; có khả năng gây mất mát giá trị cho người dùng.
- **Trung bình (Medium):** Tác động có giới hạn hoặc yêu cầu các điều kiện nhất định.
- **Thông tin (Informational):** Các lưu ý về thiết kế và thực hành tốt nhất.

---

### 5. Tóm tắt các phát hiện

| ID | Mức độ | Tiêu đề | Trạng thái |
| :--- | :--- | :--- | :--- |
| DXD-01 | Cao | Rủi ro Minting tập trung (Unlimited Minting) | Chưa giải quyết |
| DXD-02 | Trung bình | Rủi ro tạm dừng giao dịch tập trung (Centralized Pause) | Chưa giải quyết |
| DXD-03 | Thông tin | Số thập phân (Decimals) được đặt là 0 | Chưa giải quyết |

---

### 6. Chi tiết các phát hiện

#### DXD-01 – Rủi ro Minting tập trung (High)

**Trạng thái:** Chưa giải quyết

**Mô tả:**  
Hợp đồng chứa hàm `mint(address to, uint256 amount)` với modifier `onlyOwner`. Điều này cho phép chủ sở hữu hợp đồng tạo ra thêm token không giới hạn.

**Tác động:**  
Chủ sở hữu có thể mint thêm hàng tỷ token và bán ra thị trường, làm sụp đổ giá trị của token STRAIN, gây thiệt hại nặng nề cho các nhà đầu tư.

**Khả năng xảy ra:**  
Rất cao nếu quyền sở hữu không được từ bỏ (renounced) hoặc chuyển sang một hợp đồng quản trị (Timelock/Multi-sig).

**Chi tiết kỹ thuật:**  
```solidity
function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}
```

**Khuyến nghị:**  
1. Từ bỏ quyền sở hữu (Renounce Ownership) nếu không cần thiết phải mint thêm.
2. Hoặc chuyển quyền sở hữu sang một hợp đồng Multi-sig với cơ chế Timelock.
3. Thiết lập một giới hạn tối đa (Hard cap) cho tổng cung trong code.

---

#### DXD-02 – Rủi ro tạm dừng giao dịch tập trung (Medium)

**Trạng thái:** Chưa giải quyết

**Mô tả:**  
Hợp đồng kế thừa `ERC20Pausable`, cho phép Owner gọi hàm `pause()`. Khi ở trạng thái pause, mọi giao dịch chuyển token sẽ bị chặn.

**Tác động:**  
Owner có thể ngăn cản người dùng bán token, tạo ra trạng thái tương tự như một "Honeypot".

**Khuyến nghị:**  
Chỉ sử dụng tính năng này trong trường hợp khẩn cấp thực sự và nên có cơ chế quản trị cộng đồng hoặc giới hạn thời gian pause tối đa.

---

#### DXD-03 – Số thập phân (Decimals) được đặt là 0 (Informational)

**Trạng thái:** Chưa giải quyết

**Mô tả:**  
Hàm `decimals()` trả về giá trị 0. 

**Chi tiết kỹ thuật:**
```solidity
function decimals() public view virtual override returns (uint8) {
    return 0;
}
```

**Tác động:**  
Hầu hết các token ERC20 sử dụng 18 chữ số thập phân. Việc sử dụng 0 có thể gây nhầm lẫn khi hiển thị trên các ví hoặc sàn giao dịch nếu không được xử lý đúng cách. Tuy nhiên, đây là một lựa chọn thiết kế, không phải lỗ hổng bảo mật.

---

### 7. Chất lượng mã nguồn & Thực hành tốt nhất

- Hợp đồng sử dụng thư viện OpenZeppelin 5.x, một tiêu chuẩn ngành rất an toàn.
- Mã nguồn ngắn gọn, dễ hiểu.
- Việc sử dụng `ERC20Permit` giúp tối ưu hóa trải nghiệm người dùng về gas.

---

### 8. Phụ lục

**Môi trường:**
- **Trình biên dịch:** Solidity 0.8.26
- **Công cụ:** Đánh giá thủ công, Goplus Security API.
