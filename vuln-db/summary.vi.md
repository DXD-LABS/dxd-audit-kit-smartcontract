# Tổng hợp Lỗ hổng Sui (Move)

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

## Lỗi Cận Biên Số học Bitwise
- Date: 2026-02-15
- Loss: State Corruption
- Severity: Medium
- Impact: Trung bình (Dữ liệu giao thức hoặc logic phân quyền không chính xác)

Các lỗi trong thao tác bitwise (dịch bit, mặt nạ bit) khi đóng gói/giải nén nhiều  điểm dữ liệu vào một số nguyên 256-bit duy nhất. Các sai lầm phổ biến bao gồm dịch  quá 256 bit hoặc sử dụng các mặt nạ không chính xác làm chồng lấn các trường dữ liệu  khác nhau, dẫn đến trạng thái đối tượng bị hỏng.

## Lỗ hổng Rò rỉ Capability do Bao bọc Đối tượng (Object Wrapping)
- Date: 2026-02-15
- Loss: Privilege Escalation
- Severity: Critical
- Impact: Nghiêm trọng (Giao thức bị chiếm quyền hoàn toàn nếu admin key bị lộ)

Một Capability nhạy cảm (ví dụ: AdminCap) bị bao bọc (wrapped) bên trong một  đối tượng khác. Nếu đối tượng chứa đó là công khai hoặc được chia sẻ và logic  trích xuất bị lỗi, kẻ tấn công có thể trích xuất Capability đó và thực hiện  các hành động quản trị vốn chỉ dành cho chủ sở hữu giao thức.

## Lỗi Phân quyền Giữa Các Module (Cross-Module)
- Date: 2026-02-15
- Loss: Unauthorized Administrative Action
- Severity: High
- Impact: Cao (Thay đổi trạng thái trái phép trên các module giao thức)

Khi nhiều module tương tác với nhau (ví dụ: module lõi và module ngoại vi), một  module có thể tin tưởng các hàm public của module khác mà không xác minh danh tính  hoặc capability của người gọi cụ thể. Điều này trở nên tồi tệ hơn do việc lạm dụng  hàm 'friend', cho phép bất kỳ module 'friend' nào thực hiện các hoạt động nhạy cảm.

## Lỗi Cận Biên ở Thư viện Toán học Tùy chỉnh (Custom Math Lib)
- Date: 2026-02-15
- Loss: Economic Extraction/DeFi Loss
- Severity: High
- Impact: Cao (Tổn thất tài chính trong các bể DEX/Lending theo thời gian)

Nhiều giao thức sử dụng các thư viện toán học dấu phẩy tĩnh (fixed-point) tùy chỉnh  (ví dụ: cho lãi suất, bonding curves). Các thư viện này có thể có các lỗi cận biên  trong các hàm lũy thừa/logarit hoặc làm tròn độ chính xác mà kẻ tấn công có thể  khai thác để trục lợi tài chính nhỏ nhưng tích lũy dần.

## Lỗ hổng Double-Spend ở Dynamic Field
- Date: 2026-02-15
- Loss: Asset Overwrite/Duplication
- Severity: Critical
- Impact: Nghiêm trọng (Thay thế tài sản trái phép hoặc bỏ qua logic kiểm tra)

Lỗ hổng logic trong việc quản lý các dynamic field khi một khóa (key) duy nhất  được tái sử dụng để liên kết với tài nguyên mới mà không kiểm tra xem tài nguyên  cũ đã được tiêu thụ chưa. Trong Sui, việc gán lại cùng một tên cho một dynamic field  sẽ ghi đè lên giá trị cũ, nhưng nếu giá trị cũ là 'Balance' hoặc 'Coin', nó có thể  dẫn đến mất cân bằng trạng thái hoặc mất tiền.

## Lỗ hổng Phơi bày Hàm Entry (Entry Function Over-exposure)
- Date: 2026-02-15
- Loss: Privilege Escalation/State Corruption
- Severity: High
- Impact: Cao (Thay đổi trạng thái quản trị trái phép)

Các hàm khởi tạo quản trị hoặc quan trọng được đánh dấu là `entry` mà không xác  minh `TxContext` sender một cách chính xác. Điều này cho phép bất kỳ người dùng  nào gọi trực tiếp các hàm này từ một giao dịch, có khả năng khởi tạo lại trạng  thái hoặc giành được truy cập trái phép.

## Lạm dụng Hàm Freeze Object
- Date: 2026-02-15
- Loss: Protocol Lock (DoS)
- Severity: Medium
- Impact: Trung bình (Từ chối dịch vụ cho việc bảo trì/nâng cấp giao thức)

