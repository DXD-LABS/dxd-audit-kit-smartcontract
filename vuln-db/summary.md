# Sui Vuln Database Summary

| ID | Name | Score | Severity | Proof | Date |
| :--- | :--- | :---: | :--- | :---: | :--- |
| DXD-SUI-2025-002 | AGENT-004 Intent Spoofing / Mismatch | **6.5** | 🟡 High | [🔍 agent_intent_verification.move](../prover-examples/sources/agent_intent_verification.move) | 2025-12-04 |
| DXD-SUI-2024-006 | Seal Misuse in Hot Potato Pattern | **6.5** | 🟡 Medium | [🔍 agent_owned_receipt.move](../prover-examples/sources/agent_owned_receipt.move) | 2024-09-02 |
| DXD-SUI-2025-016 | AGENT-013 Side-Channel Data Leak in Privacy-Protected Agent Memory | **6.0** | 🟡 Critical | ⏳ | 2026-03-07 |
| DXD-SUI-2025-021 | AGENT-008 Privacy Leak via Unverified ZK-Intent in Agent Execution | **6.0** | 🟡 Critical | [🔍 agent_zk_intent_privacy.move](../prover-examples/sources/agent_zk_intent_privacy.move) | 2026-03-07 |
| DXD-SUI-2025-023 | Nautilus TEE Attestation Bypass | **6.0** | 🟡 Critical | [🔍 nautilus_tee_attest.move](../prover-examples/sources/nautilus_tee_attest.move) | 2026-03-06 |
| DXD-MS-2026-002 | MS-004 Capability Leak via Object Wrapping | **6.0** | 🟡 Critical | ⏳ | 2026-02-15 |
| DXD-MS-2026-005 | MS-002 Dynamic Field Double-Spend | **6.0** | 🟡 Critical | ⏳ | 2026-02-15 |
| DXD-MS-2026-013 | MS-008 Token Issuance Ability Misuse | **6.0** | 🟡 Critical | ⏳ | 2026-02-15 |
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
| DXD-MS-2026-003 | MS-003 Cross-Module Permission Defect | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-004 | MS-006 Custom Math Lib Edge Case | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-006 | MS-012 Entry Function Over-exposure | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-008 | MS-007 Parallel Race via Object Dependency | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-009 | MS-010 Phantom Type Safety Bypass | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-010 | MS-001 Dynamic Field Resource Leak | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-SUI-2025-015 | AGENT-006 Shared Object Race in Multi-Agent Workflow | **5.5** | 🟡 High | ⏳ | 2025-12-06 |
| DXD-SUI-2025-012 | AGENT-005 Memory Poisoning Leading to Rogue Tx | **5.5** | 🟡 High | ⏳ | 2025-12-05 |
| DXD-SUI-2025-017 | AGENT-002 Rogue Agent Spend Limit Bypass | **5.5** | 🟡 High | [🔍 agent_spend_limit_enforce.move](../prover-examples/sources/agent_spend_limit_enforce.move) | 2025-12-02 |
| DXD-SUI-2025-020 | AGENT-001 Unauthorized Tool Call via Prompt Injection | **5.5** | 🟡 High | [🔍 agent_unauthorized_tool_prevent.move](../prover-examples/sources/agent_unauthorized_tool_prevent.move) | 2025-12-01 |
| DXD-SUI-2025-024 | Nemo Economic Logic Exploit | **5.5** | 🟡 High | ⏳ | 2025-09-08 |
| DXD-SUI-2025-028 | Unaudited Custom Library Dependency Inheritance | **5.5** | 🟡 High | ⏳ | 2025-01-01 |
| DXD-SUI-2024-005 | Upgradable Package State Corruption (Migration) | **5.5** | 🟡 High | ⏳ | 2024-12-30 |
| DXD-SUI-2024-004 | Dynamic Field Name Collision/Overwrite (Typus) | **5.5** | 🟡 High | [🔍 no_double_spend_transfer.move](../prover-examples/sources/no_double_spend_transfer.move) | 2024-12-15 |
| DXD-SUI-2025-025 | Oracle Manipulation via Stale Price | **5.5** | 🟡 High | ⏳ | 2024-11-03 |
| DXD-MS-2026-001 | MS-005 Arithmetic Bitwise Edge Case | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-MS-2026-007 | MS-011 Freeze Object Misuse | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-MS-2026-011 | MS-009 Resource Leak via Missing 'drop' | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
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

