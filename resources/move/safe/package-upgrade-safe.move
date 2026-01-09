/// Module: safe::upgrade_guard
/// Description: 
/// EN: Secure pattern for package upgrades in Sui.
/// VI: Pattern an toàn khi upgrade package trong Sui.
/// ZH: Sui 中包升级的安全模式。

module safe::upgrade_guard {
    use sui::package::{Self, UpgradeCap};

    struct Config has key {
        id: UID,
        version: u64,
        cap: UpgradeCap,
    }

    public fun create_upgrade_cap(ctx: &mut TxContext): Config {
        let cap = package::new_upgrade_cap(ctx);
        Config {
            id: object::new(ctx),
            version: 1,
            cap,
        }
    }

    public entry fun upgrade(config: &mut Config, new_version: u64) {
        assert!(new_version > config.version, 0);
        // package::authorize_upgrade(&mut config.cap, ...); // Upgrade logic
        config.version = new_version;
    }
}

// Best practice:
// EN: Always verify version increments and use UpgradeCap from the package module.
// VI: Luôn kiểm tra version tăng dần và sử dụng UpgradeCap từ package module.
// ZH: 始终验证版本增量并使用包模块中的 UpgradeCap。