# Package Upgrade Best Practices trên Sui (Move) | Package Upgrade Best Practices on Sui (Move) | Sui (Move) 上的包升级最佳实践

**Vấn đề phổ biến**: Upgrade package mà không guard version → attacker downgrade về version cũ có vuln, hoặc storage collision. | **Common Issue**: Upgrading a package without version guarding → an attacker could downgrade to an older version with vulnerabilities or cause storage collisions. | **常见问题**：升级包而没有版本保护 → 攻击者可以降级到带有漏洞的旧版本，或导致存储冲突。

**Pattern an toàn (từ best practice Mysten + audit OtterSec)**: | **Safe Pattern (from Mysten best practices + OtterSec audits)**: | **安全模式（源自 Mysten 最佳实践 + OtterSec 审计）**：
- UpgradeCap chỉ admin hold (transfer an toàn). | `UpgradeCap` held only by admin (safe transfer). | `UpgradeCap` 仅由管理员持有（安全转让）。
- Version field trong shared object, check tăng dần. | Version field in shared object, incrementally checked. | 共享对象中的版本字段，递增检查。
- Test compatibility với old storage (use dynamic_field để store versioned data). | Test compatibility with old storage (use `dynamic_field` to store versioned data). | 测试与旧存储的兼容性（使用 `dynamic_field` 存储版本化数据）。

**Snippet mẫu (safe)**: | **Sample Snippet (Safe)**: | **示例代码片段（安全）**：
```move
struct VersionedConfig has key {
    id: UID,
    version: u64,
    data: DataV2,
}

public entry fun upgrade_config(config: &mut VersionedConfig, new_version: u64) {
    assert!(new_version > config.version, EInvalidVersion);
    config.version = new_version;
    // Migrate data nếu cần | Migrate data if necessary | 如果需要，迁移数据
}
```

**Vuln thực tế**: Missing version check → downgrade attack (tương tự Cetus package vuln 2025). | **Real-world Vuln**: Missing version check → downgrade attack (similar to the Cetus package vulnerability in 2025). | **实际漏洞**：缺少版本检查 → 降级攻击（类似于 2025 年 Cetus 包漏洞）。
**Fix**: Luôn assert version tăng, test upgrade flow đầy đủ. | **Fix**: Always assert that the version increases and fully test the upgrade flow. | **修复**：始终断言版本增加，并完整测试升级流程。
