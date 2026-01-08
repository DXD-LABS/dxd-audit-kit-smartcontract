/// Module: safe::dynamic_fields
/// VI: Pattern an toàn dùng Dynamic Fields trong Sui
/// EN: Safe pattern for using Dynamic Fields in Sui
/// ZH: 在 Sui 中使用动态字段的安全模式
///
/// VI: Dynamic fields linh hoạt cho storage key-value (như mapping)
/// EN: Dynamic fields are flexible for key-value storage (like mapping)
/// ZH: 动态字段对于键值存储非常灵活（类似于 mapping）

module safe::dynamic_fields {
    use sui::object::UID;
    use sui::dynamic_field;

    struct UserData has key {
        id: UID,
    }

    struct Score has store, drop {  // Value type
    points: u64,
    }

    /// VI: Add dynamic field an toàn
    /// EN: Add dynamic field safely
    /// ZH: 安全地添加动态字段
    public entry fun add_score(user: &mut UserData, name: vector<u8>, points: u64) {
        let score = Score { points };
        dynamic_field::add(&mut user.id, name, score);
    }

    /// VI: Read dynamic field an toàn
    /// EN: Read dynamic field safely
    /// ZH: 安全地读取动态字段
    public fun get_score(user: &UserData, name: vector<u8>): u64 {
        let score: &Score = dynamic_field::borrow(&user.id, name);
        score.points
    }
}

// VI: Best practice:
// EN: Best practices:
// ZH: 最佳实践：
// - VI: Dynamic field phù hợp cho data sparse (không biết key trước).
// - EN: Dynamic fields are suitable for sparse data (keys not known in advance).
// - ZH: 动态字段适用于稀疏数据（预先不知道键）。
// - VI: Không dùng cho data frequent access (gas cao hơn bag/table).
// - EN: Do not use for frequent access data (higher gas than bag/table).
// - ZH: 不要用于频繁访问的数据（比 bag/table 的 gas 更高）。
// - VI: Luôn check exist trước borrow_mut nếu cần.
// - EN: Always check for existence before borrow_mut if necessary.
// - ZH: 如果需要，在 borrow_mut 之前始终检查是否存在。