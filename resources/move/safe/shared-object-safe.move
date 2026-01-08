/// Module: safe::shared_object
/// VI: Pattern an toàn cho Shared Object trong Sui
/// EN: Safe pattern for Shared Object in Sui
/// ZH: Sui 中共享对象的安全模式
///
/// VI: Shared object dùng cho multi-user access (pool, registry...)
/// EN: Shared object used for multi-user access (pool, registry...)
/// ZH: 用于多用户访问的共享对象（池、注册表...）

module safe::shared_object {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct GlobalConfig has key {
        id: UID,
        version: u64,
        admin: address,
    }

    /// VI: Publish shared object – chỉ 1 lần
    /// EN: Publish shared object – only once
    /// ZH: 发布共享对象 – 仅限一次
    public fun create_shared(ctx: &mut TxContext) {
        let config = GlobalConfig {
            id: object::new(ctx),
            version: 1,
            admin: tx_context::sender(ctx),
        };
        transfer::share_object(config);
    }

    /// VI: Update config – chỉ admin, có version check
    /// EN: Update config – admin only, with version check
    /// ZH: 更新配置 – 仅限管理员，带版本检查
    public entry fun update_config(config: &mut GlobalConfig, new_version: u64, ctx: &TxContext) {
        assert!(config.admin == tx_context::sender(ctx), 0);
        assert!(new_version > config.version, 1); // VI: Prevent downgrade | EN: Prevent downgrade | ZH: 防止降级
        config.version = new_version;
    }
}

// VI: Best practice:
// EN: Best practices:
// ZH: 最佳实践：
// - VI: Chỉ share_object 1 lần.
// - EN: Only share_object once.
// - ZH: 仅限 share_object 一次。
// - VI: Luôn check version để tránh race condition.
// - EN: Always check version to avoid race conditions.
// - ZH: 始终检查版本以避免竞态条件。
// - VI: Admin control rõ ràng.
// - EN: Clear admin control.
// - ZH: 明确的管理员控制。