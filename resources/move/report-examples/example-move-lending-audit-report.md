# Example Audit Report: Mini Lending Protocol on Sui (Move) | 示例审计报告：Sui (Move) 上的微型借贷协议

**Project**: MiniLend (demo lending protocol)  
**Auditor**: Louis @ DxDLabs  
**Date**: 17/01/2026  
**Scope**: lending.move, borrow.move, collateral.move  
**Tools**: Sui Move Analyzer, manual review, snippets from dxd-audit-kit-smartcontract

**Executive Summary** | **执行摘要**
Tổng 5 findings: 1 High (flash loan repay miss), 2 Medium (oracle staleness), 1 Low, 1 Informational. Protocol an toàn nếu fix High. | Total 5 findings: 1 High (flash loan repay miss), 2 Medium (oracle staleness), 1 Low, 1 Informational. Protocol is safe if High is fixed. | 总共 5 个发现：1 个高风险（闪电贷偿还遗漏）、2 个中风险（预言机数据过期）、1 个低风险、1 个提示性。如果修复高风险，协议是安全的。

**Detailed Findings** | **详细发现**

**Issue ID**: HIGH-01  
**Severity**: High | **严重程度**: 高
**Location**: lending.move:45  
**Description**: Flash loan không bắt buộc repay trong tx (hot potato leak). | **Description**: Flash loan does not enforce repayment within the transaction (hot potato leak). | **描述**：闪电贷未在交易内强制偿还（热土豆泄漏）。
**Impact**: Attacker borrow unlimited mà không trả → drain pool. | **Impact**: Attacker can borrow unlimited amounts without repayment → drains the pool. | **影响**：攻击者可以无限借款而不偿还 → 抽干资金池。
**Recommendation**: Bắt buộc destroy loan object trong repay function (xem flash-loan-hot-potato-safe.move). | **Recommendation**: Enforce destruction of the loan object in the repay function (see flash-loan-hot-potato-safe.move). | **建议**：在偿还函数中强制销毁借贷对象（参见 flash-loan-hot-potato-safe.move）。
**Status**: Open | **状态**: 开启

**Issue ID**: MEDIUM-02  
**Severity**: Medium | **严重程度**: 中
**Location**: borrow.move:120  
**Description**: Oracle price không check staleness. | **Description**: Oracle price does not check for staleness. | **描述**：预言机价格未检查过期性。
**Impact**: Attacker dùng giá cũ → borrow over-collateralized. | **Impact**: Attacker uses stale price → borrow over-collateralized assets. | **影响**：攻击者使用过期价格 → 借出超额抵押资产。
**Recommendation**: Thêm timestamp check (xem oracle-integration-safe.move). | **Recommendation**: Add timestamp check (see oracle-integration-safe.move). | **建议**：添加时间戳检查（参见 oracle-integration-safe.move）。
**Status**: Open | **状态**: 开启

**Recommendations** | **建议**
- Sử dụng capability pattern cho admin actions. | Use capability pattern for admin actions. | 为管理员操作使用权能模式 (Capability pattern)。
- Coverage test >90%. | Coverage test >90%. | 测试覆盖率 >90%。
- Tham khảo snippets trong repo này để fix nhanh. | Reference snippets in this repo for quick fixes. | 参考此仓库中的代码片段进行快速修复。
