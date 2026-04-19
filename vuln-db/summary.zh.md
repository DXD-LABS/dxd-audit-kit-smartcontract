# Sui 漏洞库摘要 (Move)

| ID | Name | 评分 | 严重程度 | Proof | Date |
| :--- | :--- | :---: | :--- | :---: | :--- |
| DXD-SUI-2025-002 | AGENT-004 Intent Spoofing / Mismatch | **6.5** | 🟡 High | [🔍 agent_intent_verification.move](../prover-examples/sources/agent_intent_verification.move) | 2025-12-04 |
| DXD-SUI-2024-006 | Seal Misuse in Hot Potato Pattern | **6.5** | 🟡 Medium | [🔍 agent_owned_receipt.move](../prover-examples/sources/agent_owned_receipt.move) | 2024-09-02 |
| DXD-SUI-2025-016 | AGENT-013 Side-Channel Data Leak in Privacy-Protected Agent Memory | **6.0** | 🟡 Critical | ⏳ | 2026-03-07 |
| DXD-SUI-2025-021 | AGENT-008 Privacy Leak via Unverified ZK-Intent in Agent Execution | **6.0** | 🟡 Critical | [🔍 agent_zk_intent_privacy.move](../prover-examples/sources/agent_zk_intent_privacy.move) | 2026-03-07 |
| DXD-SUI-2025-023 | Nautilus TEE Attestation Bypass | **6.0** | 🟡 Critical | [🔍 nautilus_tee_attest.move](../prover-examples/sources/nautilus_tee_attest.move) | 2026-03-06 |
| DXD-MS-2026-002 | MS-004 包装对象导致的权限（Capability）泄露 | **6.0** | 🟡 Critical | ⏳ | 2026-02-15 |
| DXD-MS-2026-005 | MS-002 动态字段双花漏洞 | **6.0** | 🟡 Critical | ⏳ | 2026-02-15 |
| DXD-MS-2026-013 | MS-008 代币发行中的权能（Ability）滥用漏洞 | **6.0** | 🟡 Critical | ⏳ | 2026-02-15 |
| DXD-SUI-2025-001 | AGENT-003 Permission Abuse in Delegated Execution | **6.0** | 🟡 Critical | [🔍 agent_policy_guard.move](../prover-examples/sources/agent_policy_guard.move) | 2025-12-03 |
| DXD-SUI-2025-027 | Typus Oracle Authority Bypass | **6.0** | 🟡 Critical | ⏳ | 2025-10-15 |
| DXD-SUI-2025-022 | Cetus Spoof Token + Liquidity Math Overflow | **6.0** | 🟡 Critical | ⏳ | 2025-05-22 |
| DXD-SUI-2024-003 | Fake Token Input Spoofing (General) | **6.0** | 🟡 High | ⏳ | 2024-12-01 |
| DXD-SUI-2024-002 | Vault Share Math Logic Error (Souffl3) | **6.0** | 🟡 Medium | [🔍 no_double_spend.move](../prover-examples/sources/no_double_spend.move) | 2024-11-20 |
| DXD-SUI-2024-001 | Shared Object Access Control Bypass (BlueMove) | **6.0** | 🟡 High | [🔍 safe_transfer.move](../prover-examples/sources/safe_transfer.move) | 2024-11-05 |
| DXD-SUI-2026-001 | AGENT-012 BTCfi Oracle Manipulation in Agent-Driven Trades | **5.5** | 🟡 High | [🔍 agent_btcfi_oracle_bounds.move](../prover-examples/sources/agent_btcfi_oracle_bounds.move) | 2026-03-07 |
| DXD-SUI-2025-011 | AGENT-011 NFT/Kiosk Bypass in Agent-Controlled Assets | **5.5** | 🟡 High | ⏳ | 2026-03-07 |
| DXD-SUI-2025-013 | AGENT-010 Multi-Agent Consensus Failure via Byzantine Rogue Agent | **5.5** | 🟡 High | ⏳ | 2026-03-07 |
| DXD-SUI-2025-018 | AGENT-009 TEE Tampering in Nautilus-Attested Agent Compute | **5.5** | 🟡 High | ⏳ | 2026-03-07 |
| DXD-SUI-2025-019 | AGENT-014 Unaudited Lib Dependency in Agent Modules | **5.5** | 🟡 High | ⏳ | 2026-03-07 |
| DXD-SUI-2025-030 | zk-Intent Proof Replay (Missing Nullifier) | **5.5** | 🟡 High | ⏳ | 2026-03-06 |
| DXD-MS-2026-003 | MS-003 跨模块权限缺陷 | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-004 | MS-006 自定义数学库边缘案例 | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-006 | MS-012 Entry 函数暴露过度漏洞 | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-008 | MS-007 跨对象依赖引发的并行执行竞争漏洞 | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-009 | MS-010 虚型（Phantom Type）安全绕过漏洞 | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-010 | MS-001 动态字段资源泄露漏洞 | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-SUI-2025-015 | AGENT-006 Shared Object Race in Multi-Agent Workflow | **5.5** | 🟡 High | ⏳ | 2025-12-06 |
| DXD-SUI-2025-012 | AGENT-005 Memory Poisoning Leading to Rogue Tx | **5.5** | 🟡 High | ⏳ | 2025-12-05 |
| DXD-SUI-2025-017 | AGENT-002 Rogue Agent Spend Limit Bypass | **5.5** | 🟡 High | [🔍 agent_spend_limit_enforce.move](../prover-examples/sources/agent_spend_limit_enforce.move) | 2025-12-02 |
| DXD-SUI-2025-020 | AGENT-001 Unauthorized Tool Call via Prompt Injection | **5.5** | 🟡 High | [🔍 agent_unauthorized_tool_prevent.move](../prover-examples/sources/agent_unauthorized_tool_prevent.move) | 2025-12-01 |
| DXD-SUI-2025-024 | Nemo Economic Logic Exploit | **5.5** | 🟡 High | ⏳ | 2025-09-08 |
| DXD-SUI-2025-028 | Unaudited Custom Library Dependency Inheritance | **5.5** | 🟡 High | ⏳ | 2025-01-01 |
| DXD-SUI-2024-005 | Upgradable Package State Corruption (Migration) | **5.5** | 🟡 High | ⏳ | 2024-12-30 |
| DXD-SUI-2024-004 | Dynamic Field Name Collision/Overwrite (Typus) | **5.5** | 🟡 High | [🔍 no_double_spend_transfer.move](../prover-examples/sources/no_double_spend_transfer.move) | 2024-12-15 |
| DXD-SUI-2025-025 | Oracle Manipulation via Stale Price | **5.5** | 🟡 High | ⏳ | 2024-11-03 |
| DXD-MS-2026-001 | MS-005 算术位运算（Bitwise）边缘案例 | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-MS-2026-007 | MS-011 冻结对象权限（Freeze Object）滥用漏洞 | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-MS-2026-011 | MS-009 缺失 'drop' 权能导致的资源泄露 | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-MS-2026-012 | MS-009 Resource Leak (Missing Drop) | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-SUI-2025-014 | AGENT-007 Verifiable Intent Failure | **4.5** | 🟡 Medium | ⏳ | 2025-12-07 |
| DXD-SUI-2025-026 | Shared Object Race in Mysticeti Parallel Execution | **4.5** | 🟡 Medium | ⏳ | 2025-06-01 |
| DXD-SUI-2025-029 | Package Upgrade Abort via Capability Mismatch | **4.5** | 🟡 Medium | ⏳ | 2024-07-14 |
| DXD-SUI-2023-001 | HamsterWheel DoS Infinite Loop | **4.5** | 🟡 Critical | [🔍 agent_shared_object_consistency.move](../prover-examples/sources/agent_shared_object_consistency.move) | 2023-06-19 |

