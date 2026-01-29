# Vuln DB (Sui/Move)

Thư mục này lưu các mô tả lỗ hổng Move/Sui thực tế ở dạng YAML và bộ parser để tạo summary.

## Cấu trúc

- `vulns/` - Mỗi lỗ hổng một file YAML.
- `parser.py` - Parse tất cả YAML và tạo `summary.md`.
- `requirements.txt` - Phụ thuộc Python cho parser.

## Schema YAML (trường bắt buộc)

- `name`
- `date` (YYYY-MM-DD)
- `description`
- `impact`
- `severity`
- `references` (danh sách URL)
- `code_vuln`
- `code_fixed`
- `test_vector`

Trường tùy chọn:

- `cve_id`
- `affected_projects`
- `sui_testnet_tx`

## Thêm lỗ hổng mới

1. Tạo file YAML mới trong `vulns/` theo tên `snake_case`.
2. Điền đầy đủ các trường bắt buộc, mô tả ngắn gọn và kỹ thuật.
3. Chạy parser để kiểm tra và tạo summary.

## Chạy parser

```bash
cd vuln-db
python parser.py
```

Lệnh trên tạo file `vuln-db/summary.md`.
