# DXDLABS – Kiểm định Bảo mật Smart Contract

![GitHub stars](https://img.shields.io/github/stars/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub license](https://img.shields.io/github/license/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)

Kho lưu trữ này chứa các báo cáo kiểm định bảo mật công khai được thực hiện bởi DXDLABS.

## Cấu trúc Dự án

- `templates/` – Các mẫu báo cáo bằng tiếng Anh, tiếng Việt và tiếng Trung.
- `clients/<YYYY-MM>-<project-name>/` – Báo cáo kiểm định cho từng khách hàng cụ thể.
- `resources/move/` – Các pattern bảo mật Move/Sui, ví dụ lỗ hổng và danh sách kiểm tra (checklist).
- `tools/` – Cấu hình và ví dụ về các công cụ phân tích được sử dụng (Slither, Foundry, v.v.).

## Tài nguyên Kiểm định Move/Sui

Tập hợp các pattern bảo mật và các lỗ hổng phổ biến cho Sui Move.

### Pattern An toàn (`resources/move/safe/`)
- `btcfi-mint-redeem-safe.move`: Pattern an toàn cho BTCfi (Liquid BTC) trên Sui.
- `capability-safe.move`: Các thực hành tốt nhất khi sử dụng Capability để kiểm soát quyền.
- `coin-management-safe.move`: Các pattern an toàn để xử lý Coin, chia tách (split) và hợp nhất (merge).
- `coin-split-merge-safe.move`: Pattern an toàn cho việc split/merge Coin trong Sui.
- `dynamic-field-upgrade-safe.move`: Pattern an toàn dùng Dynamic Fields khi nâng cấp (upgrade).
- `dynamic-fields-safe.move`: Cách sử dụng Dynamic Fields an toàn để lưu trữ linh hoạt.
- `event-emitting-safe.move`: Quy trình emit event đúng cách để phục vụ việc index off-chain.
- `flash-loan-hot-potato-safe.move`: Pattern an toàn cho Flash Loan (Hot Potato) trên Sui.
- `kiosk-pattern-safe.move`: Pattern Kiosk an toàn để quản lý NFT và sàn giao dịch.
- `nft-kiosk-listing-safe.move`: Pattern an toàn khi listing NFT trên Kiosk (marketplace).
- `object-ownership-safe.move`: Đảm bảo quyền sở hữu object rõ ràng và logic chuyển nhượng an toàn.
- `oracle-integration-safe.move`: Các thực hành tốt nhất để tích hợp giá oracle an toàn và kiểm tra độ trễ (staleness).
- `package-upgrade-safe.move`: Pattern nâng cấp package an toàn với kiểm soát phiên bản.
- `shared-object-safe.move`: Quản lý Shared Object an toàn và kiểm soát truy cập.

### Ví dụ Lỗ hổng (`resources/move/vulnerable/`)
- `btcfi-balance-overflow.move`: Logic balance tùy chỉnh dẫn đến lỗ hổng tràn số (overflow/underflow).
- `capability-abuse.move`: Ví dụ về việc vượt qua quyền kiểm soát thông qua tham chiếu công khai tới Capability.
- `coin-overflow-merge.move`: Lỗi tràn số (u64 overflow) khi merge balance tùy chỉnh.
- `dos-expensive-loop.move`: Lỗ hổng Từ chối Dịch vụ (DoS) do các vòng lặp không giới hạn.
- `dynamic-field-upgrade-abuse.move`: Lỗi ghi đè Dynamic Field mà không kiểm tra phiên bản.
- `flash-loan-hot-potato-abuse.move`: Lỗ hổng Flash loan không bắt buộc hoàn trả hoặc tiêu hủy đối tượng.
- `friend-module-overexposure.move`: Rủi ro khi để lộ quá mức các hàm nội bộ thông qua các module `friend`.
- `kiosk-withdraw-abuse.move`: Lỗ hổng khi Kiosk thiếu kiểm tra quyền sở hữu khi rút NFT.
- `missing-reinit-guard.move`: Lỗi bảo mật khi các hàm khởi tạo có thể bị gọi nhiều lần.
- `nft-kiosk-listing-abuse.move`: Lỗi listing NFT không thông qua policy, dẫn đến thất thoát phí bản quyền (royalty).
- `oracle-stale-price.move`: Lỗ hổng sử dụng giá oracle cũ để thao túng.
- `package-downgrade-attack.move`: Rủi ro hạ cấp package do thiếu kiểm tra phiên bản.
- `resource-leak.move`: Ví dụ về rò rỉ ID của object và gây phình to bộ lưu trữ (storage bloat).

### Danh sách kiểm tra (`resources/move/checklists/`)
- `move-audit-checklist.md`: Danh sách kiểm tra toàn diện để kiểm định smart contract Sui Move.
- `move-defi-checklist.md`: Danh sách kiểm tra đặc thù cho DeFi (Flash Loan, Lending, DEX) và NFT/Kiosk.

## Định dạng Báo cáo

Mỗi báo cáo tuân theo cấu trúc thống nhất:

1. Tổng quan (dự án, phạm vi, mã hash commit, mạng lưới).
2. Tóm tắt điều hành (bảng rủi ro, các phát hiện chính).
3. Phương pháp luận.
4. Phân loại rủi ro.
5. Tóm tắt các phát hiện.
6. Chi tiết các phát hiện.
7. Chất lượng mã nguồn & Thực hành tốt nhất.
8. Phụ lục (môi trường, công cụ, tóm tắt kiểm tra).

Xem `templates/report-template.vi.md` để biết thêm chi tiết.