---

## [DXD-SUI-2025-002] AGENT-004 Intent Spoofing / Mismatch
- Score: **6.5/10** 🟡
- **Formal Proof**: [`agent_intent_verification.move`](../prover-examples/sources/agent_intent_verification.move)
- Date: 2025-12-04
- Loss: Simulated asset theft
- Impact: High

- **根本原因**: Cryptographic Mismatch between Intent and Execution. The off-chain AI agent signs  an 'Intent', but the on-chain execution function accepts individual parameters  without verifying they match the signed intent hash.

- **缓解措施**: Hash all function parameters into an Intent struct on-chain and verify it  against the agent's signature.

- **验证**: Cryptographic Audit: Ensure that every parameter used in state-changing logic  is included in the signature payload.


Off-chain agent intent mismatches on-chain execution. The function does not  verify the hash of the expected parameters.

## [DXD-SUI-2024-006] Seal Misuse in Hot Potato Pattern
- Score: **6.5/10** 🟡
- **Formal Proof**: [`agent_owned_receipt.move`](../prover-examples/sources/agent_owned_receipt.move)
- Date: 2024-09-02
- Loss: $0 (Privacy Exposure)
- Impact: Medium - privacy exposure.
- **根本原因**: Failure to verify the PackageID associated with a Seal object or allowing 'Hot Potato'  objects to be 'dropped' without returning them to their destination.

- **缓解措施**: Use 'Hot Potato' patterns (structs without drop or store abilities) correctly  to enforce control flow within a single transaction.

