# DXDLABS – 智能合约安全审计

![GitHub stars](https://img.shields.io/github/stars/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub license](https://img.shields.io/github/license/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)

本仓库包含由 DXDLABS 制作的公开安全审计报告。

## 项目结构

- `templates/` – 英文、中文和越南文的报告模板。
- `clients/<YYYY-MM>-<project-name>/` – 针对各个客户的审计报告。
- `resources/move/` – Move/Sui 安全模式、漏洞示例和检查清单。
- `resources/move/tests/` – Move 安全片段测试。
- `tools/` – 所使用的分析工具（Slither、Foundry 等）的配置和示例。
- `docs/` – 专业审计服务与补充文档。
- `docs/usage-guide.md` – 逐步安装和使用指南。
- `prover-examples/` – Move Prover 形式化验证示例。
- `secure-patterns/` – 基于研究的 Sui 设计模式 (2025-2026)。
- `scorecard/` – BVSS 安全计分卡工具（CLI + 交互式 Web，集成 vuln-db 和 static-analysis）。
- `vuln-db/` – YAML 格式的漏洞数据库与解析器。
- `tests/` – vuln-db 的 Move PoC 模块与单元/集成测试。

## 漏洞库与 PoC 测试

- Sui CLI 固定为 `mainnet-v1.64.2` 以保证可复现。
- 生成 summary：`cd vuln-db && python parser.py`
- 运行单元测试：`cd tests && sui move test`
- 运行单元 + testnet 集成：`cd tests && ./run_tests.sh`
- Windows (MSYS2)：用 `pacman -S mingw-w64-x86_64-python-yaml` 安装 PyYAML

## Move/Sui 审计资源

Sui Move 的安全模式和常见漏洞集合。

### 安全模式 (`resources/move/safe/`)

- `btcfi-mint-redeem-safe.move`: Sui 上 BTCfi (Liquid BTC) 的安全模式。
- `capability-safe.move`: 使用 Capability 控制权限的最佳实践。
- `coin-management-safe.move`: 处理代币、拆分和合并的安全模式。
- `coin-split-merge-safe.move`: Sui 中代币拆分/合并的安全模式。
- `dynamic-field-upgrade-safe.move`: 升级时使用动态字段的安全模式。
- `dynamic-fields-safe.move`: 安全使用动态字段进行灵活存储。
- `event-emitting-safe.move`: 用于链下索引的正确定发事件流程。
- `flash-loan-hot-potato-safe.move`: Sui 上闪电贷（Hot Potato）的安全模式。
- `kiosk-pattern-safe.move`: 用于 NFT 管理和市场的安全 Kiosk 模式。
- `nft-kiosk-listing-safe.move`: 在 Kiosk（市场）上列出 NFT 的安全模式。
- `object-ownership-safe.move`: 确保明确的对象所有权和安全的转移逻辑。
- `oracle-integration-safe.move`: 安全预言机价格集成和陈旧性检查的最佳实践。
- `package-upgrade-safe.move`: 带有版本控制的安全包升级模式。
- `shared-object-safe.move`: 共享对象的安全管理和访问控制。

### 漏洞示例 (`resources/move/vulnerable/`)

- `btcfi-balance-overflow.move`: 自定义余额逻辑导致溢出/欠载漏洞。
- `capability-abuse.move`: 通过公开引用 Capability 绕过权限控制的示例。
- `coin-overflow-merge.move`: 自定义余额合并导致 u64 溢出。
- `dos-expensive-loop.move`: 由于无限循环导致的拒绝服务 (DoS) 漏洞。
- `dynamic-field-upgrade-abuse.move`: 动态字段覆盖未检查版本。
- `flash-loan-hot-potato-abuse.move`: 闪电贷未强制执行还款/销毁。
- `friend-module-overexposure.move`: 通过 `friend` 模块过度暴露内部函数的风险。
- `kiosk-withdraw-abuse.move`: Kiosk 提取时缺少所有权检查的漏洞。
- `missing-reinit-guard.move`: 初始化函数可被多次调用的安全缺陷。
- `nft-kiosk-listing-abuse.move`: 列表 NFT 没有策略，绕过版权费。
- `oracle-stale-price.move`: 使用过时预言机价格进行操纵的漏洞。
- `package-downgrade-attack.move`: 由于缺少版本检查导致的包降级风险。
- `resource-leak.move`: 对象 ID 泄漏和导致存储膨胀的示例。

### 升级与迁移 (`resources/move/upgrade-migration/`)

- `package-upgrade-best-practices.md` ([Multi](resources/move/upgrade-migration/package-upgrade-best-practices.md)): 安全包升级和版本控制的最佳实践。
- `solidity-to-move-migration-guide.md` ([Multi](resources/move/upgrade-migration/solidity-to-move-migration-guide.md)): EVM 开发者迁移到 Move/Sui 的基本提示。

### 迁移与升级陷阱 (`resources/move/migration-upgrade/`)

- `solidity-to-move-migration-pitfalls.md` ([Multi](resources/move/migration-upgrade/solidity-to-move-migration-pitfalls.md)): 从 Solidity 迁移到 Move 的常见错误。
- `package-upgrade-pitfalls.md` ([Multi](resources/move/migration-upgrade/package-upgrade-pitfalls.md)): Move 包升级期间的常见陷阱。

### 检查清单 (`resources/move/checklists/`)

- `move-audit-checklist.md`: 审计 Sui Move 智能合约的全面检查清单。
- `move-defi-checklist.md`: DeFi（闪电贷、借贷、DEX）和 NFT/Kiosk 的专用检查清单。
- `move-btcfi-checklist.md` ([Multi](resources/move/checklists/move-btcfi-checklist.md)): BTCfi (Liquid BTC) 协议的安全检查清单。
- `move-btcfi-edge-cases.md` ([Multi](resources/move/checklists/move-btcfi-edge-cases.md)): Sui 上 BTCfi 的边缘案例检查清单。
- `quick-audit-template.md` ([Multi](resources/move/checklists/quick-audit-template.md)): 每日快速审计模板（5-10 分钟）。

### 基于研究的 Sui 设计模式 (2025-2026) (`secure-patterns/`)

- **[Access Control](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_access_control.yaml)**: 通过 capability 实现细粒度权限管理。
- **[Time Incentivization](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_time_incentivization.yaml)**: 使用 `sui::clock` 实现基于时间的奖励/惩罚。
- **[Escapability](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_escapability.yaml)**: 保证用户退出机制，增强 DeFi 安全性。
- **[Transaction Blocks](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_transaction_blocks.yaml)**: 代理工作流的原子多步操作。
- **[Gas Storage Fund](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_gas_fund.yaml)**: 管理共享对象的活跃性（Liveness）。
- **[Witness Pattern](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_witness.yaml)**: 类型安全泛型约束。

### Sui 开发者资源

- **[Sui Developer Resources 2025-2026](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/resources/sui-resources.md)**: 精选文档、视频和社区列表。

### 审计报告示例与最佳实践 (`resources/move/`)

- `sui-dev-resource-hub.md` ([Multi](resources/move/sui-dev-resource-hub.md)): 为 Sui 开发者精选的必备资源中心。
- `report-examples/example-move-lending-audit-report.md` ([Multi](resources/move/report-examples/example-move-lending-audit-report.md)): Sui 借贷协议审计报告示例。
- `best-practices-summary.md` ([Multi](resources/move/best-practices-summary.md)): Move/Sui 安全最佳实践快速摘要。
- `one-liner-tips.md` ([Multi](resources/move/one-liner-tips.md)): 适合 Move/Sui 开发者和审计员的病毒式安全提示。

### 审计工具与脚本 (`resources/move/tools-scripts/`)

- `run-move-audit.sh`: 用于运行 Sui Move 分析器和测试的快速 Bash 脚本。
- `one-click-audit.sh`: Move/Sui 一键审计启动脚本。
- `generate-report-template.py`: 从发现结果自动填充审计报告模板的 Python 脚本。

### Tests (`resources/move/tests/`)

- `safe-snippets-tests.move`: Move 安全片段测试（capability、flash loan、kiosk）。

### 真实审计案例 (`resources/move/real-cases/`)

- `cetus-clmm-pool-vuln-2025.md` ([Multi](resources/move/real-cases/cetus-clmm-pool-vuln-2025.md)): 定价逻辑中的伪造代币漏洞 (Cetus 2025)。
- `nemo-pricing-logic-vuln.md` ([Multi](resources/move/real-cases/nemo-pricing-logic-vuln.md)): USDC 池定价逻辑漏洞 (Nemo 2025)。
- `cross-chain-token-compat.md` ([Multi](resources/move/real-cases/cross-chain-token-compat.md)): 跨链代币兼容性漏洞 (Sui 2024)。
- `amm-rounding-error-exploit.md` ([Multi](resources/move/real-cases/amm-rounding-error-exploit.md)): AMM 取整错误利用 (Sui 2025)。
- `navi-health-factor-manip.md` ([Multi](resources/move/real-cases/navi-health-factor-manip.md)): 通过预言机过期数据操纵健康因子 (NAVI)。
- `scallop-isolation-bypass.md` ([Multi](resources/move/real-cases/scallop-isolation-bypass.md)): 借贷协议中的隔离模式绕过 (Scallop)。

### 漏洞数据库 (`vuln-db/`)

- `vulns/`: 以 YAML 格式分类的实际漏洞列表。
- `summary.md`: 漏洞摘要，按损失 (Loss) 排序。
- **2025 年典型黑客案例**:
  - **Cetus ($223M)**: 溢出错误 (Overflow) 和 Spoof Token。
  - **Typus ($3.44M)**: 预言机权限绕过 (Oracle Authority Bypass)。
  - **Nemo ($2.4M)**: 经济逻辑漏洞 (Economic Logic Exploit)。

### Move Prover 示例 (`prover-examples/`)

使用 MSL 规范的 Move Prover 正式验证的动手示例。

- **基础**: safe_transfer (无双花)，no_double_spend (余额不变量)。
- **DeFi**: flash_loan_safe (强制还款)，lending_collateral (超额抵押)，oracle_safe (价格新鲜度)。
- 三语指南 (VN/EN/ZH): 设置 Sui CLI/Z3/Boogie，运行 `sui move prove`。
- GitHub Actions CI: PR 自动验证。

查看 [prover-examples/README.md](./prover-examples/README.md)。

## 报告格式

每份报告均遵循统一的结构：

2. 执行摘要（风险表、主要发现）。
3. 方法论。
4. 风险分类。
5. 发现摘要。
6. 详细发现。
7. 代码质量与最佳实践。
8. 附录（环境、工具、测试摘要）。

详情请参阅 `templates/report-template.zh.md`。