- **Root Cause**: Cryptographic Mismatch between Intent and Execution. The off-chain AI agent signs  an 'Intent', but the on-chain execution function accepts individual parameters  without verifying they match the signed intent hash.

- **Mitigation**: Hash all function parameters into an Intent struct on-chain and verify it  against the agent's signature.

- **Verification**: Cryptographic Audit: Ensure that every parameter used in state-changing logic  is included in the signature payload.


Off-chain agent intent mismatches on-chain execution. The function does not  verify the hash of the expected parameters.

## [DXD-SUI-2024-006] Seal Misuse in Hot Potato Pattern
- Score: **6.5/10** 🟡
- **Formal Proof**: [`agent_owned_receipt.move`](../prover-examples/sources/agent_owned_receipt.move)
- Date: 2024-09-02
- Loss: $0 (Privacy Exposure)
- Impact: Medium - privacy exposure.
- **Root Cause**: Failure to verify the PackageID associated with a Seal object or allowing 'Hot Potato'  objects to be 'dropped' without returning them to their destination.

- **Mitigation**: Use 'Hot Potato' patterns (structs without drop or store abilities) correctly  to enforce control flow within a single transaction.

- **Verification**: Static Analysis: Check for structs without abilities that are passed as parameters  but not consumed or returned as intended.


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

## [DXD-MS-2026-002] MS-004 Capability Leak via Object Wrapping
- Score: **6.0/10** 🟡
- Date: 2026-02-15
- Loss: Privilege Escalation
- Impact: Critical (Complete protocol compromise if admin keys are leaked)

A sensitive Capability (e.g., AdminCap) is wrapped inside another object.  If that container object is public or shared and the extraction logic is  flawed, an attacker may extract the Capability and perform administrative  actions meant only for the protocol owner.

## [DXD-MS-2026-005] MS-002 Dynamic Field Double-Spend
- Score: **6.0/10** 🟡
- Date: 2026-02-15
- Loss: Asset Overwrite/Duplication
- Impact: Critical (Unauthorized asset substitution or logic bypass)

Logical flaws in managing dynamic fields where a unique key is reused to bind  a new resource without verifying if the old one was consumed. In Sui, re-binding  the same name to a dynamic field overwrites the value, but if the old value  was a 'Balance' or 'Coin', it can lead to state inconsistency or fund loss.

## [DXD-MS-2026-013] MS-008 Token Issuance Ability Misuse
- Score: **6.0/10** 🟡
- Date: 2026-02-15
- Loss: Hyper-inflation/Token Theft
- Impact: Critical (Complete loss of token value and supply control)

Move's ability system (`store`, `drop`, `copy`, `key`) manages resource safety.  If a token module incorrectly assigns the `copy` or `store` ability to a  `TreasuryCap` or sensitive witness struct, an attacker may duplicate or  transfer the minting power, leading to unauthorized token issuance.

## [DXD-SUI-2025-001] AGENT-003 Permission Abuse in Delegated Execution
- Score: **6.0/10** 🟡
- **Formal Proof**: [`agent_policy_guard.move`](../prover-examples/sources/agent_policy_guard.move)
- Date: 2025-12-03
- Loss: Simulated complete protocol takeover
- Impact: Critical (Unauthorized admin access)

- **Root Cause**: Over-privileged Capabilities. The vulnerability occurs when a capability intended  for a low-value task is used for a high-value task due to a lack of granular  scoping in the smart contract's authorization logic.