Sử dụng sai hàm `public_freeze_object` trên các đối tượng dùng chung (shared objects)  quan trọng cần có khả năng thay đổi trong tương lai. Khi đã bị đóng băng (frozen),  một đối tượng không bao giờ có thể được sửa đổi hoặc giải đóng băng, dẫn đến việc  giao thức bị tê liệt vĩnh viễn nếu thực hiện trên một đối tượng trạng thái hoặc  capability quản trị.

## Lỗi Race Condition trong Thực thi Song song
- Date: 2026-02-15
- Loss: Inconsistent Protocol State
- Severity: High
- Impact: Cao (Khả năng trạng thái không hợp lệ hoặc khai thác kinh tế dưới tải cao)

Hệ thống thực thi song song tốc độ cao của Sui (Mysticeti) giả định các giao dịch  hoạt động trên các đối tượng khác nhau có thể chạy đồng thời. Nếu một giao dịch  phụ thuộc vào nhiều đối tượng và một tình trạng tranh chấp (race condition) được  tạo ra - nơi trạng thái của một đối tượng ảnh hưởng đến logic của đối tượng khác  theo thứ tự không mong đợi - các vi phạm bất biến bảo mật có thể xảy ra.

## Lỗi Bỏ qua Bảo mật Kiểu Phantom (Phantom Type)
- Date: 2026-02-15
- Loss: Asset Substitution/Pool Theft
- Severity: High
- Impact: Cao (Trích xuất tài sản trái phép từ các bể DeFi)

Từ khóa `phantom` trong Move generics đánh dấu các kiểu không được lưu trữ  nội bộ nhưng dùng để xác định quyền hạn. Nếu bỏ qua, trình biên dịch Move  có thể cho phép thay thế kiểu không an toàn trong các hệ thống phức tạp,  cho phép kẻ tấn công hoán đổi một loại token này sang loại khác trong  một vault hoặc pool generic.

## Lỗ hổng Rò rỉ Tài nguyên ở Dynamic Field
- Date: 2026-02-15
- Loss: Locked Objects (Unrecoverable storage)
- Severity: High
- Impact: Cao (Mất tiền vĩnh viễn cho một số người dùng, phình to bộ nhớ lưu trữ)

Khi một đối tượng cha bị xóa hoặc bị bao bọc (wrapped) quyền sở hữu, các dynamic  fields (DF) hoặc dynamic object fields (DOF) của nó không được tự động dọn dẹp.  Các trường này trở thành "mồ côi" trên blockchain, khóa vĩnh viễn các tài sản  hoặc dữ liệu mà chúng chứa. MoveScanner nhận thấy điều này phổ biến trong các  hợp đồng có thể nâng cấp, nơi đối tượng cũ bị loại bỏ nhưng các trường không được di chuyển.

## Rò rỉ Tài nguyên do Thiếu Ability 'drop'
- Date: 2026-02-15
- Loss: Locked/Orphaned Resources
- Severity: Medium
- Impact: Trung bình (Phình to trạng thái hoặc tổn thất tài sản nhỏ cho mỗi người dùng)

Trong Move, nếu một struct không có ability `drop`, nó phải được tiêu thụ hoặc  lưu trữ. Các lỗi logic trong quá trình giải nén struct (unpacking) nơi các tài  sản nội bộ bị "quên" hoặc di chuyển vào một dynamic field không bao giờ được  sử dụng có thể dẫn đến rò rỉ tài nguyên. MoveScanner 2026 xác định đây là hệ quả  của các quá trình di chuyển dữ liệu phức tạp.

## MS-009 Resource Leak (Missing Drop)
- Date: 2026-02-15
- Loss: Trapped Storage / Memory Leak
- Severity: Medium
- Impact: Medium (Trapped resources, potential for DoS in specific flows)

Move structs that do not have the `drop` or `store` abilities must be  explicitly handled or "unpacked". If a module logic allows these structs  to be created but fails to provide a path to consume or return them  (e.g., in a conditional branch that aborts or ends prematurely), the  resource becomes trapped in the transaction or state, potentially  blocking further logic.

## Lạm dụng Ability trong Phát hành Token
- Date: 2026-02-15
- Loss: Hyper-inflation/Token Theft
- Severity: Critical
- Impact: Nghiêm trọng (Mất hoàn toàn giá trị token và quyền kiểm soát nguồn cung)

Hệ thống ability của Move (`store`, `drop`, `copy`, `key`) quản lý sự an toàn  của tài nguyên. Nếu một module token gán sai ability `copy` hoặc `store` cho  một `TreasuryCap` hoặc một struct witness nhạy cảm, kẻ tấn công có thể nhân  bản hoặc chuyển giao quyền đúc token, dẫn đến việc phát hành token trái phép.

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
