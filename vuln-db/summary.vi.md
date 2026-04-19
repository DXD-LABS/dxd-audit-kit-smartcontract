# Tổng hợp Lỗ hổng Sui (Move)

| ID | Name | Điểm số | Mức độ | Proof | Date |
| :--- | :--- | :---: | :--- | :---: | :--- |
| DXD-SUI-2025-002 | Giả mạo Ý định (Intent Spoofing) trong giao dịch của Agent | **6.5** | 🟡 High | [🔍 agent_intent_verification.move](../prover-examples/sources/agent_intent_verification.move) | 2025-12-04 |
| DXD-SUI-2024-006 | Lạm dụng cơ chế Seal (Sui Seal Pattern) | **6.5** | 🟡 Medium | [🔍 agent_owned_receipt.move](../prover-examples/sources/agent_owned_receipt.move) | 2024-09-02 |
| DXD-SUI-2025-016 | AGENT-013 Side-Channel Data Leak in Privacy-Protected Agent Memory | **6.0** | 🟡 Critical | ⏳ | 2026-03-07 |
| DXD-SUI-2025-021 | AGENT-008 Privacy Leak via Unverified ZK-Intent in Agent Execution | **6.0** | 🟡 Critical | [🔍 agent_zk_intent_privacy.move](../prover-examples/sources/agent_zk_intent_privacy.move) | 2026-03-07 |
| DXD-SUI-2025-023 | Nautilus TEE Attestation Bypass | **6.0** | 🟡 Critical | [🔍 nautilus_tee_attest.move](../prover-examples/sources/nautilus_tee_attest.move) | 2026-03-06 |
| DXD-MS-2026-002 | Lỗ hổng Rò rỉ Capability do Bao bọc Đối tượng (Object Wrapping) | **6.0** | 🟡 Critical | ⏳ | 2026-02-15 |
| DXD-MS-2026-005 | Lỗ hổng Double-Spend ở Dynamic Field | **6.0** | 🟡 Critical | ⏳ | 2026-02-15 |
| DXD-MS-2026-013 | Lạm dụng Ability trong Phát hành Token | **6.0** | 🟡 Critical | ⏳ | 2026-02-15 |
| DXD-SUI-2025-001 | Lạm dụng Quyền hạn được ủy nhiệm trong AI Agent | **6.0** | 🟡 Critical | [🔍 agent_policy_guard.move](../prover-examples/sources/agent_policy_guard.move) | 2025-12-03 |
| DXD-SUI-2025-027 | Typus Oracle Authority Bypass | **6.0** | 🟡 Critical | ⏳ | 2025-10-15 |
| DXD-SUI-2025-022 | Cetus Spoof Token + Liquidity Math Overflow | **6.0** | 🟡 Critical | ⏳ | 2025-05-22 |
| DXD-SUI-2024-003 | Lỗ hổng giả mạo Token đầu vào (Fake Token Spoofing) | **6.0** | 🟡 High | ⏳ | 2024-12-01 |
| DXD-SUI-2024-002 | Lỗi logic tính toán cổ phần trong Vault (Souffl3) | **6.0** | 🟡 Medium | [🔍 no_double_spend.move](../prover-examples/sources/no_double_spend.move) | 2024-11-20 |
| DXD-SUI-2024-001 | Lỗ hổng bỏ qua kiểm soát quyền truy cập Shared Object (BlueMove) | **6.0** | 🟡 High | [🔍 safe_transfer.move](../prover-examples/sources/safe_transfer.move) | 2024-11-05 |
| DXD-SUI-2026-001 | Lỗ hổng thao túng Oracle BTCfi trong giao dịch tự động của AI Agent | **5.5** | 🟡 High | [🔍 agent_btcfi_oracle_bounds.move](../prover-examples/sources/agent_btcfi_oracle_bounds.move) | 2026-03-07 |
| DXD-SUI-2025-011 | AGENT-011 NFT/Kiosk Bypass in Agent-Controlled Assets | **5.5** | 🟡 High | ⏳ | 2026-03-07 |
| DXD-SUI-2025-013 | AGENT-010 Multi-Agent Consensus Failure via Byzantine Rogue Agent | **5.5** | 🟡 High | ⏳ | 2026-03-07 |
| DXD-SUI-2025-018 | AGENT-009 TEE Tampering in Nautilus-Attested Agent Compute | **5.5** | 🟡 High | ⏳ | 2026-03-07 |
| DXD-SUI-2025-019 | AGENT-014 Unaudited Lib Dependency in Agent Modules | **5.5** | 🟡 High | ⏳ | 2026-03-07 |
| DXD-SUI-2025-030 | zk-Intent Proof Replay (Missing Nullifier) | **5.5** | 🟡 High | ⏳ | 2026-03-06 |
| DXD-MS-2026-003 | Lỗi Phân quyền Giữa Các Module (Cross-Module) | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-004 | Lỗi Cận Biên ở Thư viện Toán học Tùy chỉnh (Custom Math Lib) | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-006 | Lỗ hổng Phơi bày Hàm Entry (Entry Function Over-exposure) | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-008 | Lỗi Race Condition trong Thực thi Song song | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-009 | Lỗi Bỏ qua Bảo mật Kiểu Phantom (Phantom Type) | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-MS-2026-010 | Lỗ hổng Rò rỉ Tài nguyên ở Dynamic Field | **5.5** | 🟡 High | ⏳ | 2026-02-15 |
| DXD-SUI-2025-015 | AGENT-006 Shared Object Race in Multi-Agent Workflow | **5.5** | 🟡 High | ⏳ | 2025-12-06 |
| DXD-SUI-2025-012 | AGENT-005 Memory Poisoning Leading to Rogue Tx | **5.5** | 🟡 High | ⏳ | 2025-12-05 |
| DXD-SUI-2025-017 | AGENT-002 Rogue Agent Spend Limit Bypass | **5.5** | 🟡 High | [🔍 agent_spend_limit_enforce.move](../prover-examples/sources/agent_spend_limit_enforce.move) | 2025-12-02 |
| DXD-SUI-2025-020 | AGENT-001 Unauthorized Tool Call via Prompt Injection | **5.5** | 🟡 High | [🔍 agent_unauthorized_tool_prevent.move](../prover-examples/sources/agent_unauthorized_tool_prevent.move) | 2025-12-01 |
| DXD-SUI-2025-024 | Nemo Economic Logic Exploit | **5.5** | 🟡 High | ⏳ | 2025-09-08 |
| DXD-SUI-2025-028 | Unaudited Custom Library Dependency Inheritance | **5.5** | 🟡 High | ⏳ | 2025-01-01 |
| DXD-SUI-2024-005 | Lỗi hỏng trạng thái khi nâng cấp Package (Migration) | **5.5** | 🟡 High | ⏳ | 2024-12-30 |
| DXD-SUI-2024-004 | Ghi đè/Xung đột tên Dynamic Field (Typus) | **5.5** | 🟡 High | [🔍 no_double_spend_transfer.move](../prover-examples/sources/no_double_spend_transfer.move) | 2024-12-15 |
| DXD-SUI-2025-025 | Oracle Manipulation via Stale Price | **5.5** | 🟡 High | ⏳ | 2024-11-03 |
| DXD-MS-2026-001 | Lỗi Cận Biên Số học Bitwise | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-MS-2026-007 | Lạm dụng Hàm Freeze Object | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-MS-2026-011 | Rò rỉ Tài nguyên do Thiếu Ability 'drop' | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-MS-2026-012 | MS-009 Resource Leak (Missing Drop) | **4.5** | 🟡 Medium | ⏳ | 2026-02-15 |
| DXD-SUI-2025-014 | AGENT-007 Verifiable Intent Failure | **4.5** | 🟡 Medium | ⏳ | 2025-12-07 |
| DXD-SUI-2025-026 | Shared Object Race in Mysticeti Parallel Execution | **4.5** | 🟡 Medium | ⏳ | 2025-06-01 |
| DXD-SUI-2025-029 | Package Upgrade Abort via Capability Mismatch | **4.5** | 🟡 Medium | ⏳ | 2024-07-14 |
| DXD-SUI-2023-001 | Tấn công Từ chối Dịch vụ "Hamsterwheel" (Logic Gas Move) | **4.5** | 🟡 Critical | [🔍 agent_shared_object_consistency.move](../prover-examples/sources/agent_shared_object_consistency.move) | 2023-06-19 |