- **Mitigation**: Implement Scoped Capabilities or Intent-based verification where the capability  only allows execution of a specific function or with specific object IDs.

- **Verification**: Integration Tests: Attempt to perform an unauthorized action using a restricted  agent capability and verify it aborts.


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
- **Root Cause**: Over-reliance on Generics without Type Constraint Validation. Developers coming from  Account-based models often forget that in Move, any user can define a type `T`.  A function `swap<T>` is a 'permissionless entry' unless `T` is strictly compared  against a set of trusted `TypeTag`s or `TypeName`s on-chain.

- **Mitigation**: 1. Use `sui::type_name::get<T>()` to compare against a registry of allowed types.  2. Use the 'Witness' pattern where users must provide an object that can only be  created by the legitimate token issuer.

- **Verification**: Manual Audit: Check all functions accepting generic `Coin<T>` and trace if `T` is  validated against a configuration object or hardcoded whitelist.


A protocol function accepts a generic token type `Coin<T>` or a specific struct `TreasuryCap<T>`  without verifying that `T` matches the platform's whitelist. An attacker can deploy a  malicious module with a token named similarly (e.g., "SUI") and use it to interact with  swap or lending pools, effectively "stealing" real assets by providing worthless fake tokens.

## [DXD-SUI-2024-002] Vault Share Math Logic Error (Souffl3)
- Score: **6.0/10** 🟡
- **Formal Proof**: [`no_double_spend.move`](../prover-examples/sources/no_double_spend.move)
- Date: 2024-11-20
- Loss: $50k+ (Restricted)
- Impact: Medium - Slow drain of vault funds over time via micro-transactions.
- **Root Cause**: Legacy Solidity-style math in Move without accounting for directional rounding. In DeFi,  rounding should always favor the protocol (round down for user receipts, round up for user payments).  Failure to use a 'round_up' flag or a safe math library for shares led to precision loss leakage.

- **Mitigation**: Implement a helper function for proportional math that accepts a `round_up` boolean. Always use  u128 for intermediate multiplications before division to prevent overflow.

- **Verification**: Unit Tests: Mock a vault with low liquidity and high share price, then verify that micro-deposits  cannot result in effectively free shares.


Incorrect rounding in share calculation logic. When calculating the amount of assets per share,  the contract rounded down for withdrawals or up for deposits in a way that favored the user,  allowing "dust" attacks where a user could repeatedly deposit and withdraw small amounts  to slowly drain the vault's underlying assets.

## [DXD-SUI-2024-001] Shared Object Access Control Bypass (BlueMove)
- Score: **6.0/10** 🟡
- **Formal Proof**: [`safe_transfer.move`](../prover-examples/sources/safe_transfer.move)
- Date: 2024-11-05
- Loss: $250k+ (Restricted)
- Impact: High - Unauthorized fund withdrawal, total loss of shared object state authority.
- **Root Cause**: Fundamental misunderstanding of Sui Object Ownership. The developer assumed that because an object  is 'Shared', it still implicitly respects permissions, whereas Shared Objects are publicly  accessible and require explicit 'Capability-based' or 'Address-based' access control within  the function logic.

- **Mitigation**: Always require an `&AdminCap` or `&OwnerCap` as a parameter. Use standard patterns from  `secure-patterns/sources/access_control.move`.

- **Verification**: Formal Verification: `sui move prove` with 'aborts_if' specs to ensure functions without  valid capabilities always fail.


The contract uses a Shared Object but fails to verify the caller's identity or the presence of an  admin capability within the function. Any user can call the `take()` or `withdraw()` function  on the shared object, draining its resources. In the BlueMove case, the lack of `OwnerCap`  validation in the DEX allowed unauthorized liquidity removal.

