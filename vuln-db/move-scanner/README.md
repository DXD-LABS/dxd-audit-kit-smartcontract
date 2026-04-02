# MoveScanner 2026 Vulnerability Database

This directory contains 12 new vulnerability classes discovered by the **MoveScanner** research paper (arXiv, February 2026). The scanner analyzed >37k contracts on Sui and Aptos, identifying recurring patterns related to Move's resource-oriented model that were not covered in previous audit checklists.

## Vulnerability Index

| ID | Class | Severity | Description |
|---|---|---|---|
| MS-001 | Dynamic Field Resource Leak | High | Unremoved dynamic fields when parent objects are deleted/wrapped. |
| MS-002 | Dynamic Field Double-Spend | Critical | Re-attachment logic flaws allowing double-spending of wrapped value. |
| MS-003 | Cross-Module Permission Defect | High | Modules calling sibling modules without proper capability validation. |
| MS-004 | Capability Leak (Wrapping) | High | Internal capabilities accidentally exposed via public object wrapping. |
| MS-005 | Arithmetic Bitwise Edge Case | Medium | Flaws in bitwise manipulation leading to state corruption. |
| MS-006 | Custom Math Lib Edge Case | High | Rounding/precision errors in protocol-specific math libraries. |
| MS-007 | Parallel Race (Dependency) | High | Non-deterministic state in parallel execution due to hidden object deps. |
| MS-008 | Token Issuance Abuse | Critical | Ability misuse (`mint`/`burn`) leading to unauthorized supply changes. |
| MS-009 | Resource Leak (Missing Drop) | Medium | Structs without `drop` or `store` trapping resources in local scopes. |
| MS-010 | Phantom Type Bypass | High | Incorrect use of phantom types allowing cross-type asset substitution. |
| MS-011 | Freeze Object Misuse | Medium | Perma-locking shared objects via unintended `public_freeze_object`. |
| MS-012 | Entry Fun Over-exposure | Low | Internal logic exposed via `entry` functions without access guards. |

## Research Reference
- **Title:** "MoveScanner: Automated Vulnerability Detection in Resource-Oriented Smart Contracts"
- **Date:** Feb 2026
- **Findings:** Detects 20k+ unique vulnerabilities across Sui and Aptos ecosystems.

---
*Maintained by DXD Labs for the 2026 Move Security Standard.*
