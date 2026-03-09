# Dynamic Fields & Lifecycle Management | 动态字段与生命周期管理

Dynamic Fields (DF) và Dynamic Object Fields (DOF) sinh ra để giải quyết nhu cầu lưu trữ mảng bộ nhớ động và khổng lồ (như Hashmap, Collection) mà không làm nghẽn Global Storage. | Dynamic Fields (DF) and Dynamic Object Fields (DOF) were created to address the need for vast, dynamic memory arrays (like Hashmaps, Collections) without clogging Global Storage. | 动态字段 (DF) 和动态对象字段 (DOF) 的创建是为了满足海量动态内存阵列（如哈希表、集合）的需求，而不会阻塞全局存储。

Tài liệu này hướng dẫn Developers sử dụng Mảng Động an toàn, tránh bị rò rỉ hoặc khóa cứng tài sản. | This document guides Developers on using Dynamic Arrays safely, avoiding asset leaks or permanent locks. | 本文档指导开发人员安全地使用动态数组，避免资产泄漏或永久锁定。

## 1. Phân Biệt DF và DOF | Distinguishing DF and DOF | 区分 DF 和 DOF

- **Dynamic Field (`sui::dynamic_field`):** Lưu trữ những giá trị nguyên thủy (primitives) hoặc struct đơn giản. | Stores primitives or simple structs. | 存储原语或简单的结构体。
- **Dynamic Object Field (`sui::dynamic_object_field`):** Lưu giữ một Object thực thụ (có key, UID riêng). | Stores an actual Object (with key, UUID). | 存储一个实际的对象（具有 key，UUID）。

## 2. Thêm và Chỉnh Sửa \ Add and Modify \ 添加与修改

Trước khi thêm, cần kiểm tra `exists_` để không gặp lỗi Duplicate Entry, điều này sẽ hủy sạch PTB. | Before adding, check `exists_` to avoid a Duplicate Entry error, which would abort the entire PTB. | 在添加之前，检查 `exists_` 以避免发生重复条目错误，这会中止整个 PTB。

## 3. Cạm Bẫy Vòng Đời: Con Khóc Theo Cha | Lifecycle Pitfall: Orphans | 生命周期陷阱：孤儿对象

Sự chênh lệch lộ ra khi bạn quyết định **Hủy (Delete)** Parent Object: | A dangerous mismatch is exposed when you decide to **Delete** the Parent Object: | 当您决定**删除**父对象时，会暴露出危险的不匹配：

Nếu bạn gọi `object::delete(knight_id)` hủy hiệp sĩ: Move VM sẽ tự drop sạch mọi `Dynamic Field`. | If you call `object::delete(knight_id)` to destroy the knight: Move VM automatically drops all `Dynamic Field`s. | 如果你调用 `object::delete(knight_id)` 摧毁骑士：Move VM 自动丢弃所有 `Dynamic Field`。

**LỖ HỔNG XẢY RA | VULNERABILITY OCCURS | 漏洞发生:** Nếu Knight cầm *Dynamic Object Field* là Thanh Cự Kiếm (Object chuẩn). Và bạn gọi `object::delete(knight_id)`. Move VM sẽ xóa Knight và xé đứt liên kết DOF. Thanh Kiếm đó trở thành mồ côi (Orphaned Object) và bị khóa VĨNH VIỄN, gây thất thoát tài sản. | If the Knight holds a *Dynamic Object Field* (a standard Object Sword). Calling `object::delete` destroys the Knight and breaks the DOF link. The Sword becomes an Orphaned Object locked FOREVER, causing lost assets. | 如果骑士持有*动态对象字段*（标准对象剑）。调用 `object::delete` 会破坏骑士并打破 DOF 链接。那把剑变成了孤立对象，被永远锁定，导致资产丢失。

**Best Practice cho Developer | Developer Best Practice | 开发者最佳实践:**
Luôn phải xóa/gỡ (Remove) TẤT CẢ Dynamic Object Fields trước khi Drop Parent. | Always remove ALL Dynamic Object Fields before dropping the Parent. | 必须在丢弃父对象之前移除所有动态对象字段。

```move
let sword: Sword = dof::remove(&mut knight.id, b"weapon_slot");
transfer::public_transfer(sword, sender); 
```
