# Sui Pattern: Object-Centric Design | Sui 设计模式：以对象为中心的设计 | Mẫu thiết kế : Object-Centric

Mọi thứ trên Sui đều là Object, giúp tối ưu hóa song song (Mysticeti) và tránh lỗi reentrancy. | Everything on Sui is an Object, optimizing parallel execution and avoiding reentrancy. | Sui 上的所有内容都是对象，优化了并行执行并避免了重入漏洞。
Ưu tiên các objects có trạng thái riêng biệt thay vì dùng global state tập trung. | Prioritize objects with independent state instead of centralized global state. | 优先考虑具有独立状态的对象，而不是集中的全局状态。

## Vuln Mitigated: AGENT-006 (Race Condition)

Việc truy cập object-centric giúp Sui thực thi song song hiệu quả, tránh nghẽn mạng và race conditions.

## Implementation Example

Sử dụng ownership rõ ràng giúp tránh race conditions thường gặp ở shared objects.

### Code Pattern

```move
module examples::object_centric {
    use sui::object::{Self, UID};
    struct MyObject has key { id: UID, value: u64 }

    public fun create_object(value: u64, ctx: &mut TxContext): MyObject {
        MyObject { id: object::new(ctx), value }
    }
}
```
