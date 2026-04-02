# Cơ sở dữ liệu MoveScanner 2026 (Việt Nam)

## Giới thiệu
Thư mục này chứa các nghiên cứu bảo mật mới nhất từ báo cáo **MoveScanner (Tháng 2/2026)**. Research này đã phân tích hơn 37,000 smart contract trên Sui và Aptos, phát hiện các lớp lỗ hổng mới đặc thù cho mô hình hướng tài nguyên (resource-oriented) của Move.

## Danh sách Lỗ hổng
| ID | Tên Lỗ hổng | Mức độ |
|----|-------------|---------|
| [MS-001](ms_resource_leak_dynamic_field.yaml) | Rò rỉ Tài nguyên qua Dynamic Field | Cao |
| [MS-002](ms_double_spend_dynamic_field.yaml) | Double-spending qua Dynamic Field | Nghiêm trọng |
| [MS-003](ms_cross_module_permission_defect.yaml) | Lỗi Quyền hạn Cross-module | Cao |
| [MS-004](ms_capability_leak_wrapping.yaml) | Rò rỉ Capability qua Object Wrapping | Cao |
| [MS-005](ms_arithmetic_bitwise_edge.yaml) | Lỗi Số học Bitwise | Trung bình |
| [MS-006](ms_custom_math_lib_edge.yaml) | Lỗi Thư viện Toán học Tùy chỉnh | Cao |
| [MS-007](ms_parallel_race_object_dependency.yaml) | Lỗi Race Condition trong Thực thi Song song | Cao |
| [MS-008](ms_token_issuance_ability_abuse.yaml) | Lạm dụng Ability trong Phát hành Token | Nghiêm trọng |
| [MS-009](ms_resource_leak_struct_drop.yaml) | Rò rỉ Tài nguyên do Thiếu 'drop' | Trung bình |
| [MS-010](ms_phantom_type_bypass.yaml) | Lỗi Bỏ qua Bảo mật Kiểu Phantom | Cao |
| [MS-011](ms_freeze_object_misuse.yaml) | Lạm dụng Hàm Freeze Object | Trung bình |
| [MS-012](ms_entry_fun_exposure.yaml) | Lỗ hổng Phơi bày Hàm Entry | Cao |

## Cách sử dụng
1. Đọc file YAML để hiểu logic lỗi và cách sửa.
2. Tham khảo PoC trong thư mục `tests/sources/` để chạy thử nghiệm.
3. Chạy `python vuln-db/parser.py` từ thư mục gốc để cập nhật báo cáo tổng hợp.