---

## [DXD-SUI-2025-002] Giả mạo Ý định (Intent Spoofing) trong giao dịch của Agent
- Score: **6.5/10** 🟡
- **Formal Proof**: [`agent_intent_verification.move`](../prover-examples/sources/agent_intent_verification.move)
- Date: 2025-12-04
- Loss: Simulated asset theft
- Impact: Cao

- **Nguyên nhân gốc rễ**: Sự không khớp về mặt mật mã giữa Ý định và Thực thi. AI Agent off-chain ký một  'Ý định' (Intent), nhưng hàm thực thi on-chain lại chấp nhận các tham số riêng lẻ  mà không xác minh xem chúng có khớp với mã băm ý định đã ký hay không.

- **Giải pháp giảm thiểu**: Băm tất cả các tham số hàm thành một struct Intent on-chain và xác minh nó  với chữ ký của Agent.

- **Xác minh**: Kiểm tra mật mã (Cryptographic Audit): Đảm bảo rằng mọi tham số được sử dụng trong  logic thay đổi trạng thái đều được bao gồm trong payload chữ ký.


Ý định của Agent ở phía off-chain không khớp với quá trình thực thi on-chain.  Hàm không xác minh giá trị hash của các tham số dự kiến.

## [DXD-SUI-2024-006] Lạm dụng cơ chế Seal (Sui Seal Pattern)
- Score: **6.5/10** 🟡
- **Formal Proof**: [`agent_owned_receipt.move`](../prover-examples/sources/agent_owned_receipt.move)
- Date: 2024-09-02
- Loss: $0 (Privacy Exposure)
- Impact: Trung bình - rò rỉ quyền riêng tư.
- **Nguyên nhân gốc rễ**: Không xác minh PackageID được liên kết với đối tượng Seal hoặc cho phép các đối tượng  'Hot Potato' bị hủy (drop) mà không được trả lại module đích dự kiến.

