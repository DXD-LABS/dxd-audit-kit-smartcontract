# Sui 漏洞库摘要 (Move)

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

## AGENT-013 Side-Channel Data Leak in Privacy-Protected Agent Memory
- Date: 2026-03-07
- Loss: Simulated (privacy breach $500k+ class-action equivalent)
- Severity: Critical
- Impact: Critical (user data exposure, regulatory liability in private agents)

An agent stores per-user memory (intent state, balances) using variable-size data structures. Even when guarded by zk/TEE wrappers, the on-chain gas consumption or dynamic field size varies based on secret data, creating a timing/size side-channel. An observer monitoring transaction gas or object byte growth can infer the contents of private agent memory (wallet balances, intent payload length, number of recent actions). Root cause: memory block size grows proportionally to sensitive data rather than being padded to a fixed constant-size block.

## AGENT-014 Unaudited Lib Dependency in Agent Modules
- Date: 2026-03-07
- Loss: Simulated ($300k+ via lib vuln cascade)
- Severity: High
- Impact: High (systemic if lib popular in agentic economy; full admin takeover)

An agent module imports a third-party Move library (e.g., a zk helper or TEE SDK) that has not been audited and contains a backdoor: a public init function that mints an AdminCap accessible to any caller. On deployment or first use, an attacker calls the backdoor to extract the AdminCap and gain full admin control over the agent module (drain treasury, upgrade packages, modify agent policies). Root cause: no verification that imported library packages are from audited, trusted sources before integration into the agent.

## AGENT-010 Multi-Agent Consensus Failure via Byzantine Rogue Agent
- Date: 2026-03-07
- Loss: Simulated (multi-agent drain $200k+)
- Severity: High
- Impact: High (ecosystem-wide if agent swarms control large treasuries)

In a multi-agent workflow, a rogue (Byzantine) agent injects faulty votes or approvals into a shared consensus object without signature verification. The contract tallies unverified votes and grants approval even when the cryptographically-verified threshold is not met. This allows the rogue agent to trigger a shared vault drain, unauthorized treasury sweep, or intent execution below quorum. Root cause: the vote counter accepts any caller's vote without verifying an agent signature or membership proof.

## AGENT-012 BTCfi Oracle Manipulation in Agent-Driven Trades
- Date: 2026-03-07
- Loss: Simulated (oracle skew leading to $150k+ bad debt)
- Severity: High
- Impact: High (protocol bad debt, user fund loss, fits Sui BTCfi expansion 2026)

An agent relies on a single BTCfi oracle feed (e.g., BTC/SUI price) for liquidation or collateral valuation decisions. An attacker manipulates the off-chain oracle price feed (e.g., via TWAP manipulation, stale data replay, or poisoning the oracle provider) causing the agent to execute a liquidation at a significantly skewed price. The on-chain contract accepts the oracle value without deviation bounds or multi-feed aggregation, creating bad debt or enabling the attacker to front-run liquidations at incorrect valuations. Root cause: single-source oracle with no staleness check or deviation guard.

## AGENT-008 Privacy Leak via Unverified ZK-Intent in Agent Execution
- Date: 2026-03-07
- Loss: Simulated ($100k+ in privacy-compromised assets)
- Severity: Critical
- Impact: Critical (data exfil, user privacy breach in agentic economy)

An agent executes a transaction based on a zk-proof intent but does not fully verify the proof fields, allowing sensitive data (user wallet state, off-chain memory, intent payload) to be exposed via on-chain dynamic fields or side-channels. The root cause is accepting a ZkIntentProof without asserting that no sensitive data is exposed through proof.public_inputs or leaked dynamic field writes. An attacker who can observe on-chain object state can extract the user's intent or balance information.

## AGENT-009 TEE Tampering in Nautilus-Attested Agent Compute
- Date: 2026-03-07
- Loss: Simulated (TEE breach leading to $50k+ rogue tx)
- Severity: High
- Impact: High (cascading failures in verifiable agents, rogue on-chain tx)