- **验证**: Static Analysis: Check for structs without abilities that are passed as parameters  but not consumed or returned as intended.


Sensitive payloads were returned without proper sealing or with predictable keys, allowing unauthorized data recovery in AI apps.

## [DXD-SUI-2025-016] AGENT-013 Side-Channel Data Leak in Privacy-Protected Agent Memory
- Score: **6.0/10** 🟡
- Date: 2026-03-07
- Loss: Simulated (privacy breach $500k+ class-action equivalent)
- Impact: Critical (user data exposure, regulatory liability in private agents)

An agent stores per-user memory (intent state, balances) using variable-size data structures. Even when guarded by zk/TEE wrappers, the on-chain gas consumption or dynamic field size varies based on secret data, creating a timing/size side-channel. An observer monitoring transaction gas or object byte growth can infer the contents of private agent memory (wallet balances, intent payload length, number of recent actions). Root cause: memory block size grows proportionally to sensitive data rather than being padded to a fixed constant-size block.

## [DXD-SUI-2025-021] AGENT-008 Privacy Leak via Unverified ZK-Intent in Agent Execution
- Score: **6.0/10** 🟡
- **Formal Proof**: [`agent_zk_intent_privacy.move`](../prover-examples/sources/agent_zk_intent_privacy.move)
- Date: 2026-03-07
- Loss: Simulated ($100k+ in privacy-compromised assets)
- Impact: Critical (data exfil, user privacy breach in agentic economy)

An agent executes a transaction based on a zk-proof intent but does not fully verify the proof fields, allowing sensitive data (user wallet state, off-chain memory, intent payload) to be exposed via on-chain dynamic fields or side-channels. The root cause is accepting a ZkIntentProof without asserting that no sensitive data is exposed through proof.public_inputs or leaked dynamic field writes. An attacker who can observe on-chain object state can extract the user's intent or balance information.

## [DXD-SUI-2025-023] Nautilus TEE Attestation Bypass
- Score: **6.0/10** 🟡
- **Formal Proof**: [`nautilus_tee_attest.move`](../prover-examples/sources/nautilus_tee_attest.move)
- Date: 2026-03-06
- Loss: N/A (Theoretical — potential total fund loss)
- Impact: Critical — complete compromise of TEE-attested computation integrity.

An on-chain smart contract accepted attested computation results without verifying the TEE attestation report. An attacker could fabricate a TEE quote or replay a stale attestation to submit fraudulent computation outputs on-chain, bypassing integrity guarantees. Missing checks include: attestation validity gate, freshness window (epoch-based), and report_data == committed_input_hash binding.

## [DXD-MS-2026-002] MS-004 包装对象导致的权限（Capability）泄露
- Score: **6.0/10** 🟡
- Date: 2026-02-15
- Loss: Privilege Escalation
- Impact: 严重 (如果管理私钥泄露，整个协议将被接管)

敏感的权限（例如 AdminCap）被包装在另一个对象内部。如果该容器对象是公共或共享的， 且提取逻辑存在漏洞，攻击者则可能提取该权限并执行仅限协议所有者使用的管理操作。

## [DXD-MS-2026-005] MS-002 动态字段双花漏洞
- Score: **6.0/10** 🟡
- Date: 2026-02-15
- Loss: Asset Overwrite/Duplication
- Impact: 严重 (资产被非法替换或核心逻辑被绕过)

在管理动态字段时，由于重用唯一键来绑定新资源，而未核实旧资源是否已被消耗，导致逻辑缺陷。 在 Sui 中，将相同名称重新绑定到动态字段会覆盖其值，但如果旧值是 'Balance' 或 'Coin'， 则可能导致状态不一致或资金损失。

## [DXD-MS-2026-013] MS-008 代币发行中的权能（Ability）滥用漏洞
- Score: **6.0/10** 🟡
- Date: 2026-02-15
- Loss: Hyper-inflation/Token Theft
- Impact: 严重 (导致代币价值完全归零并失去对供应量的控制)

Move 的权能系统（`store`、`drop`、`copy`、`key`）用于管理资源安全。如果代币 模块错误地将 `copy` 或 `store` 权能分配给 `TreasuryCap` 或敏感的 Witness 结构体， 攻击者可能会复制或转移“铸币权”，从而导致非法代币发行。

## [DXD-SUI-2025-001] AGENT-003 Permission Abuse in Delegated Execution
- Score: **6.0/10** 🟡
- **Formal Proof**: [`agent_policy_guard.move`](../prover-examples/sources/agent_policy_guard.move)
- Date: 2025-12-03
- Loss: Simulated complete protocol takeover
- Impact: Critical (Unauthorized admin access)

