/// Module: safe::capability
/// VI: Pattern an toàn cho Capability trong Sui
/// EN: Safe pattern for Capability in Sui
/// ZH: Sui 中 Capability 的安全模式
///
/// VI: Capability là "chìa khóa" kiểm soát quyền – phải unique, không duplicate, không leak.
/// EN: Capability is the "key" to control permissions – must be unique, non-duplicable, and no leak.
/// ZH: Capability 是控制权限的“钥匙”——必须唯一、不可复制且不泄露。

module safe::capability {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;

    /// VI: Capability chỉ admin mới có quyền thực hiện hành động nhạy cảm
    /// EN: Capability that only admin has the right to perform sensitive actions
    /// ZH: 仅管理员有权执行敏感操作的 Capability
    struct AdminCap has key { id: UID }

    /// VI: Tạo AdminCap duy nhất cho publisher (deployer)
    /// EN: Create a unique AdminCap for the publisher (deployer)
    /// ZH: 为发布者（部署者）创建唯一的 AdminCap
    public fun create_admin_cap(ctx: &mut TxContext): AdminCap {
        AdminCap {
            id: object::new(ctx)
        }
    }

    /// VI: Function nhạy cảm – chỉ gọi được nếu có AdminCap thật
    /// EN: Sensitive function – can only be called with a valid AdminCap
    /// ZH: 敏感函数 – 只能通过有效的 AdminCap 调用
    public entry fun restricted_action(_cap: &AdminCap) {
        // VI: Logic admin only ở đây
        // EN: Admin only logic here
        // ZH: 此处仅限管理员逻辑
        
        // VI: Ví dụ: mint token, pause contract, withdraw fee...
        // EN: Example: mint token, pause contract, withdraw fee...
        // ZH: 例如：铸造代币、暂停合约、提取费用...
    }

    /// VI: Transfer cap cho address mới – ownership rõ ràng
    /// EN: Transfer cap to a new address – clear ownership
    /// ZH: 将 cap 转移到新地址 – 所有权明确
    public entry fun transfer_cap(cap: AdminCap, recipient: address) {
        transfer::transfer(cap, recipient);
    }
}

// VI: Best practice:
// EN: Best practices:
// ZH: 最佳实践：
// - VI: AdminCap có key, không store → không thể duplicate
// - EN: AdminCap has key, no store → cannot be duplicated
// - ZH: AdminCap 具有 key，没有 store → 无法复制
// - VI: Chỉ transfer, không public borrow hoặc share
// - EN: Only transfer, no public borrow or share
// - ZH: 仅限转移，不公开借用或共享
// - VI: Không drop cap nếu không cần (has drop nếu muốn destroy)
// - EN: Do not drop cap unless necessary (has drop if you want to destroy)
// - ZH: 除非必要，否则不要 drop cap（如果想销毁，则需要 has drop）