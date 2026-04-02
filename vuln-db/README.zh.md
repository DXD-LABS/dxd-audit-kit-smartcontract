# Vuln DB (Sui/Move)

该目录用于存放 Move/Sui 真实漏洞的 YAML 记录，以及生成 summary 的解析器。

## 结构

### 目录
- [常用漏洞 (Common)](vulns/)
- [MoveScanner 2026 (新增)](move-scanner/)

### 汇总报告 (自动生成)
- [Summary (英语)](summary.md)
- [Summary (中文)](summary.zh.md)
- [Summary (越南语)](summary.vi.md)

- `parser.py` - 解析所有 YAML 并生成 `summary.md`。
- `requirements.txt` - 解析器所需的 Python 依赖。

## YAML 结构 (必填字段)

- `name`
- `date` (YYYY-MM-DD)
- `description`
- `impact`
- `severity`
- `references` (URL 列表)
- `code_vuln`
- `code_fixed`
- `test_vector`

可选字段:

- `cve_id`
- `affected_projects`
- `sui_testnet_tx`

## 新增漏洞

1. 在 `vulns/` 中创建新的 YAML 文件，使用 `snake_case` 命名。
2. 填写所有必填字段，描述保持简洁和技术化。
3. 运行解析器进行校验并生成 summary。

## 运行解析器

```bash
cd vuln-db
python parser.py
```

以上命令会生成 `vuln-db/summary.md`。