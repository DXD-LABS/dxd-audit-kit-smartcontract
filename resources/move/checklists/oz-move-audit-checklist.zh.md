# OpenZeppelin Move 审计清单 (v0.1.0 - 2025年2月)

## 概述
本清单重点关注集成 **OpenZeppelin Move** 库的应用所特有的安全模式。

---

## 1. 代币 (Coin) 标准
- [ ] **铸币权限 (Minting Authority)**: 核实 `TreasuryCap` (Sui) 或等效的铸币权限受到严格保护，且未在没有 `init` 或 `AdminCap` 检查的情况下通过 `public` 或 `entry` 函数暴露。
- [ ] **元数据不可变性 (Metadata Immutability)**: 确保 `CoinMetadata` 已被冻结，或者其 `UpdateCap` 由安全的其多签（Multisig）或 DAO 持有。
- [ ] **销毁验证 (Burn Verification)**: 核实如果使用了供应量追踪器，销毁代币是否正确地减少了 `total_supply`。
- [ ] **黑名单 (DenyList) 实现**: 检查 `DenyCap` 是否被正确使用，以防止恶意行为者与代币交互（Sui 特有）。

## 2. 资源管理
- [ ] **虚型 (Phantom Type) 安全**: (MS-010) 确保所有与 Coin 相关的泛型结构体对类型参数使用 `phantom` 关键字，以防止类型替换攻击。
- [ ] **动态字段泄露**: (MS-001) 如果使用基于 OZ 的账户/金库扩展，请确保在删除父对象之前提取了动态字段。
- [ ] **有意冻结**: (MS-011) 核实未在任何需要未来升级的对象上调用 `public_freeze_object`。

## 3. 访问控制
- [ ] **权限 (Capability) 包装**: (MS-004) 审计任何将 OZ `AccessControl` 权限包装到另一个对象中的逻辑。确保“拆包”函数经过正确授权。
- [ ] **Entry 函数暴露**: (MS-012) 审计所有 `entry` 函数。确保它们是内部逻辑的简易包装，并执行严格的 `TxContext` 发送者检查。
- [ ] **多签集成**: 确保高权限操作（升级、铸币）由多签（如 `sui::multisig`）管控。

## 4. 算术与逻辑
- [ ] **舍入方向**: 核实算术运算（特别是在 DEX/借贷中）遵循 OZ 最佳实践（例如：债务向上取整，抵押品向下取整）。
- [ ] **位运算安全**: (MS-005) 如果使用位打包进行 Gas 优化，请核实掩码（Mask）和位移（Shift）边界。

## 5. 可升级性
- [ ] **包版本控制**: 确保合约根据 `VersionControl` 对象检查自身版本，以防止在升级后调用“过时”的合约。
- [ ] **权限迁移**: 核实新版本的包可以正确消耗旧版本发行的权限（Capabilities）。

---
*参考: OpenZeppelin Move Research Release (Feb 2025) & MoveScanner 2026.*