- **Giải pháp giảm thiểu**: Sử dụng các mẫu 'Hot Potato' (các struct không có khả năng drop hoặc store) một cách  chính xác để thực thi luồng kiểm soát trong một giao diện duy nhất.

- **Xác minh**: Phân tích tĩnh (Static Analysis): Kiểm tra các struct không có quyền hạn (abilities)  được truyền dưới dạng tham số nhưng không được tiêu thụ hoặc trả về như mong đợi.


Cơ chế Seal trong Sui (thường dùng trong UpgradeCap hoặc các đối tượng 'hot-potato')  được thiết kế để đảm bảo một hành động chỉ được thực hiện bởi một package cụ thể.  Lỗ hổng xảy ra khi logic kiểm tra seal bị thiếu hoặc không chính xác.

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

## [DXD-MS-2026-002] Lỗ hổng Rò rỉ Capability do Bao bọc Đối tượng (Object Wrapping)
- Score: **6.0/10** 🟡
- Date: 2026-02-15
- Loss: Privilege Escalation
- Impact: Nghiêm trọng (Giao thức bị chiếm quyền hoàn toàn nếu admin key bị lộ)

Một Capability nhạy cảm (ví dụ: AdminCap) bị bao bọc (wrapped) bên trong một  đối tượng khác. Nếu đối tượng chứa đó là công khai hoặc được chia sẻ và logic  trích xuất bị lỗi, kẻ tấn công có thể trích xuất Capability đó và thực hiện  các hành động quản trị vốn chỉ dành cho chủ sở hữu giao thức.

## [DXD-MS-2026-005] Lỗ hổng Double-Spend ở Dynamic Field
- Score: **6.0/10** 🟡
- Date: 2026-02-15
- Loss: Asset Overwrite/Duplication
- Impact: Nghiêm trọng (Thay thế tài sản trái phép hoặc bỏ qua logic kiểm tra)

Lỗ hổng logic trong việc quản lý các dynamic field khi một khóa (key) duy nhất  được tái sử dụng để liên kết với tài nguyên mới mà không kiểm tra xem tài nguyên  cũ đã được tiêu thụ chưa. Trong Sui, việc gán lại cùng một tên cho một dynamic field  sẽ ghi đè lên giá trị cũ, nhưng nếu giá trị cũ là 'Balance' hoặc 'Coin', nó có thể  dẫn đến mất cân bằng trạng thái hoặc mất tiền.

