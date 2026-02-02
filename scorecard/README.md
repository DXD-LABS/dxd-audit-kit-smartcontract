# DXD Labs Security Scorecard Tool

Công cụ đánh giá mức độ nghiêm trọng của lỗ hổng bảo mật dựa trên bộ tiêu chí BVSS (Blockchain Vulnerability Scoring System).

## 📁 Cấu trúc thư mục
- `core/`: Chứa logic tính điểm dùng chung.
- `parsers/`: Các module đọc dữ liệu từ vuln-db (YAML) và checklist (MD).
- `web/`: Giao diện Dashboard tương tác (HTML/JS).
- `templates/`: Template báo cáo (Jinja2).
- `scorecard_config.json`: File cấu hình trọng số duy nhất (Single Source of Truth).

## 🚀 Hướng dẫn sử dụng

### Option 1: CLI Tool (Python)
Dùng cho Auditor để tính điểm nhanh và xuất báo cáo vào Audit Report.

**Tính điểm cho 1 lỗ hổng từ vuln-db:**
```bash
python scorecard/cli.py --vuln-id cetus_overflow
```

**Ghi đè các tham số rủi ro:**
```bash
python scorecard/cli.py --vuln-id cetus_overflow --likelihood High --maturity Active
```

**Xuất báo cáo từ checklist:**
```bash
python scorecard/cli.py --checklist path/to/checklist.md --output html
```

**Đồng bộ dữ liệu cho Web:**
```bash
python scorecard/cli.py --export-web
```

### Option 2: Web Dashboard (GitHub Pages)
Dùng cho Demo hoặc khách hàng tương tác trực tiếp.

1. Đảm bảo đã chạy lệnh `--export-web` ở trên.
2. Mở file `scorecard/web/index.html` trên trình duyệt.
3. Chọn lỗ hổng hoặc nhập tay các thông số Impact/Likelihood.

## 📊 Thuật toán tính điểm (BVSS)
Điểm số được tính dựa trên:
- **Impact (60%)**: Mức độ ảnh hưởng tài chính/hệ thống.
- **Likelihood (40%)**: Khả năng xảy ra cuộc tấn công.
- **Immutability Multiplier (1.5x)**: Đặc thù không thể sửa đổi của Blockchain.
- **Exploit Maturity**: Trạng thái của mã khai thác (Theoretical, POC, Active).
- **Privileged Access**: Yêu cầu quyền truy cập đặc biệt.

---
*Phát triển bởi DXD Labs.*
