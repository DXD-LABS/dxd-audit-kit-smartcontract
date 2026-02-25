# Sui Vuln Database Summary

## Cetus Spoof Token + Liquidity Math Overflow
- Date: 2025-05-22
- Loss: $223M (largest Sui hack 2025)
- Severity: Critical
- Impact: Critical - Pools emptied, TVL crash, $60M bridged out, $162M frozen by validators.

Attacker deploys spoof tokens mimic legit → abuse flawed checked_shlw (shift limit 256 thay vì 192) → overflow in liquidity calc → mint huge LP with minimal deposit, drain pools (SUI/USDC etc.).

## Typus Oracle Authority Bypass
- Date: 2025-10-15
- Loss: $3.44M (SUI, USDC, xBTC, suiETH)
- Severity: Critical
- Impact: Critical - Direct pool drain via price manip, 3rd major Sui exploit 2025 (sau Cetus & Nemo).

Missing assert in custom oracle contract bypasses authorization checks → attacker calls update_v2 to set fake prices, manipulates TLP pools and drains funds. Unaudited oracle + lack of sender check.

## Nemo Economic Logic Exploit
- Date: 2025-09-08
- Loss: $2.4M USDC
- Severity: High
- Impact: High - Cross-chain drain, TVL drop mạnh, dù language prevent reentrancy/overflow.

Logic flaw in yield/bridge handling allows stolen funds bridged cross-chain (Arbitrum → Ethereum) before maintenance. Despite Move safety, protocol-level economic bug (yield split PT/YT abuse).

## Shared Object Race in Mysticeti Parallel Execution
- Date: 2025-06-01
- Loss: N/A (Risk post-upgrade)
- Severity: Medium
- Impact: Medium-High - Inconsistent state, DoS, hoặc value loss ở shared pools.

Missing version/sequence check in shared object updates → race condition khi parallel tx mutate cùng object (Mysticeti tăng speed → higher risk).

## Unaudited Custom Library Dependency Inheritance
- Date: 2025-01-01
- Loss: Multiple (Typus/Cetus-like)
- Severity: High
- Impact: High - Supply chain risk, common ở Sui DeFi dùng libs chưa audit.

Reliance on unaudited/open-source libs (math libs như integer-mate) inherits bugs (rounding/overflow) → exploits in caller contracts.

## Oracle Manipulation via Stale Price
- Date: 2024-11-03
- Loss: $0 (Theoretical)
- Severity: High
- Impact: High - bad debt and insolvency risk.

A lending market accepted stale oracle prices without enforcing a freshness window, allowing flash loan price skew and under-collateralized borrowing.

## Seal/Decrypt Misuse Data Leak
- Date: 2024-09-02
- Loss: $0 (Privacy Exposure)
- Severity: Medium
- Impact: Medium - privacy exposure.

Sensitive payloads were returned without proper sealing or with predictable keys, allowing unauthorized data recovery in AI apps.

## Package Upgrade Abort via Capability Mismatch
- Date: 2024-07-14
- Loss: $0 (Protocol Lock)
- Severity: Medium
- Impact: Medium - deployment failures and upgrade downtime.

Upgrade logic accepted mismatched capability versions, causing publish aborts or inconsistent upgrade state.

## HamsterWheel DoS Infinite Loop
- Date: 2023-06-19
- Loss: $0 (Network Halt)
- Severity: Critical
- Impact: Critical - validator halt and potential network disruption.

A malicious control flow graph can force the verifier into a non-terminating loop, stalling validation and causing a denial of service.
