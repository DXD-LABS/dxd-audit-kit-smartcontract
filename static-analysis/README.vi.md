# Move Static Analysis (Tiếng Việt)

Thư mục này cung cấp một đường ống (pipeline) phân tích tĩnh nhẹ cho Sui Move.

## Bắt đầu nhanh

- Cài đặt các phụ thuộc:
  - Rust toolchain (cho `move-lint`)
  - Sui CLI (cho `sui move disassemble`)
  - Python 3.10+

- Phụ thuộc Python:
  - `pip install -r static-analysis/requirements.txt`

- Chạy trên một file đơn lẻ:
  - `python static-analysis/scripts/analyze.py path/to/module.move`

- Chạy trên một thư mục (package):
  - `python static-analysis/scripts/analyze.py path/to/package`

- Quét Bytecode (yêu cầu đường dẫn package Sui có thể build):
  - `python static-analysis/scripts/parse_bytecode.py path/to/package`

## Quy tắc tùy chỉnh

Các quy tắc nằm trong `static-analysis/rules/sui_vuln_rules.yaml`.
Mỗi quy tắc bao gồm:
- `name` (tên), `description` (mô tả), `pattern` (regex - biểu thức chính quy), `severity` (mức độ nghiêm trọng)

Bộ phân tích sẽ đánh dấu các kết quả khớp và thoát với mã lỗi nếu phát hiện lỗi mức `high` hoặc `critical`.

## Phần mở rộng Rust (Tùy chọn)

`static-analysis/Cargo.toml` là khung để mở rộng Move Lint bằng Rust.
Pipeline mặc định sử dụng Python để tối ưu tốc độ lặp lại.
