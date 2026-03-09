# Sui Specific Vulnerabilities | Sui Specific Vulnerabilities | Sui 特有漏洞

Khác với Aptos hay Diem (Move nguồn gốc), kiến trúc hướng đối tượng (Object-centric) của Sui dẫn đến một số lỗ hổng bảo mật đặc thù. Tài liệu này liệt kê các lổ hổng thường gặp nhất trong các kỳ Audit trên Sui. | Unlike Aptos or Diem (original Move), Sui's Object-centric architecture leads to some specific security vulnerabilities. This document lists the most common vulnerabilities found during Sui Audits. | 与 Aptos 或 Diem（原始 Move）不同，Sui 极其以对象为中心的架构导致了一些特定的安全漏洞。本文档列出了 Sui 审计中最常见的漏洞。

## 1. Object State & Ownership Bypass | 对象状态与所有权绕过

- **Mô tả | Description | 描述:** Lạm dụng hàm `public_transfer` hay `public_share_object` đối với các Object **không có `store` ability**. | Abusing `public_transfer` or `public_share_object` functions for Objects **without the `store` ability**. | 滥用 `public_transfer` 或 `public_share_object` 函数处理**没有 `store` 能力**的对象。
- **Lỗ hổng | Vulnerability | 漏洞:** Các Object không có `store` được thiết kế để bị ràng buộc với ngữ cảnh hệ thống hiện tại, và không thể được transfer tùy tiện. Nếu gọi trực tiếp sẽ phá vỡ kiểm soát truy cập. | Objects without `store` are bound to the current system context and cannot be transferred arbitrarily. Direct calls break access control. | 没有 `store` 的对象绑定到当前系统上下文，不能随意转移。直接调用会破坏访问控制。
- **Phòng chống | Prevention | 预防:** Chỉ transfer các objects có `store`. Với object không `store`, hãy dùng `transfer::transfer` nội bộ trong module. | Only transfer objects with `store`. For objects without `store`, use `transfer::transfer` internally. | 仅转移具有 `store` 的对象。对于没有 `store` 的对象，在模块内部使用 `transfer::transfer`。

## 2. Dynamic Field (DF) & Dynamic Object Field (DOF) Lifecycle Leaks | 动态字段 (DF) 与动态对象字段 (DOF) 生命周期泄漏

- **Mô tả | Description | 描述:** Thất bại trong việc xóa hoặc quản lý các Data cấu trúc động. | Failure to delete or manage dynamic data structures. | 未能删除或管理动态数据结构。
- **Lỗ hổng 1 (Rò rỉ bộ nhớ) | Leak 1 (Memory Leak) | 漏洞 1（内存泄漏）:** Khi xóa một parent object, DOF không tự động phân rã. DOF đó bị khóa vĩnh viễn trên chain, làm kẹt tài sản. | When deleting a parent object, DOFs are not automatically unpacked. The DOF is permanently locked on the chain, causing trapped assets. | 删除父对象时，DOF 不会自动解包。DOF 会永久锁定在链上，导致资产被困。
- **Lỗ hổng 2 (Bypass Access Control) | Leak 2 (Bypass Access Control) | 漏洞 2（绕过访问控制）:** Kẻ tấn công tháo DOF khỏi object A (sở hữu chung) rồi giấu vào object B mình sở hữu. | An attacker removes a DOF from a shared object A and attaches it to their own object B. | 攻击者从共享对象 A 移除 DOF 并将其附加到自己拥有的对象 B。

## 3. Lỗi quản lý Reference (`&mut` Alias & Overwriting) | 引用管理错误

- **Mô tả | Description | 描述:** Vấn đề xảy ra khi gán `&mut` cho Object phức tạp. | Issues arise when assigning `&mut` to complex Objects. | 将 `&mut` 分配给复杂对象时会出现问题。
- **Lỗ hổng | Vulnerability | 漏洞:** Nếu hai biến local cùng modify các field bên trong struct theo cách không lường trước (chẳng hạn swap field trên vector object), dẫn đến dữ liệu không nhất quán. | If two local variables modify internal fields unexpectedly (e.g., field swaps in an object vector), it leads to inconsistent data. | 如果两个局部变量以意外方式修改内部字段（例如，在一个对象向量中交换字段），则会导致数据不一致。

## 4. Bỏ qua Sui Coin vs Balance | 忽略 Sui Coin 与 Balance

- **Mô tả | Description | 描述:** Thao tác sai lầm lên biến tiền tệ. | Incorrect operations on currency variables. | 对货币变量的操作不正确。
- **Lỗ hổng | Vulnerability | 漏洞:** Lưu trữ `Coin<T>` trong struct làm phình storage do `Coin` là object. Cần phải swap từ `Coin` sang `Balance` (Value) trước khi lưu (sử dụng `coin::into_balance()`). | Storing `Coin<T>` within a struct bloats storage since `Coin` is an object. It must be swapped to `Balance` (Value) before storing using `coin::into_balance()`. | 将 `Coin<T>` 存储在结构中会使存储膨胀，因为 `Coin` 是一个对象。在存储之前，必须使用 `coin::into_balance()` 将其转换为 `Balance` (Value)。

## 5. Dùng Object sai Type thay vì Generics mạnh T | 错误使用对象类型而非泛型 T

- **Mô tả | Description | 描述:** Sử dụng object ID thay vì type generic. | Using object IDs instead of type generics. | 使用对象 ID 而不是类型泛型。
- **Lỗ hổng | Vulnerability | 漏洞:** Lỗi type checking tĩnh. Hacker có thể đẩy (spoof) một pseudo-object khác để đánh lừa hệ thống. Sui an toàn nhất khi kết hợp Type generics và Object ownership. | Static type checking failure. A hacker can spoof another pseudo-object to trick the system. Sui is safest combining Type generics and Object ownership. | 静态类型检查失败。黑客可以伪造另一个伪对象来欺骗系统。Sui 将类型泛型与对象所有权结合才是最安全的。

**Reference | 参考:**

- OtterSec Sui Vulnerability Post Mortems
- Sui Move by Example (Official Docs)