An adversary tampers with a Nautilus TEE enclave via side-channel or weak attestation (e.g., replaying a stale attestation report, injecting a fabricated quote). The on-chain contract then accepts rogue off-chain compute outputs — altered AI inference results — triggering unauthorized transfers or intent spoofing. Missing checks include: attestation validity gate, freshness window (epoch-based), and report_data == input_hash binding. This extends the existing nautilus_tee_bypass.yaml with an active tampering vector (not just bypass) and a quantified PoC.

## AGENT-002 Rogue Agent Spend Limit Bypass
- Date: 2025-12-02
- Loss: Simulated $50k+ in test env
- Severity: High
- Impact: Medium to High

Agent bypasses its spend limit through multi-step workflows or memory poisoning. If an agent's tracked spending is stored off-chain or poorly managed on-chain, it can be reset or manipulated.

## AGENT-011 NFT/Kiosk Bypass in Agent-Controlled Assets
- Date: 2026-03-07
- Loss: Simulated ($10k+ in kiosk-locked NFT assets)
- Severity: High
- Impact: Medium-High (NFT drain in agentic gaming, RWA, and digital asset protocols)

An agent that receives a KioskOwnerCap for a scoped workflow can bypass NFT ownership checks by performing an unauthorized transfer via the kiosk API without verifying the receiver matches the expected owner. Sui's Kiosk model enforces purchase/transfer policies, but an agent holding the cap and executing a custom bypass path (e.g., via dynamic fields or unlocked place/take cycles) can extract NFTs from the kiosk without completing a legitimate sale. Root cause: missing assert that kiosk owner == permitted agent address and that transfer policy rules are enforced before item extraction.

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

## MS-005 算术位运算（Bitwise）边缘案例
- Date: 2026-02-15
- Loss: State Corruption
- Severity: Medium
- Impact: 中 (协议数据不正确或权限逻辑失效)

将多个数据点打包/解包到单个 256 位整数时，发生的位运算操（位移、掩码）错误。 常见错误包括位移超过 256 位，或使用的掩码不正确导致不同数据字段重叠，从而引发对象状态损坏。

## MS-004 包装对象导致的权限（Capability）泄露
- Date: 2026-02-15
- Loss: Privilege Escalation
- Severity: Critical
- Impact: 严重 (如果管理私钥泄露，整个协议将被接管)

敏感的权限（例如 AdminCap）被包装在另一个对象内部。如果该容器对象是公共或共享的， 且提取逻辑存在漏洞，攻击者则可能提取该权限并执行仅限协议所有者使用的管理操作。

## MS-003 跨模块权限缺陷
- Date: 2026-02-15
- Loss: Unauthorized Administrative Action
- Severity: High
- Impact: 高 (在不同协议模块间发生非法状态修改)

当多个模块（例如协议核心与外围模块）交互时，一个模块可能会信任另一个模块的公共函数， 而未核查特定的调用者身份或权限（Capability）。过度使用 'friend' 函数会加剧此风险， 因为它允许任何 'friend' 模块执行敏感操作。

## MS-006 自定义数学库边缘案例
- Date: 2026-02-15
- Loss: Economic Extraction/DeFi Loss
- Severity: High
- Impact: 高 (DEX/借贷池随时间推移而发生的财务损失)

许多协议使用自定义的定点数学库（例如利率、联合曲线）。这些库在幂/对数函数或精度舍入方面 可能存在边缘案例，攻击者可以利用这些漏洞获取微小但持续累积的财务利益。

## MS-002 动态字段双花漏洞
- Date: 2026-02-15
- Loss: Asset Overwrite/Duplication
- Severity: Critical
- Impact: 严重 (资产被非法替换或核心逻辑被绕过)

在管理动态字段时，由于重用唯一键来绑定新资源，而未核实旧资源是否已被消耗，导致逻辑缺陷。 在 Sui 中，将相同名称重新绑定到动态字段会覆盖其值，但如果旧值是 'Balance' 或 'Coin'， 则可能导致状态不一致或资金损失。

## MS-012 Entry 函数暴露过度漏洞
- Date: 2026-02-15
- Loss: Privilege Escalation/State Corruption
- Severity: High
- Impact: 高 (引发非法的管理状态修改)

