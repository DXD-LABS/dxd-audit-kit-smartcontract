# Move Prover Examples (Vietnamese)

Các ví dụ thực hành cho Move Prover formal verification sử dụng MSL specs.

## Hướng dẫn Setup & Run

### Prerequisites (Tiền đề)

- **Sui CLI**: `cargo install --locked sui --git https://github.com/MystenLabs/sui.git`
- **Z3 Solver**:
  - Ubuntu: `sudo apt update && sudo apt install z3 libz3-dev`
  - Mac: `brew install z3`
  - Windows: Tải từ Microsoft Z3 GitHub releases, thêm thư mục bin vào PATH
- **Boogie**: `dotnet tool install -g boogie` (yêu cầu .NET SDK)

### Chạy Prover

```bash
cd prover-examples
sui move prove
```

Nếu tất cả specs verified OK, sẽ không có thông báo lỗi.

### Các Ví dụ

- **safe_transfer.move**: Verify transfer coin an toàn, abort nếu không đủ số dư, không double-spend (số dư cũ = số dư mới + số tiền đã chuyển).
- **no_double_spend.move**: Invariant số dư không âm, rút tiền abort nếu không đủ số dư.
- **flash_loan_safe.move**: Verify việc bắt buộc hoàn trả flash loan (kiểu DeepBook, hot potato bị hủy nếu hoàn trả đủ).
- **lending_collateral.move**: Chỉ cho vay nếu siêu thế chấp 150%, bảo vệ invariant không bị thiếu thế chấp.
- **oracle_safe.move**: Kiểm tra độ tươi của giá Oracle (abort nếu timestamp cũ > max_age).
- **no_double_spend_transfer.move**: Chuyển coin không double-spend (abort nếu thiếu số dư, số dư người gửi -= amount, người nhận += amount, tổng lượng coin được bảo toàn).
- **liquidation_safe.move**: Kiểm tra thanh lý an toàn (needs_liquidation chỉ true khi thiếu thế chấp >120%, abort nếu thanh lý vị thế khỏe mạnh).
- **oracle_deviation_safe.move**: Kiểm tra độ tươi + độ lệch Oracle (abort nếu giá cũ >300s hoặc độ lệch >5%).

### AI-Agent Specific Examples

Các ví dụ chứng minh invariants mang tính chất quan trọng về security cho AI Agent trên Sui (agent wallets, machine transactions):

- **agent_spend_limit_enforce.move**: Chứng minh cumulative spend limit khắt khe cho agent wallet (ngăn chặn rogue hoặc poisoned spends).
  - `invariant policy.spent <= policy.limit`: Tổng spend không vượt limit user-defined (cập nhật cumulative).
  - `aborts_if action.amount + policy.spent > policy.limit with E_SPEND_LIMIT_EXCEEDED`: Abort nếu vượt limit.
  - `ensures policy.spent == old(policy.spent) + action.amount`: Spend tăng đúng sau tx thành công.
  - `modifies policy.spent`: Chỉ update spent nếu pass checks.
  - Use case: Beep/Talus agent wallets với spend caps programmable (e.g., daily/monthly limit), prevent slow-burn drain từ memory poisoning hoặc multi-step rogue tx.

- **agent_intent_verification.move**: Verify on-chain intent match trước khi execute agent action (prevent intent spoofing/mismatch).
  - `invariant intent_verified == true`: Intent phải verified (từ user sig, Seal/Nautilus proof, hoặc zk-verifiable hash).
  - `aborts_if !intent_verified with E_INTENT_MISMATCH`: Abort nếu intent không match.
  - `ensures intent_hash_post == old(intent_hash) && intent_verified == true`: Giữ nguyên sau verify.
  - `modifies intent_verified`: Set true chỉ khi verify pass.
  - Use case: Agent execute tx chỉ khi intent từ off-chain LLM/user được verify on-chain, chống spoofed tx hoặc unauthorized calls.

- **agent_unauthorized_tool_prevent.move**: Prevent rogue tool calls ngoài allowlist (tool whitelist + capability check).
  - `aborts_if !vector::contains(&policy.allowed_tools, &tool_id) with E_UNAUTHORIZED_TOOL`: Abort nếu tool không trong whitelist.
  - `ensures vector::contains(&policy.allowed_tools, &tool_id)`: Chỉ tools allowed mới execute.
  - `invariant forall t in policy.allowed_tools: t is valid_tool_id`: (Optional) global invariant cho allowlist integrity.
  - Use case: Agent chỉ gọi tools được phép (e.g., swap on Cetus, bridge to Ethereum), chống privilege escalation.

- **agent_no_rogue_object_delete.move**: Prevent agent delete hoặc mutate unauthorized objects (Sui-specific object safety).
  - `aborts_if !object::is_owner(agent, object_id) with E_UNAUTHORIZED_OBJECT_ACCESS`: Chỉ delete nếu agent own object.
  - `invariant object::exists(object_id) || deleted`: Object không bị delete unauthorized.
  - `ensures !object::exists(object_id) ==> old(object::owner(object_id)) == agent_address`: Chỉ agent mới delete được objects của nó.
  - Use case: Agent control Kiosk hoặc dynamic fields, nhưng không được rogue delete shared objects/treasury assets (link với capability misuse rules).

- **agent_shared_object_consistency.move**: Prove consistency trong multi-agent access shared objects (prevent race-like issues ở agentic workflows).
  - `invariant shared_vault.balance == sum(agent_contributions) - total_withdrawn`: Balance conserved sau multi-access.
  - `aborts_if version_mismatch(shared_object.version, expected_version) with E_VERSION_CONFLICT`: Abort nếu version không match (Sui object versioning).
  - `ensures shared_vault.balance_post == old(shared_vault.balance) - withdrawal_amount`: Withdraw đúng, no double-withdraw.
  - Use case: Multi-agent coordination (e.g., agent swarm access treasury vault), chống race condition ở parallel tx.

### Xử lý lỗi

- "Z3 not found": Thêm Z3 bin vào PATH, khởi động lại terminal.
- "Boogie error": Kiểm tra đã cài đặt .NET SDK chưa.
- Specs fail: Kiểm tra logic code hoặc spec có khớp với tài liệu Sui không (docs.sui.io/move/prover).
- Verbosity cao: Chỉnh Prover.toml verbosity = "High".

---
*Phát triển bởi DXD Labs.*