- **根本原因**: Over-privileged Capabilities. The vulnerability occurs when a capability intended  for a low-value task is used for a high-value task due to a lack of granular  scoping in the smart contract's authorization logic.

- **缓解措施**: Implement Scoped Capabilities or Intent-based verification where the capability  only allows execution of a specific function or with specific object IDs.

- **验证**: Integration Tests: Attempt to perform an unauthorized action using a restricted  agent capability and verify it aborts.


Agent misuses delegated capabilities (e.g., via kiosk or shared object) for unauthorized  actions, performing administrative tasks instead of its scoped role.

## [DXD-SUI-2025-027] Typus Oracle Authority Bypass
- Score: **6.0/10** 🟡
- Date: 2025-10-15
- Loss: $3.44M (SUI, USDC, xBTC, suiETH)
- Impact: Critical - Direct pool drain via price manip, 3rd major Sui exploit 2025 (sau Cetus & Nemo).

Missing assert in custom oracle contract bypasses authorization checks → attacker calls update_v2 to set fake prices, manipulates TLP pools and drains funds. Unaudited oracle + lack of sender check.

## [DXD-SUI-2025-022] Cetus Spoof Token + Liquidity Math Overflow
- Score: **6.0/10** 🟡
- Date: 2025-05-22
- Loss: $223M (largest Sui hack 2025)
- Impact: Critical - Pools emptied, TVL crash, $60M bridged out, $162M frozen by validators.

Attacker deploys spoof tokens mimic legit → abuse flawed checked_shlw (shift limit 256 thay vì 192) → overflow in liquidity calc → mint huge LP with minimal deposit, drain pools (SUI/USDC etc.).

## [DXD-SUI-2024-003] Fake Token Input Spoofing (General)
- Score: **6.0/10** 🟡
- Date: 2024-12-01
- Loss: Variable
- Impact: High - Draining of liquidity pools, protocol insolvency.
- **根本原因**: Over-reliance on Generics without Type Constraint Validation. Developers coming from  Account-based models often forget that in Move, any user can define a type `T`.  A function `swap<T>` is a 'permissionless entry' unless `T` is strictly compared  against a set of trusted `TypeTag`s or `TypeName`s on-chain.

- **缓解措施**: 1. Use `sui::type_name::get<T>()` to compare against a registry of allowed types.  2. Use the 'Witness' pattern where users must provide an object that can only be  created by the legitimate token issuer.

- **验证**: Manual Audit: Check all functions accepting generic `Coin<T>` and trace if `T` is  validated against a configuration object or hardcoded whitelist.


A protocol function accepts a generic token type `Coin<T>` or a specific struct `TreasuryCap<T>`  without verifying that `T` matches the platform's whitelist. An attacker can deploy a  malicious module with a token named similarly (e.g., "SUI") and use it to interact with  swap or lending pools, effectively "stealing" real assets by providing worthless fake tokens.

## [DXD-SUI-2024-002] Vault Share Math Logic Error (Souffl3)
- Score: **6.0/10** 🟡
- **Formal Proof**: [`no_double_spend.move`](../prover-examples/sources/no_double_spend.move)
- Date: 2024-11-20
- Loss: $50k+ (Restricted)
- Impact: Medium - Slow drain of vault funds over time via micro-transactions.
- **根本原因**: Legacy Solidity-style math in Move without accounting for directional rounding. In DeFi,  rounding should always favor the protocol (round down for user receipts, round up for user payments).  Failure to use a 'round_up' flag or a safe math library for shares led to precision loss leakage.

- **缓解措施**: Implement a helper function for proportional math that accepts a `round_up` boolean. Always use  u128 for intermediate multiplications before division to prevent overflow.

- **验证**: Unit Tests: Mock a vault with low liquidity and high share price, then verify that micro-deposits  cannot result in effectively free shares.


Incorrect rounding in share calculation logic. When calculating the amount of assets per share,  the contract rounded down for withdrawals or up for deposits in a way that favored the user,  allowing "dust" attacks where a user could repeatedly deposit and withdraw small amounts  to slowly drain the vault's underlying assets.

## [DXD-SUI-2024-001] Shared Object Access Control Bypass (BlueMove)
- Score: **6.0/10** 🟡
- **Formal Proof**: [`safe_transfer.move`](../prover-examples/sources/safe_transfer.move)
- Date: 2024-11-05
- Loss: $250k+ (Restricted)
- Impact: High - Unauthorized fund withdrawal, total loss of shared object state authority.
- **根本原因**: Fundamental misunderstanding of Sui Object Ownership. The developer assumed that because an object  is 'Shared', it still implicitly respects permissions, whereas Shared Objects are publicly  accessible and require explicit 'Capability-based' or 'Address-based' access control within  the function logic.