## [DXD-MS-2026-013] Lạm dụng Ability trong Phát hành Token
- Score: **6.0/10** 🟡
- Date: 2026-02-15
- Loss: Hyper-inflation/Token Theft
- Impact: Nghiêm trọng (Mất hoàn toàn giá trị token và quyền kiểm soát nguồn cung)

Hệ thống ability của Move (`store`, `drop`, `copy`, `key`) quản lý sự an toàn  của tài nguyên. Nếu một module token gán sai ability `copy` hoặc `store` cho  một `TreasuryCap` hoặc một struct witness nhạy cảm, kẻ tấn công có thể nhân  bản hoặc chuyển giao quyền đúc token, dẫn đến việc phát hành token trái phép.

## [DXD-SUI-2025-001] Lạm dụng Quyền hạn được ủy nhiệm trong AI Agent
- Score: **6.0/10** 🟡
- **Formal Proof**: [`agent_policy_guard.move`](../prover-examples/sources/agent_policy_guard.move)
- Date: 2025-12-03
- Loss: Simulated complete protocol takeover
- Impact: Nghiêm trọng (Truy cập quản trị trái phép)

- **Nguyên nhân gốc rễ**: Quyền hạn quá mức (Over-privileged). Lỗ hổng xảy ra khi một Capability được dự định  cho một tác vụ giá trị thấp lại được sử dụng cho một tác vụ giá trị cao do thiếu  phân tách phạm vi chi tiết trong logic xác thực của bộ hợp đồng thông minh.

- **Giải pháp giảm thiểu**: Triển khai Scoped Capabilities hoặc xác thực dựa trên ý định (Intent-based), trong đó  Capability chỉ cho phép thực thi một hàm cụ thể hoặc với các ID đối tượng cụ thể.

- **Xác minh**: Kiểm tra tích hợp (Integration Tests): Cố gắng thực hiện một hành động trái phép  bằng cách sử dụng một Capability của Agent bị hạn chế và xác minh rằng nó bị hủy (abort).


AI Agent lạm dụng các quyền (Capabilities) được ủy nhiệm (ví dụ: thông qua kiosk hoặc  shared object) để thực hiện các hành động trái phép, thực hiện các tác vụ quản trị  thay vì vai trò được giới hạn của nó.

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

## [DXD-SUI-2024-003] Lỗ hổng giả mạo Token đầu vào (Fake Token Spoofing)
- Score: **6.0/10** 🟡
- Date: 2024-12-01
- Loss: Variable
- Impact: High - Draining of liquidity pools, protocol insolvency.
- **Nguyên nhân gốc rễ**: Over-reliance on Generics without Type Constraint Validation. Developers coming from  Account-based models often forget that in Move, any user can define a type `T`.  A function `swap<T>` is a 'permissionless entry' unless `T` is strictly compared  against a set of trusted `TypeTag`s or `TypeName`s on-chain.

- **Giải pháp giảm thiểu**: 1. Use `sui::type_name::get<T>()` to compare against a registry of allowed types.  2. Use the 'Witness' pattern where users must provide an object that can only be  created by the legitimate token issuer.

- **Xác minh**: Manual Audit: Check all functions accepting generic `Coin<T>` and trace if `T` is  validated against a configuration object or hardcoded whitelist.


Một hàm của giao thức chấp nhận loại token generic `Coin<T>` hoặc một struct cụ thể `TreasuryCap<T>`  mà không xác thực liệu `T` có nằm trong danh sách trắng (whitelist) của nền tảng hay không.  Kẻ tấn công có thể triển khai một module độc hại với token có tên tương tự (ví dụ: "SUI")  và sử dụng nó để tương tác với các bể hoán đổi (swap) hoặc cho vay (lending), từ đó  "đánh cắp" tài sản thực bằng cách cung cấp các token giả không có giá trị.

