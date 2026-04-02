# MoveScanner 2026 漏洞数据库 (中文)

## 简介
本目录包含了 **MoveScanner (2026年2月)** 研究报告中的最新安全发现。该项研究分析了 Sui 和 Aptos 上的 37,000 多个智能合约，发现了针对 Move 资源导向（Resource-oriented）模型的 12 类新型漏洞。

## 漏洞列表
| ID | 漏洞名称 | 严重程度 |
|----|----------|---------|
| [MS-001](ms_resource_leak_dynamic_field.yaml) | 动态字段（Dynamic Field）资源泄露 | 高 |
| [MS-002](ms_double_spend_dynamic_field.yaml) | 动态字段双重支付（Double-spending）| 严重 |
| [MS-003](ms_cross_module_permission_defect.yaml) | 跨模块权限缺陷 | 高 |
| [MS-004](ms_capability_leak_wrapping.yaml) | 对象包装（Object Wrapping）导致的权限泄露 | 高 |
| [MS-005](ms_arithmetic_bitwise_edge.yaml) | 位运算算术边缘错误 | 中 |
| [MS-006](ms_custom_math_lib_edge.yaml) | 自定义数学库边缘错误 | 高 |
| [MS-007](ms_parallel_race_object_dependency.yaml) | 跨对象依赖引发的并行执行竞争 | 高 |
| [MS-008](ms_token_issuance_ability_abuse.yaml) | 代币发行中的权能（Ability）滥用 | 严重 |
| [MS-009](ms_resource_leak_struct_drop.yaml) | 缺失 'drop' 权能导致的资源泄露 | 中 |
| [MS-010](ms_phantom_type_bypass.yaml) | 虚型（Phantom Type）安全绕过 | 高 |
| [MS-011](ms_freeze_object_misuse.yaml) | 冻结对象权限（Freeze Object）滥用 | 中 |
| [MS-012](ms_entry_fun_exposure.yaml) | Entry 函数暴露过度 | 高 |

## 使用说明
1. 阅读 YAML 文件以了解漏洞逻辑及修复方案。
2. 参考 `tests/sources/` 目录中的 PoC 进行实验。
3. 在根目录下运行 `python vuln-db/parser.py` 以更新汇总报告。
