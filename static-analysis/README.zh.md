# Move Static Analysis (中文)

此文件夹为 Sui Move 提供了一个轻量级的静态分析流水线。

## 快速开始

- 安装依赖：
  - Rust 工具链（用于 `move-lint`）
  - Sui CLI（用于 `sui move disassemble`）
  - Python 3.10+

- Python 依赖：
  - `pip install -r static-analysis/requirements.txt`

- 在单个文件上运行：
  - `python static-analysis/scripts/analyze.py path/to/module.move`

- 在目录（包）上运行：
  - `python static-analysis/scripts/analyze.py path/to/package`

- 字节码扫描（需要可构建的 Sui 包路径）：
  - `python static-analysis/scripts/parse_bytecode.py path/to/package`

## 自定义规则

规则位于 `static-analysis/rules/sui_vuln_rules.yaml`。
每条规则包含：
- `name`（名称）、`description`（描述）、`pattern`（正则模式）、`severity`（严重程度）

分析器会标记匹配项，如果发现 `high` 或 `critical` 级别的漏洞，将以非零状态码退出。

## 可选的 Rust 扩展

`static-analysis/Cargo.toml` 是一个使用 Rust 扩展 Move Lint 的脚手架。
默认流水线使用 Python 以提高迭代速度。
