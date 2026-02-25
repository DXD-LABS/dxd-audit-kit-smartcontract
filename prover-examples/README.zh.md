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

### 故障排除
- "Z3 not found": 将 Z3 bin 添加到 PATH，重启终端。
- "Boogie error": 检查是否安装了 .NET SDK。
- 规范失败: 检查代码逻辑或规范是否符合 Sui 文档 (docs.sui.io/move/prover)。
- 调试: 在 Prover.toml 中设置 verbosity = "High" 或 auto_trace_level = "AllCalls"。

---
*由 DXD Labs 开发。*
