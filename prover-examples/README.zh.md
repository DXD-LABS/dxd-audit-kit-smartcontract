# Move Prover Examples (Chinese)

使用 MSL 规范的 Move Prover 形式化验证动手示例。

## 设置与运行指南

### 先决条件

- **Sui CLI**: `cargo install --locked sui --git https://github.com/MystenLabs/sui.git`
- **Z3 Solver**:
  - Ubuntu: `sudo apt update && sudo apt install z3 libz3-dev`
  - Mac: `brew install z3`
  - Windows: 从 Microsoft Z3 GitHub 下载，添加到 PATH
- **Boogie**: `dotnet tool install -g boogie` (需要 .NET SDK)

### 运行 Prover

```bash
cd prover-examples
sui move prove
```

所有规范应验证通过。

### 示例

- **safe_transfer.move**: 安全的代币转移验证，余额不足时中止，无双花（旧余额 = 新余额 + 转移金额）。
- **no_double_spend.move**: 余额不变量 >=0，安全提款。
- **flash_loan_safe.move**: 验证闪电贷还款强制执行（DeepBook 风格，还款后销毁 hot potato）。
- **lending_collateral.move**: 仅在超额抵押 150% 时借贷，维护无低抵押不变量。
- **oracle_safe.move**: 预言机价格新鲜度检查（时间戳 stale > max_age 时中止）。
- **no_double_spend_transfer.move**: 无双花代币转移（余额不足中止，发送者余额 -= 金额，接收者 += 金额，总量守恒不变量）。
- **liquidation_safe.move**: 安全清算检查（仅在低抵押 >120% 时 needs_liquidation 为 true，健康仓位清算中止）。
- **oracle_deviation_safe.move**: 预言机新鲜度 + 偏差检查（stale >300s 或偏差 >5% 时中止）。

### AI-Agent 专属示例 (AI-Agent Specific Examples)

在 Sui 上证明对 AI 代理安全性至关重要的不变量的示例（代理钱包，机器交易）:

- **agent_spend_limit_enforce.move**: 证明代理钱包的严格累计支出限额（防止恶意或中毒的支出）。
  - `invariant policy.spent <= policy.limit`: 总支出不超过用户定义的限制（累计更新）。
  - `aborts_if action.amount + policy.spent > policy.limit with E_SPEND_LIMIT_EXCEEDED`: 超过限制时中止。
  - `ensures policy.spent == old(policy.spent) + action.amount`: 交易成功后支出正确增加。
  - `modifies policy.spent`: 仅在通过检查后更新支出。
  - 用例: 具有可编程支出上限的 Beep/Talus 代理钱包（例如每日/每月限额），防止因内存中毒或多步恶意交易导致的缓慢耗尽。

- **agent_intent_verification.move**: 在执行代理动作前验证链上意图是否匹配（防止意图欺骗/不匹配）。
  - `invariant intent_verified == true`: 意图必须得到验证。
  - `aborts_if !intent_verified with E_INTENT_MISMATCH`: 意图不匹配时中止。
  - `ensures intent_hash_post == old(intent_hash) && intent_verified == true`: 验证后保持不变。
  - `modifies intent_verified`: 仅在验证通过时设置为 true。
  - 用例: 代理仅在离线 LLM/用户的意图在链上通过验证时执行交易，防止欺骗性交易或未经授权的调用。

- **agent_unauthorized_tool_prevent.move**: 防止白名单之外的恶意工具调用（工具白名单 + 权限检查）。
  - `aborts_if !vector::contains(&policy.allowed_tools, &tool_id) with E_UNAUTHORIZED_TOOL`: 工具不在白名单中时中止。
  - `ensures vector::contains(&policy.allowed_tools, &tool_id)`: 只有允许的工具才能执行。
  - `invariant forall t in policy.allowed_tools: t is valid_tool_id`: (可选的) 白名单完整性的全局不变量。
  - 用例: 代理只能调用允许的工具，防止权限提升。

- **agent_no_rogue_object_delete.move**: 防止代理删除或修改未经授权的对象（Sui 特定的对象安全性）。
  - `aborts_if !object::is_owner(agent, object_id) with E_UNAUTHORIZED_OBJECT_ACCESS`: 只有代理拥有对象时才能删除。
  - `invariant object::exists(object_id) || deleted`: 对象不会被未经授权地删除。
  - `ensures !object::exists(object_id) ==> old(object::owner(object_id)) == agent_address`: 只有代理才能删除其对象。
  - 用例: 代理控制 Kiosk 或动态字段，但不能恶意删除共享对象/金库资产。

- **agent_shared_object_consistency.move**: 证明多代理访问共享对象时的一致性（防止代理工作流中的并发/竞争问题）。
  - `invariant shared_vault.balance == sum(agent_contributions) - total_withdrawn`: 余额在多方访问后守恒。
  - `aborts_if version_mismatch(shared_object.version, expected_version) with E_VERSION_CONFLICT`: 版本不匹配时中止（Sui 对象版本控制）。
  - `ensures shared_vault.balance_post == old(shared_vault.balance) - withdrawal_amount`: 正确提款，无重复提款。
  - 用例: 多代理协调（例如，代理群访问金库），防止并行交易中的竞争条件。

### 故障排除

- "Z3 not found": 将 Z3 bin 添加到 PATH，重启终端。
- "Boogie error": 检查是否安装了 .NET SDK。
- 规范失败: 检查代码逻辑或规范是否符合 Sui 文档 (docs.sui.io/move/prover)。
- 调试: 在 Prover.toml 中设置 verbosity = "High" 或 auto_trace_level = "AllCalls"。

---
*由 DXD Labs 开发。*
