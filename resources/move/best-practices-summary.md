# Best Practices Summary cho Move/Sui Smart Contracts | Best Practices Summary for Move/Sui Smart Contracts | Move/Sui 智能合约最佳实践摘要

1. **Capability & Ownership** | **权能与所有权**
   - Luôn dùng key + không store cho capability. | Always use `key` without `store` for capabilities. | 权能始终使用 `key` 而不带 `store`。
   - Không public borrow cap, chỉ &mut hoặc ownership. | Do not expose capability borrowing publicly, use `&mut` or ownership. | 不要公开借用权能，仅使用 `&mut` 或所有权。

2. **Flash Loan (Hot Potato)** | **闪电贷（热土豆）**
   - Object loan phải destroy trong tx. | Loan object must be destroyed within the transaction. | 借贷对象必须在交易内销毁。
   - Không drop/transfer loan ra ngoài. | Do not drop or transfer the loan object outside. | 不要丢弃或将借贷对象转移到外部。

3. **Oracle & Price** | **预言机与价格**
   - Check staleness (timestamp + max_age). | Check for staleness (timestamp + `max_age`). | 检查过期性（时间戳 + `max_age`）。
   - Multiple sources + fallback. | Use multiple sources + fallback mechanisms. | 多源数据 + 备用机制。

4. **Kiosk/NFT**
   - Enforce KioskOwnerCap cho place/list/withdraw. | Enforce `KioskOwnerCap` for place/list/withdraw actions. | 为放置/列表/提取操作强制执行 `KioskOwnerCap`。
   - Dùng TransferPolicy cho royalty. | Use `TransferPolicy` for royalties. | 为版税使用 `TransferPolicy`。

5. **Upgrade & Shared Object** | **升级与共享对象**
   - Version check tăng dần. | Incrementally check versions. | 递增检查版本。
   - UpgradeCap chỉ admin hold. | `UpgradeCap` should only be held by the admin. | `UpgradeCap` 仅由管理员持有。

6. **Gas & Storage** | **Gas 与存储**
   - Delete object không cần. | Delete unnecessary objects. | 删除不必要的对象。
   - Tránh loop lớn trong entry function. | Avoid large loops in entry functions. | 避免在 entry 函数中使用大型循环。
   - Tối ưu Struct: Dùng Packed struct cho các loại dữ liệu cố định thay vì xé nhỏ thành Object để giảm storage rebate & gas fee.
   - Tránh dùng `Coin<T>` trong Object: Luôn unpack thành `Balance<T>` trước khi lưu vào field để tránh tạo object lồng nhau gây lãng phí bộ nhớ trên node.

7. **Move 2024 Features (Sui Move mới nhất)**
   - Sử dụng `enum`: Thay vì tạo nhiều struct rời rạc dễ gây lỗi logic, hãy dùng `enum` để quản lý các trạng thái/loại object chuẩn mực hơn.
   - Sử dụng `macro`: Dọn dẹp code rườm rà lặp đi lặp lại như vòng lặp Vector hoặc check điều kiện, tăng tốc thời gian audit.
   - Method Syntax: Gọi hàm `Vector::push_back(&mut v, item)` ngắn gọn thành `v.push_back(item)` hạn chế lỗi Reference khi viết code phức tạp.
