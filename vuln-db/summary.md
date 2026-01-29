# Sui Vuln Database Summary

## Integer Overflow in Liquidity Library
- Date: 2025-05-22
- Severity: Critical
- Impact: Critical - large scale fund loss and pool imbalance.

Incorrect shift bound check in a liquidity helper allowed oversized shifts to pass. Attackers used flash swaps to inject extreme liquidity and extract value.

## Oracle Manipulation via Stale Price
- Date: 2024-11-03
- Severity: High
- Impact: High - bad debt and insolvency risk.

A lending market accepted stale oracle prices without enforcing a freshness window, allowing flash loan price skew and under-collateralized borrowing.

## Seal/Decrypt Misuse Data Leak
- Date: 2024-09-02
- Severity: Medium
- Impact: Medium - privacy exposure.

Sensitive payloads were returned without proper sealing or with predictable keys, allowing unauthorized data recovery in AI apps.

## Package Upgrade Abort via Capability Mismatch
- Date: 2024-07-14
- Severity: Medium
- Impact: Medium - deployment failures and upgrade downtime.

Upgrade logic accepted mismatched capability versions, causing publish aborts or inconsistent upgrade state.

## HamsterWheel DoS Infinite Loop
- Date: 2023-06-19
- Severity: Critical
- Impact: Critical - validator halt and potential network disruption.

A malicious control flow graph can force the verifier into a non-terminating loop, stalling validation and causing a denial of service.