管理类或关键的初始化函数被标记为 `entry` 后，若没有进行严谨的 `TxContext`  发送者校验，将会导致漏洞。这使得任何用户都可以直接从一个交易中调用这些函数， 并可能重新初始化对象状态或获取未授权的访问权限。

## MS-011 冻结对象权限（Freeze Object）滥用漏洞
- Date: 2026-02-15
- Loss: Protocol Lock (DoS)
- Severity: Medium
- Impact: 中 (对协议维护或升级造成拒绝服务效应)

在需要持续可变性的关键共享对象上错误地使用了 `public_freeze_object` 函数。 一旦被冻结，对象就无法再被修改或撤销冻结。如果在状态对象或管理权限（Capability） 对象上执行此操作，可能会导致整个协议陷入永久瘫痪。

## MS-007 跨对象依赖引发的并行执行竞争漏洞
- Date: 2026-02-15
- Loss: Inconsistent Protocol State
- Severity: High
- Impact: 高 (在高负载下可能导致非法状态或发生经济榨取)

Sui 的高速并行执行机制（Mysticeti）假设对不同对象进行的操作可以并发运行。如果 一个交易依赖于多个对象，且由于执行顺序不可预测而产生竞态条件（即一个对象的状态 以非预期的方式影响另一个对象的逻辑），则可能导致安全不变性被违反。

## MS-010 虚型（Phantom Type）安全绕过漏洞
- Date: 2026-02-15
- Loss: Asset Substitution/Pool Theft
- Severity: High
- Impact: 高 (在 DeFi 资金池中发生非法的资产提取)

Move 泛型中的 `phantom` 关键字标记了不出于内部存储目的、但定义权限的类型。 如果忽略该关键字，Move 编译器可能会在复杂的层级结构中允许不合理的类型替换， 从而使攻击者能够在泛型保管库（Vault）或资金池中将一种代币类型替换为另一种。

## MS-001 动态字段资源泄露漏洞
- Date: 2026-02-15
- Loss: Locked Objects (Unrecoverable storage)
- Severity: High
- Impact: 高 (引发特定用户的永久资金损失、链上存储膨胀)

当父级对象被删除或其所有权被包装（wrapped）时，其动态字段（DF）或动态对象字段（DOF） 不会自动清除。这些字段在区块链上变为“孤儿”状态，永久锁定其包含的资产或数据。 MoveScanner 发现这在可升级合约中很常见，旧对象被弃用但相关字段未迁移。

## MS-009 缺失 'drop' 权能导致的资源泄露
- Date: 2026-02-15
- Loss: Locked/Orphaned Resources
- Severity: Medium
- Impact: 中 (引发渐进式的状态膨胀或用户资产微量流失)

在 Move 中，如果一个结构体没有 `drop` 权能，则它必须被消耗或存储。在结构体解包 （unpacking）过程中，如果由于逻辑错误导致内部资产被“遗忘”，或者被移动到从未使用的 动态字段（Dynamic Field）中，则会导致资源泄露。MoveScanner 2026 将其认定为 复杂数据迁移产生的一种副作用。

## MS-009 Resource Leak (Missing Drop)
- Date: 2026-02-15
- Loss: Trapped Storage / Memory Leak
- Severity: Medium
- Impact: Medium (Trapped resources, potential for DoS in specific flows)

Move structs that do not have the `drop` or `store` abilities must be  explicitly handled or "unpacked". If a module logic allows these structs  to be created but fails to provide a path to consume or return them  (e.g., in a conditional branch that aborts or ends prematurely), the  resource becomes trapped in the transaction or state, potentially  blocking further logic.

## MS-008 代币发行中的权能（Ability）滥用漏洞
- Date: 2026-02-15
- Loss: Hyper-inflation/Token Theft
- Severity: Critical
- Impact: 严重 (导致代币价值完全归零并失去对供应量的控制)

Move 的权能系统（`store`、`drop`、`copy`、`key`）用于管理资源安全。如果代币 模块错误地将 `copy` 或 `store` 权能分配给 `TreasuryCap` 或敏感的 Witness 结构体， 攻击者可能会复制或转移“铸币权”，从而导致非法代币发行。

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