- **缓解措施**: Always require an `&AdminCap` or `&OwnerCap` as a parameter. Use standard patterns from  `secure-patterns/sources/access_control.move`.

- **验证**: Formal Verification: `sui move prove` with 'aborts_if' specs to ensure functions without  valid capabilities always fail.


The contract uses a Shared Object but fails to verify the caller's identity or the presence of an  admin capability within the function. Any user can call the `take()` or `withdraw()` function  on the shared object, draining its resources. In the BlueMove case, the lack of `OwnerCap`  validation in the DEX allowed unauthorized liquidity removal.

## [DXD-SUI-2026-001] AGENT-012 BTCfi Oracle Manipulation in Agent-Driven Trades
- Score: **5.5/10** 🟡
- **Formal Proof**: [`agent_btcfi_oracle_bounds.move`](../prover-examples/sources/agent_btcfi_oracle_bounds.move)
- Date: 2026-03-07
- Loss: Simulated (oracle skew leading to $150k+ bad debt)
- Impact: High (protocol bad debt, user fund loss, fits Sui BTCfi expansion 2026)
- **根本原因**: Oracle Dependency Anti-pattern. The core issue is the 'Single Source of Truth' without  on-chain validation. In the context of Agentic DeFi (2026), AI agents often react faster  than human guardians, making oracle-skew vulnerabilities catastrophic if not guarded  by multi-feed consensus or TWAP checks.

- **缓解措施**: 1. Implement Multi-Oracle Aggregation (e.g., Pyth + Switchboard + Supra).  2. Add Heartbeat checks (staleness protection). 3. Implement Maximum Deviation Thresholds.

- **验证**: Simulation: Run an adversarial agent that pumps a low-liquidity oracle feed while  simultaneously triggering the liquidation function.


An agent relies on a single BTCfi oracle feed (e.g., BTC/SUI price) for liquidation or collateral valuation decisions. An attacker manipulates the off-chain oracle price feed (e.g., via TWAP manipulation, stale data replay, or poisoning the oracle provider) causing the agent to execute a liquidation at a significantly skewed price. The on-chain contract accepts the oracle value without deviation bounds or multi-feed aggregation, creating bad debt or enabling the attacker to front-run liquidations at incorrect valuations.

## [DXD-SUI-2025-011] AGENT-011 NFT/Kiosk Bypass in Agent-Controlled Assets
- Score: **5.5/10** 🟡
- Date: 2026-03-07
- Loss: Simulated ($10k+ in kiosk-locked NFT assets)
- Impact: Medium-High (NFT drain in agentic gaming, RWA, and digital asset protocols)

An agent that receives a KioskOwnerCap for a scoped workflow can bypass NFT ownership checks by performing an unauthorized transfer via the kiosk API without verifying the receiver matches the expected owner. Sui's Kiosk model enforces purchase/transfer policies, but an agent holding the cap and executing a custom bypass path (e.g., via dynamic fields or unlocked place/take cycles) can extract NFTs from the kiosk without completing a legitimate sale. Root cause: missing assert that kiosk owner == permitted agent address and that transfer policy rules are enforced before item extraction.

## [DXD-SUI-2025-013] AGENT-010 Multi-Agent Consensus Failure via Byzantine Rogue Agent
- Score: **5.5/10** 🟡
- Date: 2026-03-07
- Loss: Simulated (multi-agent drain $200k+)
- Impact: High (ecosystem-wide if agent swarms control large treasuries)

In a multi-agent workflow, a rogue (Byzantine) agent injects faulty votes or approvals into a shared consensus object without signature verification. The contract tallies unverified votes and grants approval even when the cryptographically-verified threshold is not met. This allows the rogue agent to trigger a shared vault drain, unauthorized treasury sweep, or intent execution below quorum. Root cause: the vote counter accepts any caller's vote without verifying an agent signature or membership proof.

## [DXD-SUI-2025-018] AGENT-009 TEE Tampering in Nautilus-Attested Agent Compute
- Score: **5.5/10** 🟡
- Date: 2026-03-07
- Loss: Simulated (TEE breach leading to $50k+ rogue tx)
- Impact: High (cascading failures in verifiable agents, rogue on-chain tx)

An adversary tampers with a Nautilus TEE enclave via side-channel or weak attestation (e.g., replaying a stale attestation report, injecting a fabricated quote). The on-chain contract then accepts rogue off-chain compute outputs — altered AI inference results — triggering unauthorized transfers or intent spoofing. Missing checks include: attestation validity gate, freshness window (epoch-based), and report_data == input_hash binding. This extends the existing nautilus_tee_bypass.yaml with an active tampering vector (not just bypass) and a quantified PoC.