## [DXD-SUI-2024-002] Lỗi logic tính toán cổ phần trong Vault (Souffl3)
- Score: **6.0/10** 🟡
- **Formal Proof**: [`no_double_spend.move`](../prover-examples/sources/no_double_spend.move)
- Date: 2024-11-20
- Loss: $50k+ (Restricted)
- Impact: Medium - Slow drain of vault funds over time via micro-transactions.
- **Nguyên nhân gốc rễ**: Legacy Solidity-style math in Move without accounting for directional rounding. In DeFi,  rounding should always favor the protocol (round down for user receipts, round up for user payments).  Failure to use a 'round_up' flag or a safe math library for shares led to precision loss leakage.

- **Giải pháp giảm thiểu**: Implement a helper function for proportional math that accepts a `round_up` boolean. Always use  u128 for intermediate multiplications before division to prevent overflow.

- **Xác minh**: Unit Tests: Mock a vault with low liquidity and high share price, then verify that micro-deposits  cannot result in effectively free shares.


Lỗi làm tròn sai trong logic tính toán cổ phần (share). Khi tính toán lượng tài sản tương ứng  với mỗi cổ phần, hợp đồng đã làm tròn xuống khi rút tiền hoặc làm tròn lên khi nạp tiền theo cách  có lợi cho người dùng. Điều này cho phép thực hiện các cuộc tấn công "bụi" (dust attacks) - nơi người dùng  nạp và rút liên tục các khoản tiền cực nhỏ để bào mòn dần tài sản của Vault.

## [DXD-SUI-2024-001] Lỗ hổng bỏ qua kiểm soát quyền truy cập Shared Object (BlueMove)
- Score: **6.0/10** 🟡
- **Formal Proof**: [`safe_transfer.move`](../prover-examples/sources/safe_transfer.move)
- Date: 2024-11-05
- Loss: $250k+ (Restricted)
- Impact: High - Unauthorized fund withdrawal, total loss of shared object state authority.
- **Nguyên nhân gốc rễ**: Fundamental misunderstanding of Sui Object Ownership. The developer assumed that because an object  is 'Shared', it still implicitly respects permissions, whereas Shared Objects are publicly  accessible and require explicit 'Capability-based' or 'Address-based' access control within  the function logic.

- **Giải pháp giảm thiểu**: Always require an `&AdminCap` or `&OwnerCap` as a parameter. Use standard patterns from  `secure-patterns/sources/access_control.move`.

- **Xác minh**: Formal Verification: `sui move prove` with 'aborts_if' specs to ensure functions without  valid capabilities always fail.


Hợp đồng sử dụng một Shared Object nhưng lại thiếu bước xác thực danh tính người gọi hoặc quyền Admin  trong hàm. Bất kỳ người dùng nào cũng có thể gọi hàm `take()` hoặc `withdraw()` trên shared object đó,  dẫn đến bị rút cạn tài sản. Trong trường hợp BlueMove, việc thiếu xác thực `OwnerCap`  trong sàn DEX đã cho phép kẻ tấn công rút thanh khoản trái phép.

## [DXD-SUI-2026-001] Lỗ hổng thao túng Oracle BTCfi trong giao dịch tự động của AI Agent
- Score: **5.5/10** 🟡
- **Formal Proof**: [`agent_btcfi_oracle_bounds.move`](../prover-examples/sources/agent_btcfi_oracle_bounds.move)
- Date: 2026-03-07
- Loss: Simulated (oracle skew leading to $150k+ bad debt)
- Impact: High (protocol bad debt, user fund loss, fits Sui BTCfi expansion 2026)
- **Nguyên nhân gốc rễ**: Oracle Dependency Anti-pattern. The core issue is the 'Single Source of Truth' without  on-chain validation. In the context of Agentic DeFi (2026), AI agents often react faster  than human guardians, making oracle-skew vulnerabilities catastrophic if not guarded  by multi-feed consensus or TWAP checks.

- **Giải pháp giảm thiểu**: 1. Implement Multi-Oracle Aggregation (e.g., Pyth + Switchboard + Supra).  2. Add Heartbeat checks (staleness protection). 3. Implement Maximum Deviation Thresholds.

- **Xác minh**: Simulation: Run an adversarial agent that pumps a low-liquidity oracle feed while  simultaneously triggering the liquidation function.


