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

## AGENT-005 Memory Poisoning Leading to Rogue Tx
- Date: 2025-12-05
- Loss: Simulated $1M in false contract approvals
- Severity: High
- Impact: High

Adversarial input poisons agent memory (LLM context window or external RAG DB), leading to harmful on-chain transactions like approving malicious contracts.

## AGENT-002 Rogue Agent Spend Limit Bypass
- Date: 2025-12-02
- Loss: Simulated $50k+ in test env
- Severity: High
- Impact: Medium to High

Agent bypasses its spend limit through multi-step workflows or memory poisoning. If an agent's tracked spending is stored off-chain or poorly managed on-chain, it can be reset or manipulated.

## AGENT-001 Unauthorized Tool Call via Prompt Injection
- Date: 2025-12-01
- Loss: Simulated $10k–$100k+ in test env
- Severity: High
- Impact: High (potential full wallet drain)

Attacker crafts adversarial prompt to make AI agent call unauthorized tool (e.g., transfer without user intent verification), bypassing guardrails.

## Nautilus TEE Attestation Bypass
- Date: 2026-03-06
- Loss: N/A (Theoretical — potential total fund loss)
- Severity: Critical
- Impact: Critical — complete compromise of TEE-attested computation integrity.

An on-chain smart contract accepted attested computation results without verifying the TEE attestation report. An attacker could fabricate a TEE quote or replay a stale attestation to submit fraudulent computation outputs on-chain, bypassing integrity guarantees. Missing checks include: attestation validity gate, freshness window (epoch-based), and report_data == committed_input_hash binding.

## zk-Intent Proof Replay (Missing Nullifier)
- Date: 2026-03-06
- Loss: N/A (High risk — dependent on TVL of protocol)
- Severity: High
- Impact: High — double-execution of intent, potential fund drain or state corruption.

A smart contract accepted the same zero-knowledge intent proof multiple times because the nullifier registry was not checked on-chain. This allowed an attacker to replay the same zk-proof across multiple transactions, executing the same intent action more than once. The root cause is the absence of a nullifier uniqueness check before allowing action execution. Each zk-proof must consume a unique nullifier that is recorded on-chain and rejected on second submission.

## AGENT-007 Verifiable Intent Failure
- Date: 2025-12-07
- Loss: Logic bypass mapping
- Severity: Medium
- Impact: Medium

An agent executes a transaction without on-chain verifiable intent proof (e.g., ZK Proof or Multi-Signature verification missing).

## AGENT-006 Shared Object Race in Multi-Agent Workflow
- Date: 2025-12-06
- Loss: Simulated extraction race conditions
- Severity: High
- Impact: High

Multiple agents accessing a shared object (e.g., treasury vault) sequentially without atomic operations exploit race conditions.

## AGENT-004 Intent Spoofing / Mismatch
- Date: 2025-12-04
- Loss: Simulated asset theft
- Severity: High
- Impact: High

Off-chain agent intent mismatches on-chain execution. The function does not verify the hash of the expected parameters.

## AGENT-003 Permission Abuse in Delegated Execution
- Date: 2025-12-03
- Loss: Simulated complete protocol takeover
- Severity: Critical
- Impact: Critical (Unauthorized admin access)

Agent misuses delegated capabilities (e.g., via kiosk or shared object) for unauthorized actions, performing administrative tasks instead of its scoped role.

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
