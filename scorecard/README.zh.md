# DXD Labs 安全记分牌工具

基于 BVSS（区块链漏洞评分系统）标准的漏洞严重性评估工具。

## 📁 目录结构
- `core/`：共享评分逻辑。
- `parsers/`：从 vuln-db（YAML）和检查清单（MD）读取数据的模块。
- `web/`：交互式仪表板界面（HTML/JS）。
- `templates/`：报告模板（Jinja2）。
- `scorecard_config.json`：权重单一真相源配置文件。

## 🚀 使用指南

### 选项 1：CLI 工具 (Python)
供审计员快速评分并导出报告到审计报告。

**从 vuln-db 为单个漏洞评分：**
```bash
python scorecard/cli.py --vuln-id cetus_overflow
```

**覆盖风险参数：**
```bash
python scorecard/cli.py --vuln-id cetus_overflow --likelihood High --maturity Active
```

**从检查清单导出报告：**
```bash
python scorecard/cli.py --checklist path/to/checklist.md --output html
```

**为 Web 同步数据：**
```bash
python scorecard/cli.py --export-web
```

### 选项 2：Web 仪表板 (GitHub Pages)
用于演示或客户直接交互。

1. 确保已运行上述 `--export-web` 命令。
2. 在浏览器中打开 `scorecard/web/index.html`。
3. 选择漏洞或手动输入 Impact/Likelihood 参数。

## 📊 评分算法 (BVSS)
评分基于：
- **Impact (60%)**：财务/系统影响水平。
- **Likelihood (40%)**：攻击发生概率。
- **Immutability Multiplier (1.5x)**：区块链不可变特性。
- **Exploit Maturity**：利用代码状态（Theoretical, POC, Active）。
- **Privileged Access**：特殊访问要求。

## 🚀 高级用法 & CI/CD 集成

**集成静态分析 (从 lint.json)：**
```bash
python scorecard/cli.py --lint-output lint.json --output html  # 生成 scorecard_report.html
```

**完整 BVSS 参数覆盖：**
```bash
python scorecard/cli.py --vuln-id cetus_overflow \\
  --impact Critical --likelihood High \\
  --exploitability Network --scope Changed --economic-loss Billions \\
  --maturity Active --output markdown
```

**CI/CD (.github/workflows/static-analysis.yaml)：**
- 自动运行 `analyze.py --json > lint.json` → scorecard → 上传 `scorecard-report` 工件。

## 📈 示例结果
```
# cetus_overflow 的结果
- Impact: Critical
- Likelihood: High  
- Score: 9.8/10
- Severity: 🔴 Critical
```

**自定义配置：** 编辑 `scorecard_config.json`（权重、乘数）。

---
*由 DXD Labs 开发。*