Một AI Agent phụ thuộc vào một nguồn cấp dữ liệu oracle BTCfi duy nhất (ví dụ: giá BTC/SUI) để  đưa ra quyết định thanh lý hoặc định giá tài sản thế chấp. Kẻ tấn công thao túng nguồn cấp giá  oracle off-chain (ví dụ: thông qua thao túng TWAP, phát lại dữ liệu cũ hoặc đầu độc nhà cung cấp oracle)  khiến Agent thực hiện thanh lý ở mức giá bị sai lệch nghiêm trọng. Hợp đồng on-chain chấp nhận giá trị  oracle mà không có ngưỡng sai lệch hoặc cơ chế tổng hợp nhiều nguồn, tạo ra nợ xấu hoặc cho phép  kẻ tấn công trục lợi từ việc thanh lý sai giá.

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

## [DXD-MS-2026-003] Lỗi Phân quyền Giữa Các Module (Cross-Module)
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Unauthorized Administrative Action
- Impact: Cao (Thay đổi trạng thái trái phép trên các module giao thức)

Khi nhiều module tương tác với nhau (ví dụ: module lõi và module ngoại vi), một  module có thể tin tưởng các hàm public của module khác mà không xác minh danh tính  hoặc capability của người gọi cụ thể. Điều này trở nên tồi tệ hơn do việc lạm dụng  hàm 'friend', cho phép bất kỳ module 'friend' nào thực hiện các hoạt động nhạy cảm.

## [DXD-MS-2026-004] Lỗi Cận Biên ở Thư viện Toán học Tùy chỉnh (Custom Math Lib)
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Economic Extraction/DeFi Loss
- Impact: Cao (Tổn thất tài chính trong các bể DEX/Lending theo thời gian)

Nhiều giao thức sử dụng các thư viện toán học dấu phẩy tĩnh (fixed-point) tùy chỉnh  (ví dụ: cho lãi suất, bonding curves). Các thư viện này có thể có các lỗi cận biên  trong các hàm lũy thừa/logarit hoặc làm tròn độ chính xác mà kẻ tấn công có thể  khai thác để trục lợi tài chính nhỏ nhưng tích lũy dần.

## [DXD-MS-2026-006] Lỗ hổng Phơi bày Hàm Entry (Entry Function Over-exposure)
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Privilege Escalation/State Corruption
- Impact: Cao (Thay đổi trạng thái quản trị trái phép)

Các hàm khởi tạo quản trị hoặc quan trọng được đánh dấu là `entry` mà không xác  minh `TxContext` sender một cách chính xác. Điều này cho phép bất kỳ người dùng  nào gọi trực tiếp các hàm này từ một giao dịch, có khả năng khởi tạo lại trạng  thái hoặc giành được truy cập trái phép.

## [DXD-MS-2026-008] Lỗi Race Condition trong Thực thi Song song
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Inconsistent Protocol State
- Impact: Cao (Khả năng trạng thái không hợp lệ hoặc khai thác kinh tế dưới tải cao)

Hệ thống thực thi song song tốc độ cao của Sui (Mysticeti) giả định các giao dịch  hoạt động trên các đối tượng khác nhau có thể chạy đồng thời. Nếu một giao dịch  phụ thuộc vào nhiều đối tượng và một tình trạng tranh chấp (race condition) được  tạo ra - nơi trạng thái của một đối tượng ảnh hưởng đến logic của đối tượng khác  theo thứ tự không mong đợi - các vi phạm bất biến bảo mật có thể xảy ra.

## [DXD-MS-2026-009] Lỗi Bỏ qua Bảo mật Kiểu Phantom (Phantom Type)
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Asset Substitution/Pool Theft
- Impact: Cao (Trích xuất tài sản trái phép từ các bể DeFi)

Từ khóa `phantom` trong Move generics đánh dấu các kiểu không được lưu trữ  nội bộ nhưng dùng để xác định quyền hạn. Nếu bỏ qua, trình biên dịch Move  có thể cho phép thay thế kiểu không an toàn trong các hệ thống phức tạp,  cho phép kẻ tấn công hoán đổi một loại token này sang loại khác trong  một vault hoặc pool generic.

