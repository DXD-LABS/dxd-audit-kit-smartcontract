/// Module: vuln::missing_reinit
/// VI: Ví dụ LỖI – Thiếu reinitialization guard khi upgrade
/// EN: VULNERABILITY Example – Missing reinitialization guard during upgrade
/// ZH: 漏洞示例 – 升级期间缺失重新初始化保护

module vuln::missing_reinit {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    struct Config has key {
        id: UID,
        admin: address,
        initialized: bool,  // Flag
    }

    public entry fun init(config: &mut Config, ctx: &TxContext) {
        // VI: LỖ HỔNG: Không check initialized → có thể gọi nhiều lần để reset admin
        // EN: VULNERABILITY: No initialized check → can be called multiple times to reset admin
        // ZH: 漏洞：没有初始化检查 → 可以多次调用来重置管理员
        config.admin = tx_context::sender(ctx);
        config.initialized = true;
    }
}

// VI: Risk: High – Attacker gọi init nhiều lần → overwrite admin
// EN: Risk: High – Attacker calls init multiple times → overwrite admin
// ZH: 风险：高 – 攻击者多次调用 init → 覆盖管理员

// VI: Fix:
// EN: Fix:
// ZH: 修复：
// - VI: Thêm assert!(!config.initialized, EAlreadyInitialized);
// - EN: Add assert!(!config.initialized, EAlreadyInitialized);
// - ZH: 添加 assert!(!config.initialized, EAlreadyInitialized);