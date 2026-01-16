# Package Upgrade Pitfalls trên Sui – Những lỗi hay gặp | Package Upgrade Pitfalls on Sui – Common Mistakes | Sui 包升级陷阱 – 常见错误

- **Missing version guard** → downgrade attack (attacker rollback về version cũ có vuln). | **Missing version guard** → downgrade attack (attacker rolls back to an old version with vulnerabilities). | **缺少版本保护** → 降级攻击（攻击者回滚到具有漏洞的旧版本）。
- **Storage collision** khi migrate data (dynamic_field không versioned). | **Storage collision** when migrating data (dynamic_fields are not versioned). | **存储冲突** 迁移数据时（动态字段未进行版本化）。
- **UpgradeCap leak** (public transfer cap). | **UpgradeCap leak** (public transfer of the capability). | **UpgradeCap 泄漏**（公开转让权能）。

**Fix nhanh | Quick Fix | 快速修复**:
- Assert `new_version > current_version`.
- Use `dynamic_field` với key versioned (e.g., `"data_v2"`). | Use `dynamic_field` with versioned keys (e.g., `"data_v2"`). | 使用具有版本化键的 `dynamic_field`（例如 `"data_v2"`）。
- `UpgradeCap` chỉ admin hold, transfer an toàn. | `UpgradeCap` should only be held by admins, ensure safe transfer. | `UpgradeCap` 仅由管理员持有，确保安全转让。

Reference: OtterSec Sui upgrade audits 2025.