## [DXD-MS-2026-010] Lỗ hổng Rò rỉ Tài nguyên ở Dynamic Field
- Score: **5.5/10** 🟡
- Date: 2026-02-15
- Loss: Locked Objects (Unrecoverable storage)
- Impact: Cao (Mất tiền vĩnh viễn cho một số người dùng, phình to bộ nhớ lưu trữ)

Khi một đối tượng cha bị xóa hoặc bị bao bọc (wrapped) quyền sở hữu, các dynamic  fields (DF) hoặc dynamic object fields (DOF) của nó không được tự động dọn dẹp.  Các trường này trở thành "mồ côi" trên blockchain, khóa vĩnh viễn các tài sản  hoặc dữ liệu mà chúng chứa. MoveScanner nhận thấy điều này phổ biến trong các  hợp đồng có thể nâng cấp, nơi đối tượng cũ bị loại bỏ nhưng các trường không được di chuyển.

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

## [DXD-SUI-2024-005] Lỗi hỏng trạng thái khi nâng cấp Package (Migration)
- Score: **5.5/10** 🟡
- Date: 2024-12-30
- Loss: Variable
- Impact: High - Irreversible state corruption, potential protocol takeover.
- **Nguyên nhân gốc rễ**: Lack of access control on the 'Administrative Bridge' (migration function). In Sui,  upgrades change the package ID, but not the Shared Object ID. The common pitfall is  forgetting that even if the new package is 'safe', the bridge function to transition  old data to new logic is a major attack vector if left public.

- **Giải pháp giảm thiểu**: 1. Always protect `migrate` functions with `&UpgradeCap`.  2. Implement a 'Version Guard' inside the object to ensure migration only runs once  for each version jump.

- **Xác minh**: Manual Audit: Search for any public functions named `migrate` or `init_version` and ensure  they take a restrictively owned Capability.


Giao thức triển khai cơ chế nâng cấp với hàm `migrate` để cập nhật trạng thái của  các shared object sau khi nâng cấp package. Nếu hàm `migrate` không được bảo vệ đúng cách  (không kiểm tra `UpgradeCap` hoặc một quyền admin cụ thể), bất kỳ người dùng nào cũng có thể  kích hoạt quá trình chuyển đổi dữ liệu sớm hoặc nhiều lần. Điều này dẫn đến hỏng trạng thái,  mất dữ liệu hoặc leo thang đặc quyền trái phép.

## [DXD-SUI-2024-004] Ghi đè/Xung đột tên Dynamic Field (Typus)
- Score: **5.5/10** 🟡
- **Formal Proof**: [`no_double_spend_transfer.move`](../prover-examples/sources/no_double_spend_transfer.move)
- Date: 2024-12-15
- Loss: $N/A (Prevented/Found in Audit)
- Impact: Cao - Làm hỏng trạng thái, có khả năng truy cập trái phép vào tài sản thế chấp hoặc vị thế của người dùng khác.
- **Nguyên nhân gốc rễ**: Sử dụng các khóa (keys) có thể dự đoán được hoặc không phân không gian tên (non-namespaced)  cho các dynamic field trong ngữ cảnh chia sẻ. Trong Sui Move, các khóa dynamic_field  có thể là bất kỳ kiểu dữ liệu nào. Nếu hai tính năng sử dụng cùng một kiểu khóa  (ví dụ: kiểu u64 đại diện cho một ID) mà không có struct bao bọc (Namespacing),  chúng sẽ bị xung đột.

- **Giải pháp giảm thiểu**: Luôn bao bọc các khóa dynamic field trong các struct duy nhất được định nghĩa trong module  (Namespacing). Kiểm tra sự tồn tại trước khi thêm và đảm bảo người gọi có quyền đối với  trường mục tiêu.

- **Xác minh**: Công cụ: Sử dụng move-scanner với quy tắc dynamic_field_collision.  Thủ công: Kiểm tra các lệnh gọi dynamic_field::add và borrow_mut để tìm các kiểu khóa chung.


Giao thức sử dụng các dynamic field để lưu trữ trạng thái hoặc cấu hình riêng biệt cho người dùng.  Nếu tên trường (field name) có thể dự đoán được (ví dụ: sử dụng một giá trị salt đơn giản hoặc  chỉ là địa chỉ của người dùng) và giao thức cho phép "khởi tạo lại" hoặc "di chuyển" các trường  mà không kiểm tra xem chúng đã tồn tại hay thuộc về người gọi hay chưa, kẻ tấn công có thể ghi đè  lên dữ liệu hoặc cấu hình của người dùng khác bằng cách tạo ra sự trùng lặp tên (collision).