## [DXD-SUI-2025-019] AGENT-014 Unaudited Lib Dependency in Agent Modules
- Score: **5.5/10** 🟡
- Date: 2026-03-07
- Loss: Simulated ($300k+ via lib vuln cascade)
- Impact: High (systemic if lib popular in agentic economy; full admin takeover)

An agent module imports a third-party Move library (e.g., a zk helper or TEE SDK) that has not been audited and contains a backdoor: a public init function that mints an AdminCap accessible to any caller. On deployment or first use, an attacker calls the backdoor to extract the AdminCap and gain full admin control over the agent module (drain treasury, upgrade packages, modify agent policies). Root cause: no verification that imported library packages are from audited, trusted sources before integration into the agent.

## [DXD-SUI-2025-030] zk-Intent Proof Replay (Missing Nullifier)
- Score: **5.5/10** 🟡
- Date: 2026-03-06
- Loss: N/A (High risk — dependent on TVL of protocol)
- Impact: High — double-execution of intent, potential fund drain or state corruption.

A smart contract accepted the same zero-knowledge intent proof multiple times because the nullifier registry was not checked on-chain. This allowed an attacker to replay the same zk-proof across multiple transactions, executing the same intent action more than once. The root cause is the absence of a nullifier uniqueness check before allowing action execution. Each zk-proof must consume a unique nullifier that is recorded on-chain and rejected on second submission.

## [DXD-MS-2026-003] MS-003 跨模块权限缺陷
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Unauthorized Administrative Action
- Impact: 高 (在不同协议模块间发生非法状态修改)

当多个模块（例如协议核心与外围模块）交互时，一个模块可能会信任另一个模块的公共函数， 而未核查特定的调用者身份或权限（Capability）。过度使用 'friend' 函数会加剧此风险， 因为它允许任何 'friend' 模块执行敏感操作。

## [DXD-MS-2026-004] MS-006 自定义数学库边缘案例
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Economic Extraction/DeFi Loss
- Impact: 高 (DEX/借贷池随时间推移而发生的财务损失)

许多协议使用自定义的定点数学库（例如利率、联合曲线）。这些库在幂/对数函数或精度舍入方面 可能存在边缘案例，攻击者可以利用这些漏洞获取微小但持续累积的财务利益。

## [DXD-MS-2026-006] MS-012 Entry 函数暴露过度漏洞
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Privilege Escalation/State Corruption
- Impact: 高 (引发非法的管理状态修改)

管理类或关键的初始化函数被标记为 `entry` 后，若没有进行严谨的 `TxContext`  发送者校验，将会导致漏洞。这使得任何用户都可以直接从一个交易中调用这些函数， 并可能重新初始化对象状态或获取未授权的访问权限。

## [DXD-MS-2026-008] MS-007 跨对象依赖引发的并行执行竞争漏洞
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Inconsistent Protocol State
- Impact: 高 (在高负载下可能导致非法状态或发生经济榨取)

Sui 的高速并行执行机制（Mysticeti）假设对不同对象进行的操作可以并发运行。如果 一个交易依赖于多个对象，且由于执行顺序不可预测而产生竞态条件（即一个对象的状态 以非预期的方式影响另一个对象的逻辑），则可能导致安全不变性被违反。

## [DXD-MS-2026-009] MS-010 虚型（Phantom Type）安全绕过漏洞
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Asset Substitution/Pool Theft
- Impact: 高 (在 DeFi 资金池中发生非法的资产提取)

Move 泛型中的 `phantom` 关键字标记了不出于内部存储目的、但定义权限的类型。 如果忽略该关键字，Move 编译器可能会在复杂的层级结构中允许不合理的类型替换， 从而使攻击者能够在泛型保管库（Vault）或资金池中将一种代币类型替换为另一种。

## [DXD-MS-2026-010] MS-001 动态字段资源泄露漏洞
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Locked Objects (Unrecoverable storage)
- Impact: 高 (引发特定用户的永久资金损失、链上存储膨胀)

当父级对象被删除或其所有权被包装（wrapped）时，其动态字段（DF）或动态对象字段（DOF） 不会自动清除。这些字段在区块链上变为“孤儿”状态，永久锁定其包含的资产或数据。 MoveScanner 发现这在可升级合约中很常见，旧对象被弃用但相关字段未迁移。

## [DXD-SUI-2025-015] AGENT-006 Shared Object Race in Multi-Agent Workflow
- Score: **5.5/10** 🟡
- Date: 2025-12-06
- Loss: Simulated extraction race conditions
- Impact: High

