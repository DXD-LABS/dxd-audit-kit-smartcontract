# Move Prover Examples

## Hướng dẫn Setup &amp; Run (Tiếng Việt)

### Prerequisites
- **Sui CLI**: `cargo install --locked sui --git https://github.com/MystenLabs/sui.git`
- **Z3 Solver**:
  - Ubuntu: `sudo apt update &amp;&amp; sudo apt install z3 libz3-dev`
  - Mac: `brew install z3`
  - Windows: Download from Microsoft Z3 GitHub releases, add bin to PATH
- **Boogie**: `dotnet tool install -g boogie` (requires .NET SDK)

### Chạy Prover
```bash
cd prover-examples
sui move prove
```

Nếu tất cả specs verified OK, không lỗi.

### Examples
- **safe_transfer.move**: Verify transfer coin an toàn, aborts nếu insufficient balance, no double-spend (old balance = new + amount transferred).
- **no_double_spend.move**: Invariant balance không âm, withdraw aborts nếu insufficient.
- **flash_loan_safe.move**: Verify flash loan repayment enforced (DeepBook-style, hot potato destroy nếu repay đủ).
- **lending_collateral.move**: Borrow chỉ nếu over-collateralized 150%, invariant no under-collateral.
- **oracle_safe.move**: Oracle price fresh (aborts nếu timestamp cũ > max_age).
- **no_double_spend_transfer.move**: No double-spend coin transfer (aborts insufficient balance, sender balance -= amount, recipient += amount, total conserve invariant).
- **liquidation_safe.move**: Safe liquidation check (needs_liquidation true chỉ under-collateral >120%, aborts liquidate healthy position).
- **oracle_deviation_safe.move**: Oracle freshness + deviation check (aborts stale >300s hoặc deviation >5%).

### Troubleshooting
- \"Z3 not found\": Add Z3 bin to PATH, restart terminal.
- \"Boogie error\": Check .NET SDK installed.
- Specs fail: Check code logic/spec match Sui docs (docs.sui.io/move/prover).
- Verbosity cao: Edit Prover.toml verbosity = \"High\".

## Setup &amp; Run Guide (English)

### Prerequisites
- **Sui CLI**: `cargo install --locked sui --git https://github.com/MystenLabs/sui.git`
- **Z3 Solver**:
  - Ubuntu: `sudo apt update &amp;&amp; sudo apt install z3 libz3-dev`
  - Mac: `brew install z3`
  - Windows: Download from Microsoft Z3 GitHub, add to PATH
- **Boogie**: `dotnet tool install -g boogie`

### Run Prover
```bash
cd prover-examples
sui move prove
```

All specs should verify OK.

### Examples
- **safe_transfer.move**: Safe coin transfer verification, aborts on insufficient balance, no double-spend.
- **no_double_spend.move**: Balance invariant &gt;=0, safe withdraw.
- **flash_loan_safe.move**: Verify flash loan repayment enforced (DeepBook-style, hot potato destroyed if repaid).
- **lending_collateral.move**: Borrow only if over-collateralized 150%, no under-collateral invariant.
- **oracle_safe.move**: Oracle price freshness check (aborts if timestamp stale &gt; max_age).
- **no_double_spend_transfer.move**: No double-spend coin transfer (aborts insufficient balance, sender balance -= amount, recipient += amount, total conserve invariant).
- **liquidation_safe.move**: Safe liquidation check (needs_liquidation true only under-collateral &gt;120%, aborts liquidate healthy position).
- **oracle_deviation_safe.move**: Oracle freshness + deviation check (aborts stale &gt;300s or deviation &gt;5%).

### Troubleshooting
- Z3 path issues: Verify `z3 --version`
- Boogie .NET errors: Install .NET SDK
- Failing specs: Review Sui Prover docs
- Debug: Prover.toml auto_trace_level = \"AllCalls\"

## Setup & Run Guide (中文)

### 先决条件
- **Sui CLI**: `cargo install --locked sui --git https://github.com/MystenLabs/sui.git`
- **Z3 Solver**:
  - Ubuntu: `sudo apt update &amp;&amp; sudo apt install z3 libz3-dev`
  - Mac: `brew install z3`
  - Windows: 从 Microsoft Z3 GitHub 下载，添加到 PATH
- **Boogie**: `dotnet tool install -g boogie`

### 运行 Prover
```bash
cd prover-examples
sui move prove
```

所有规范应验证通过。

### 示例
- **safe_transfer.move**: 安全的 coin 转移验证，不足余额中止，无双花。
- **no_double_spend.move**: 余额不变量 &gt;=0，安全提取。
- **flash_loan_safe.move**: 验证闪电贷还款强制执行（DeepBook 风格，还款后销毁 hot potato）。
- **lending_collateral.move**: 仅超额抵押 150% 时借贷，无低抵押不变量。
- **oracle_safe.move**: 预言机价格新鲜度检查（时间戳过期 &gt; max_age 时中止）。
- **no_double_spend_transfer.move**: 无双花币转移（余额不足中止，发送余额-=金额，接收+=金额，总量守恒不变量）。
- **liquidation_safe.move**: 清算安全检查（仅低抵押&gt;120%时needs_liquidation，健康仓位清算中止）。
- **oracle_deviation_safe.move**: 预言机新鲜度+偏差检查（过期&gt;300s或偏差&gt;5%中止）。

### 故障排除
- Z3 路径问题: 验证 `z3 --version`
- Boogie .NET 错误: 安装 .NET SDK
- 规范失败: 查看 Sui Prover 文档
- 调试: Prover.toml auto_trace_level = &quot;AllCalls&quot;