## [DXD-SUI-2025-025] Oracle Manipulation via Stale Price
- Score: **5.5/10** 🟡
- Date: 2024-11-03
- Loss: $0 (Theoretical)
- Impact: High - bad debt and insolvency risk.

A lending market accepted stale oracle prices without enforcing a freshness window, allowing flash loan price skew and under-collateralized borrowing.

## [DXD-MS-2026-001] Lỗi Cận Biên Số học Bitwise
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: State Corruption
- Impact: Trung bình (Dữ liệu giao thức hoặc logic phân quyền không chính xác)

Các lỗi trong thao tác bitwise (dịch bit, mặt nạ bit) khi đóng gói/giải nén nhiều  điểm dữ liệu vào một số nguyên 256-bit duy nhất. Các sai lầm phổ biến bao gồm dịch  quá 256 bit hoặc sử dụng các mặt nạ không chính xác làm chồng lấn các trường dữ liệu  khác nhau, dẫn đến trạng thái đối tượng bị hỏng.

## [DXD-MS-2026-007] Lạm dụng Hàm Freeze Object
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: Protocol Lock (DoS)
- Impact: Trung bình (Từ chối dịch vụ cho việc bảo trì/nâng cấp giao thức)

Sử dụng sai hàm `public_freeze_object` trên các đối tượng dùng chung (shared objects)  quan trọng cần có khả năng thay đổi trong tương lai. Khi đã bị đóng băng (frozen),  một đối tượng không bao giờ có thể được sửa đổi hoặc giải đóng băng, dẫn đến việc  giao thức bị tê liệt vĩnh viễn nếu thực hiện trên một đối tượng trạng thái hoặc  capability quản trị.

## [DXD-MS-2026-011] Rò rỉ Tài nguyên do Thiếu Ability 'drop'
- Score: **4.5/10** 🟡
- Date: 2026-02-15
- Loss: Locked/Orphaned Resources
- Impact: Trung bình (Phình to trạng thái hoặc tổn thất tài sản nhỏ cho mỗi người dùng)

Trong Move, nếu một struct không có ability `drop`, nó phải được tiêu thụ hoặc  lưu trữ. Các lỗi logic trong quá trình giải nén struct (unpacking) nơi các tài  sản nội bộ bị "quên" hoặc di chuyển vào một dynamic field không bao giờ được  sử dụng có thể dẫn đến rò rỉ tài nguyên. MoveScanner 2026 xác định đây là hệ quả  của các quá trình di chuyển dữ liệu phức tạp.

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

## [DXD-SUI-2023-001] Tấn công Từ chối Dịch vụ "Hamsterwheel" (Logic Gas Move)
- Score: **4.5/10** 🟡
- **Formal Proof**: [`agent_shared_object_consistency.move`](../prover-examples/sources/agent_shared_object_consistency.move)
- Date: 2023-06-19
- Loss: $0 (Network Halt)
- Impact: Nghiêm trọng - dừng validator và có khả năng gây gián đoạn mạng.
- **Nguyên nhân gốc rễ**: Các vòng lặp không giới hạn hoặc đệ quy sâu tiệm cận giới hạn gas mà không  cung cấp cách thức để 'checkpoint' hoặc phân chia công việc.

- **Giải pháp giảm thiểu**: 1. Triển khai Phân trang cho tất cả các lần lặp dynamic field. 2. Thiết lập  giới hạn trên nghiêm ngặt cho kích thước bộ sưu tập. 3. Tránh đệ quy sâu.

- **Xác minh**: Kiểm tra căng thẳng (Stress Testing): Cố gắng gọi hàm mục tiêu với kích thước  bộ sưu tập tối đa được phép và xác minh nó nằm trong giới hạn gas.


Một loại tấn công DoS trong đó kẻ tấn công gửi các giao dịch gây ra vòng lặp vô hạn  hoặc tính toán cực kỳ tốn kém trong máy ảo Move. Điều này làm chậm mạng hoặc  khiến đối tượng bị khóa.
