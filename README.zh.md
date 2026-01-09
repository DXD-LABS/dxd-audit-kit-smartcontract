# DXDLABS – 智能合约安全审计

![GitHub stars](https://img.shields.io/github/stars/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub license](https://img.shields.io/github/license/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)

本仓库包含由 DXDLABS 制作的公开安全审计报告。

## 项目结构

- `templates/` – 英文、中文和越南文的报告模板。
- `clients/<YYYY-MM>-<project-name>/` – 针对各个客户的审计报告。
- `resources/move/` – Move/Sui 安全模式、漏洞示例和检查清单。
- `tools/` – 所使用的分析工具（Slither、Foundry 等）的配置和示例。

## Move/Sui 审计资源

Sui Move 的安全模式和常见漏洞集合。

### 安全模式 (`resources/move/safe/`)
- `btcfi-mint-redeem-safe.move`: Sui 上 BTCfi (Liquid BTC) 的安全模式。
- `capability-safe.move`: 使用 Capability 控制权限的最佳实践。
- `coin-management-safe.move`: 处理代币、拆分和合并的安全模式。
- `dynamic-fields-safe.move`: 安全使用动态字段进行灵活存储。
- `event-emitting-safe.move`: 用于链下索引的正确定发事件流程。
- `kiosk-pattern-safe.move`: 用于 NFT 管理和市场的安全 Kiosk 模式。
- `object-ownership-safe.move`: 确保明确的对象所有权和安全的转移逻辑。
- `oracle-integration-safe.move`: 安全预言机价格集成和陈旧性检查的最佳实践。
- `package-upgrade-safe.move`: 带有版本控制的安全包升级模式。
- `shared-object-safe.move`: 共享对象的安全管理和访问控制。

### 漏洞示例 (`resources/move/vulnerable/`)
- `btcfi-balance-overflow.move`: 自定义余额逻辑导致溢出/欠载漏洞。
- `capability-abuse.move`: 通过公开引用 Capability 绕过权限控制的示例。
- `dos-expensive-loop.move`: 由于无限循环导致的拒绝服务 (DoS) 漏洞。
- `friend-module-overexposure.move`: 通过 `friend` 模块过度暴露内部函数的风险。
- `kiosk-withdraw-abuse.move`: Kiosk 提取时缺少所有权检查的漏洞。
- `missing-reinit-guard.move`: 初始化函数可被多次调用的安全缺陷。
- `oracle-stale-price.move`: 使用过时预言机价格进行操纵的漏洞。
- `package-downgrade-attack.move`: 由于缺少版本检查导致的包降级风险。
- `resource-leak.move`: 对象 ID 泄漏和导致存储膨胀的示例。

### 检查清单 (`resources/move/checklists/`)
- `move-audit-checklist.md`: 审计 Sui Move 智能合约的全面检查清单。

## 报告格式

每份报告均遵循统一的结构：

1. 概述（项目、范围、提交哈希、网络）。
2. 执行摘要（风险表、主要发现）。
3. 方法论。
4. 风险分类。
5. 发现摘要。
6. 详细发现。
7. 代码质量与最佳实践。
8. 附录（环境、工具、测试摘要）。

详情请参阅 `templates/report-template.zh.md`。