## [DXD-SUI-2026-001] AGENT-012 BTCfi Oracle Manipulation in Agent-Driven Trades
- Score: **5.5/10** 🟡
- **Formal Proof**: [`agent_btcfi_oracle_bounds.move`](../prover-examples/sources/agent_btcfi_oracle_bounds.move)
- Date: 2026-03-07
- Loss: Simulated (oracle skew leading to $150k+ bad debt)
- Impact: High (protocol bad debt, user fund loss, fits Sui BTCfi expansion 2026)
- **Root Cause**: Oracle Dependency Anti-pattern. The core issue is the 'Single Source of Truth' without  on-chain validation. In the context of Agentic DeFi (2026), AI agents often react faster  than human guardians, making oracle-skew vulnerabilities catastrophic if not guarded  by multi-feed consensus or TWAP checks.

- **Mitigation**: 1. Implement Multi-Oracle Aggregation (e.g., Pyth + Switchboard + Supra).  2. Add Heartbeat checks (staleness protection). 3. Implement Maximum Deviation Thresholds.

- **Verification**: Simulation: Run an adversarial agent that pumps a low-liquidity oracle feed while  simultaneously triggering the liquidation function.


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

## [DXD-MS-2026-003] MS-003 Cross-Module Permission Defect
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Unauthorized Administrative Action
- Impact: High (Unauthorized state mutations across protocol modules)

When multiple modules interact (e.g., protocol core and periphery), a module  may trust another module's public functions without verifying the specific  caller's identity or capability. This is exacerbated by the misuse of 'friend'  functions that allow any 'friend' module to perform sensitive operations.

## [DXD-MS-2026-004] MS-006 Custom Math Lib Edge Case
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Economic Extraction/DeFi Loss
- Impact: High (Financial loss in DEX/Lending pools over time)

Many protocols use custom fixed-point math libraries (e.g., for interest rates,  bonding curves). These libraries may have edge cases in power/log functions  or precision rounding that can be exploited for small but cumulative  financial gain by an attacker.

## [DXD-MS-2026-006] MS-012 Entry Function Over-exposure
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Privilege Escalation/State Corruption
- Impact: High (Unauthorized administrative state mutations)

Administrative or mission-critical initialization functions marked as  `entry` without proper `TxContext` sender verification. This allows any  user to call these functions directly from a transaction, potentially  re-initializing state or gaining unauthorized access.

## [DXD-MS-2026-008] MS-007 Parallel Race via Object Dependency
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Inconsistent Protocol State
- Impact: High (Potential for invalid state or economic extraction under load)

Sui's high-speed parallel execution (Mysticeti) assumes transactions  operating on different objects can run concurrently. If a transaction  depends on multiple objects and a race condition is created where the  state of one object affects the logic of another in an unexpected order,  security invariant violations may occur.

## [DXD-MS-2026-009] MS-010 Phantom Type Safety Bypass
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Asset Substitution/Pool Theft
- Impact: High (Unauthorized asset extraction from DeFi pools)

The `phantom` keyword in Move generics marks types that aren't stored  internally but define permissions. If omitted, the Move compiler may  allow unsound type substitutions in complex hierarchies, enabling an  attacker to swap one token type for another in a generic vault or pool.

## [DXD-MS-2026-010] MS-001 Dynamic Field Resource Leak
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Locked Objects (Unrecoverable storage)
- Impact: High (Permanent fund loss for specific users, storage bloat)

When a parent object is deleted or its ownership is wrapped, its dynamic fields  (DF) or dynamic object fields (DOF) are not automatically cleaned up. These  fields become "orphaned" on the blockchain, permanently locking the assets  or data they contain. MoveScanner found this is common in upgradeable  contracts where the old object is deprecated but fields aren't migrated.

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
- **Root Cause**: Lack of access control on the 'Administrative Bridge' (migration function). In Sui,  upgrades change the package ID, but not the Shared Object ID. The common pitfall is  forgetting that even if the new package is 'safe', the bridge function to transition  old data to new logic is a major attack vector if left public.

- **Mitigation**: 1. Always protect `migrate` functions with `&UpgradeCap`.  2. Implement a 'Version Guard' inside the object to ensure migration only runs once  for each version jump.

