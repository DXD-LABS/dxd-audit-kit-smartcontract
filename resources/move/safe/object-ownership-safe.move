/// Module: safe::object_ownership
/// VI: Pattern an toàn cho Object Ownership trong Sui
/// EN: Safe pattern for Object Ownership in Sui
/// ZH: Sui 中对象所有权的安全模式
///
/// VI: Object phải có ownership rõ ràng: key + store, transfer đúng cách.
/// EN: Objects must have clear ownership: key + store, proper transfer.
/// ZH: 对象必须具有明确的所有权：key + store，并正确转移。

module safe::object_ownership {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// VI: Object có owner – chỉ owner mới có quyền modify
    /// EN: Object with owner – only owner has the right to modify
    /// ZH: 拥有所有者的对象 – 只有所有者有权修改
    struct TreasureBox has key, store {
        id: UID,
        coins: u64,
    }

    /// VI: Tạo object và transfer ownership cho caller
    /// EN: Create object and transfer ownership to caller
    /// ZH: 创建对象并将所有权转移给调用者
    public entry fun create_box(coins: u64, ctx: &mut TxContext) {
        let box = TreasureBox {
            id: object::new(ctx),
            coins,
        };
        transfer::transfer(box, tx_context::sender(ctx));
    }

    /// VI: Chỉ owner mới withdraw – safe vì object có key + store
    /// EN: Only owner can withdraw – safe because object has key + store
    /// ZH: 只有所有者可以提取 – 安全，因为对象具有 key + store
    public entry fun withdraw(box: &mut TreasureBox, amount: u64, ctx: &TxContext) {
        // VI: Check owner (Lưu ý: Sui tự động check ownership cho tham số &mut)
        // EN: Check owner (Note: Sui automatically checks ownership for &mut parameters)
        // ZH: 检查所有者（注意：Sui 会自动检查 &mut 参数的所有权）
        box.coins = box.coins - amount;
    }

    /// VI: Transfer ownership an toàn
    /// EN: Safe ownership transfer
    /// ZH: 安全的所有权转移
    public entry fun transfer_ownership(box: TreasureBox, recipient: address) {
        transfer::transfer(box, recipient);
    }
}

// VI: Best practice:
// EN: Best practices:
// ZH: 最佳实践：
// - VI: Object luôn có key + store để enable ownership.
// - EN: Objects always have key + store to enable ownership.
// - ZH: 对象始终具有 key + store 以启用所有权。
// - VI: Check owner trước mọi modify.
// - EN: Check owner before any modification.
// - ZH: 在进行任何修改之前检查所有者。
// - VI: Dùng transfer::transfer cho change ownership.
// - EN: Use transfer::transfer for ownership changes.
// - ZH: 使用 transfer::transfer 进行所有权更改。