Multiple agents accessing a shared object (e.g., treasury vault) sequentially without atomic operations exploit race conditions.

## [DXD-SUI-2025-012] AGENT-005 Memory Poisoning Leading to Rogue Tx
- Score: **5.5/10** 🟡
- Date: 2025-12-05
- Loss: Simulated $1M in false contract approvals
- Impact: High

Adversarial input poisons agent memory (LLM context window or external RAG DB), leading to harmful on-chain transactions like approving malicious contracts.

## [DXD-SUI-2025-017] AGENT-002 Rogue Agent Spend Limit Bypass
- Score: **5.5/10** 🟡
- **Formal Proof**: [`agent_spend_limit_enforce.move`](../prover-examples/sources/agent_spend_limit_enforce.move)
- Date: 2025-12-02
- Loss: Simulated $50k+ in test env
- Impact: Medium to High

Agent bypasses its spend limit through multi-step workflows or memory poisoning. If an agent's tracked spending is stored off-chain or poorly managed on-chain, it can be reset or manipulated.

## [DXD-SUI-2025-020] AGENT-001 Unauthorized Tool Call via Prompt Injection
- Score: **5.5/10** 🟡
- **Formal Proof**: [`agent_unauthorized_tool_prevent.move`](../prover-examples/sources/agent_unauthorized_tool_prevent.move)
- Date: 2025-12-01
- Loss: Simulated $10k–$100k+ in test env
- Impact: High (potential full wallet drain)

Attacker crafts adversarial prompt to make AI agent call unauthorized tool (e.g., transfer without user intent verification), bypassing guardrails.

## [DXD-SUI-2025-024] Nemo Economic Logic Exploit
- Score: **5.5/10** 🟡
- Date: 2025-09-08
- Loss: $2.4M USDC
- Impact: High - Cross-chain drain, TVL drop mạnh, dù language prevent reentrancy/overflow.

Logic flaw in yield/bridge handling allows stolen funds bridged cross-chain (Arbitrum → Ethereum) before maintenance. Despite Move safety, protocol-level economic bug (yield split PT/YT abuse).

## [DXD-SUI-2025-028] Unaudited Custom Library Dependency Inheritance
- Score: **5.5/10** 🟡
- Date: 2025-01-01
- Loss: Multiple (Typus/Cetus-like)
- Impact: High - Supply chain risk, common ở Sui DeFi dùng libs chưa audit.

Reliance on unaudited/open-source libs (math libs như integer-mate) inherits bugs (rounding/overflow) → exploits in caller contracts.

## [DXD-SUI-2024-005] Upgradable Package State Corruption (Migration)
- Score: **5.5/10** 🟡
- Date: 2024-12-30
- Loss: Variable
- Impact: High - Irreversible state corruption, potential protocol takeover.
- **根本原因**: Lack of access control on the 'Administrative Bridge' (migration function). In Sui,  upgrades change the package ID, but not the Shared Object ID. The common pitfall is  forgetting that even if the new package is 'safe', the bridge function to transition  old data to new logic is a major attack vector if left public.

- **缓解措施**: 1. Always protect `migrate` functions with `&UpgradeCap`.  2. Implement a 'Version Guard' inside the object to ensure migration only runs once  for each version jump.

- **验证**: Manual Audit: Search for any public functions named `migrate` or `init_version` and ensure  they take a restrictively owned Capability.


Protocol implements an upgrade mechanism with a `migrate` function to update shared  object states after a package upgrade. If the `migrate` function is not properly  protected by checking for the `UpgradeCap` or a specific version-bound admin  capability, any user can trigger the migration prematurely or multiple times,  leading to state corruption, data loss, or unauthorized privilege escalation.

## [DXD-SUI-2024-004] Dynamic Field Name Collision/Overwrite (Typus)
- Score: **5.5/10** 🟡
- **Formal Proof**: [`no_double_spend_transfer.move`](../prover-examples/sources/no_double_spend_transfer.move)
- Date: 2024-12-15
- Loss: $N/A (Prevented/Found in Audit)
- Impact: High - State corruption, potential unauthorized access to other users' collateral or positions.
- **根本原因**: Using predictable or non-namespaced keys for dynamic fields in a shared context.  In Sui Move, dynamic_field keys can be any type. If two features use the same key  type (e.g., u64 representing an ID) without a wrapper struct (Namespacing),  they will collide.

- **缓解措施**: Always wrap dynamic field keys in unique, module-defined structs (Namespacing).  Check for existence before adding, and ensure the caller has authority over  the target field.

- **验证**: Tooling: Use move-scanner with the dynamic_field_collision rule.  Manual: Inspect dynamic_field::add and borrow_mut calls for generic key types.