- **Verification**: Manual Audit: Search for any public functions named `migrate` or `init_version` and ensure  they take a restrictively owned Capability.


Protocol implements an upgrade mechanism with a `migrate` function to update shared  object states after a package upgrade. If the `migrate` function is not properly  protected by checking for the `UpgradeCap` or a specific version-bound admin  capability, any user can trigger the migration prematurely or multiple times,  leading to state corruption, data loss, or unauthorized privilege escalation.

## [DXD-SUI-2024-004] Dynamic Field Name Collision/Overwrite (Typus)
- Score: **5.5/10** 🟡
- **Formal Proof**: [`no_double_spend_transfer.move`](../prover-examples/sources/no_double_spend_transfer.move)
- Date: 2024-12-15
- Loss: $N/A (Prevented/Found in Audit)
- Impact: High - State corruption, potential unauthorized access to other users' collateral or positions.
- **Root Cause**: Using predictable or non-namespaced keys for dynamic fields in a shared context.  In Sui Move, dynamic_field keys can be any type. If two features use the same key  type (e.g., u64 representing an ID) without a wrapper struct (Namespacing),  they will collide.

- **Mitigation**: Always wrap dynamic field keys in unique, module-defined structs (Namespacing).  Check for existence before adding, and ensure the caller has authority over  the target field.

- **Verification**: Tooling: Use move-scanner with the dynamic_field_collision rule.  Manual: Inspect dynamic_field::add and borrow_mut calls for generic key types.


Protocol uses dynamic fields to store user-specific state or configuration. If the  field name is predictable (e.g., uses a simple salt or just the user's address) and  the protocol provides a way to "re-initialize" or "migrate" fields without checking  if they already exist or belong to the caller, an attacker can overwrite another  user's data or platform configuration by forcing a name collision.

## [DXD-SUI-2025-025] Oracle Manipulation via Stale Price
- Score: **5.5/10** 🟡
- Date: 2024-11-03
- Loss: $0 (Theoretical)
- Impact: High - bad debt and insolvency risk.

A lending market accepted stale oracle prices without enforcing a freshness window, allowing flash loan price skew and under-collateralized borrowing.

## [DXD-MS-2026-001] MS-005 Arithmetic Bitwise Edge Case
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: State Corruption
- Impact: Medium (Incorrect protocol data or permission logic)

Errors in bitwise manipulation (shifts, masks) when packing/unpacking multiple  data points into a single 256-bit integer. Common mistakes include shifting  beyond 256 or using incorrect masks that overlap different data fields,  leading to corrupted object state.

## [DXD-MS-2026-007] MS-011 Freeze Object Misuse
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: Protocol Lock (DoS)
- Impact: Medium (Denial of Service for protocol maintenance/upgrades)

Improper use of `public_freeze_object` on mission-critical shared objects  that require future mutability. Once frozen, an object can never be  mutated or un-frozen, leading to permanent protocol paralysis if done  on a state object or administrative capability.

## [DXD-MS-2026-011] MS-009 Resource Leak via Missing 'drop'
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: Locked/Orphaned Resources
- Impact: Medium (Gradual state bloat or small per-user asset loss)

In Move, if a struct does not have the `drop` ability, it must be consumed or  stored. Logical errors during struct unpacking where internal assets are  'forgotten' or moved to a dynamic field that is never used can result in  resource leaks. MoveScanner 2026 identified this as a byproduct of complex  data migrations.

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
- **Root Cause**: Unbounded loops or deep recursion that approaches the gas limit without  providing a way to 'checkpoint' or partition the work.

- **Mitigation**: 1. Implement Pagination for all dynamic field iterations. 2. Set strict upper  bounds on collection sizes. 3. Avoid deep recursion.

- **Verification**: Stress Testing: Attempt to call the target function with maximum allowed  collection sizes and verify it stays well within gas limits.


A malicious control flow graph can force the verifier into a non-terminating loop, stalling validation and causing a denial of service.
