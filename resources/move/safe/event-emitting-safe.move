/// Module: safe::event_emitting
/// VI: Pattern an toàn emit event trong Sui
/// EN: Safe pattern for emitting events in Sui
/// ZH: 在 Sui 中触发事件的安全模式
///
/// VI: Event rất quan trọng để index off-chain (indexer, explorer)
/// EN: Events are crucial for off-chain indexing (indexers, explorers)
/// ZH: 事件对于链下索引（索引器、资源管理器）至关重要

module safe::event_emitting {
    use sui::event;

    /// VI: Event struct phải có copy + drop
    /// EN: Event struct must have copy + drop
    /// ZH: 事件结构体必须具有 copy + drop
    struct DepositEvent has copy, drop {
        user: address,
        amount: u64,
        timestamp: u64,
    }

    struct WithdrawEvent has copy, drop {
        user: address,
        amount: u64,
        timestamp: u64,
    }

    /// VI: Emit event đúng cách – luôn emit cho hành động quan trọng
    /// EN: Emitting events correctly – always emit for important actions
    /// ZH: 正确触发事件 – 始终为重要操作触发事件
    public entry fun deposit_and_emit(user: address, amount: u64, timestamp: u64) {
        // Logic deposit ở đây...

        event::emit(DepositEvent {
            user,
            amount,
            timestamp,
        });
    }

    public entry fun withdraw_and_emit(user: address, amount: u64, timestamp: u64) {
        // Logic withdraw...

        event::emit(WithdrawEvent {
            user,
            amount,
            timestamp,
        });
    }
}

// VI: Best practice:
// EN: Best practices:
// ZH: 最佳实践：
// - VI: Event struct luôn copy + drop để emit dễ dàng.
// - EN: Event structs always have copy + drop for easy emission.
// - ZH: 事件结构体始终具有 copy + drop，以便轻松触发。
// - VI: Emit mọi thay đổi trạng thái quan trọng (deposit, withdraw, transfer, config change).
// - EN: Emit for all important state changes (deposit, withdraw, transfer, config change).
// - ZH: 触发所有重要的状态更改（存款、取款、转账、配置更改）。
// - VI: Không emit data nhạy cảm (private key...).
// - EN: Do not emit sensitive data (private keys...).
// - ZH: 不要触发敏感数据（私钥...）。