Protocol uses dynamic fields to store user-specific state or configuration. If the  field name is predictable (e.g., uses a simple salt or just the user's address) and  the protocol provides a way to "re-initialize" or "migrate" fields without checking  if they already exist or belong to the caller, an attacker can overwrite another  user's data or platform configuration by forcing a name collision.

## [DXD-SUI-2025-025] Oracle Manipulation via Stale Price
- Score: **5.5/10** 🟡
- Date: 2024-11-03
- Loss: $0 (Theoretical)
- Impact: High - bad debt and insolvency risk.

A lending market accepted stale oracle prices without enforcing a freshness window, allowing flash loan price skew and under-collateralized borrowing.

## [DXD-MS-2026-001] MS-005 算术位运算（Bitwise）边缘案例
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: State Corruption
- Impact: 中 (协议数据不正确或权限逻辑失效)

将多个数据点打包/解包到单个 256 位整数时，发生的位运算操（位移、掩码）错误。 常见错误包括位移超过 256 位，或使用的掩码不正确导致不同数据字段重叠，从而引发对象状态损坏。

## [DXD-MS-2026-007] MS-011 冻结对象权限（Freeze Object）滥用漏洞
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: Protocol Lock (DoS)
- Impact: 中 (对协议维护或升级造成拒绝服务效应)

在需要持续可变性的关键共享对象上错误地使用了 `public_freeze_object` 函数。 一旦被冻结，对象就无法再被修改或撤销冻结。如果在状态对象或管理权限（Capability） 对象上执行此操作，可能会导致整个协议陷入永久瘫痪。

## [DXD-MS-2026-011] MS-009 缺失 'drop' 权能导致的资源泄露
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: Locked/Orphaned Resources
- Impact: 中 (引发渐进式的状态膨胀或用户资产微量流失)

在 Move 中，如果一个结构体没有 `drop` 权能，则它必须被消耗或存储。在结构体解包 （unpacking）过程中，如果由于逻辑错误导致内部资产被“遗忘”，或者被移动到从未使用的 动态字段（Dynamic Field）中，则会导致资源泄露。MoveScanner 2026 将其认定为 复杂数据迁移产生的一种副作用。

## [DXD-MS-2026-012] MS-009 Resource Leak (Missing Drop)
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: Trapped Storage / Memory Leak
- Impact: Medium (Trapped resources, potential for DoS in specific flows)

Move structs that do not have the `drop` or `store` abilities must be  explicitly handled or "unpacked". If a module logic allows these structs  to be created but fails to provide a path to consume or return them  (e.g., in a conditional branch that aborts or ends prematurely), the  resource becomes trapped in the transaction or state, potentially  blocking further logic.

## [DXD-SUI-2025-014] AGENT-007 Verifiable Intent Failure
- Score: **4.5/10** 🟡
- Date: 2025-12-07
- Loss: Logic bypass mapping
- Impact: Medium

An agent executes a transaction without on-chain verifiable intent proof (e.g., ZK Proof or Multi-Signature verification missing).

## [DXD-SUI-2025-026] Shared Object Race in Mysticeti Parallel Execution
- Score: **4.5/10** 🟡
- Date: 2025-06-01
- Loss: N/A (Risk post-upgrade)
- Impact: Medium-High - Inconsistent state, DoS, hoặc value loss ở shared pools.

Missing version/sequence check in shared object updates → race condition khi parallel tx mutate cùng object (Mysticeti tăng speed → higher risk).

## [DXD-SUI-2025-029] Package Upgrade Abort via Capability Mismatch
- Score: **4.5/10** 🟡
- Date: 2024-07-14
- Loss: $0 (Protocol Lock)
- Impact: Medium - deployment failures and upgrade downtime.

Upgrade logic accepted mismatched capability versions, causing publish aborts or inconsistent upgrade state.

## [DXD-SUI-2023-001] HamsterWheel DoS Infinite Loop
- Score: **4.5/10** 🟡
- **Formal Proof**: [`agent_shared_object_consistency.move`](../prover-examples/sources/agent_shared_object_consistency.move)
- Date: 2023-06-19
- Loss: $0 (Network Halt)
- Impact: Critical - validator halt and potential network disruption.
- **根本原因**: Unbounded loops or deep recursion that approaches the gas limit without  providing a way to 'checkpoint' or partition the work.

- **缓解措施**: 1. Implement Pagination for all dynamic field iterations. 2. Set strict upper  bounds on collection sizes. 3. Avoid deep recursion.

- **验证**: Stress Testing: Attempt to call the target function with maximum allowed  collection sizes and verify it stays well within gas limits.


A malicious control flow graph can force the verifier into a non-terminating loop, stalling validation and causing a denial of service.
