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

- **agent_owned_receipt.move**: Chứng minh cô lập an toàn trong Owned Object receipts vs Shared Object congestion.
  - `ensures receipt.deposited_amount == old(receipt.deposited_amount) + amount`: Sửa đổi state an toàn, tách biệt với user.
  - `ensures receipt.owner == old(receipt.owner)`: Quyền sở hữu receipt không thay đổi.
  - `aborts_if receipt.deposited_amount + amount > MAX_U64`: Ngăn overflow.
  - Use case: AI Agent DeFi tần suất cao tránh tắc nghẽn shared object bằng owned receipts.

### Nautilus TEE Attestation Specs

Specs chứng minh hình thức cho các pattern TEE (Trusted Execution Environment) trên Sui / Nautilus:

- **nautilus_tee_attest.move**: Chứng minh cổng attestation on-chain — chỉ thực thi khi TEE quote hợp lệ, còn mới và khớp với input hash đã cam kết.
  - `aborts_if !report.is_valid with E_ATTESTATION_FAIL`: Hủy nếu attestation không hợp lệ về mặt mật mã.
  - `aborts_if current_epoch - report.issued_epoch > MAX_STALE_EPOCHS with E_STALE_ATTESTATION`: Bắt buộc khung thời gian còn mới (1 epoch).
  - `aborts_if report.report_data != request.input_hash with E_HASH_MISMATCH`: Bằng chứng phải chứng thực đúng input đã cam kết.
  - `ensures result.attested == true`: Kết quả chỉ được tạo ra với attestation hợp lệ.
  - Use case: Mọi protocol dùng Nautilus TEE cho tính toán off-chain với bằng chứng on-chain.

- **nautilus_computation_integrity.move**: Chứng minh việc mint receipt được kiểm soát bởi TEE hash và không bị double-mint.
  - `aborts_if commit.tee_hash != commit.input_hash with E_INTEGRITY_FAIL`: TEE phải chứng thực tính toán đúng.
  - `aborts_if table::spec_contains(registry, input_hash) with E_ALREADY_MINTED`: Ngăn double receipt.
  - `ensures table::spec_len(registry) == old(table::spec_len(registry)) + 1`: Registry tăng đúng 1 entry.
  - `invariant verified == true`: Object Receipt chỉ tồn tại nếu đã được chứng thực.
  - Use case: On-chain mint/unlock được kiểm soát bởi Nautilus off-chain compute proof.

```bash
# Audit TEE patterns qua unified CLI
python -m cli tee attest --module my_tee_module
python -m cli tee vectors
python -m cli prove --module nautilus_tee_attest --link-vulns
```

### zk-Intent Verification Specs

Specs chứng minh hình thức cho các pattern xác minh zero-knowledge intent:

- **zk_intent_verify.move**: Chứng minh thứ tự commit-rồi-execute với cổng zk-proof.
  - `aborts_if !commitment.committed with E_NOT_COMMITTED`: Cam kết phải có trước khi thực thi.
  - `aborts_if !proof.is_valid with E_PROOF_INVALID`: zk-proof phải được xác minh on-chain.
  - `aborts_if proof.intent_hash != commitment.commitment_hash with E_HASH_MISMATCH`: Bằng chứng phải khớp với cam kết.
  - `ensures commitment.commitment_hash == old(commitment.commitment_hash)`: Cam kết không thay đổi trong lúc execute.
  - Use case: Xác minh intent của agent — intent được cam kết off-chain và chứng minh on-chain trước khi thực thi.

- **zk_nullifier_uniqueness.move**: Chứng minh nullifier registry chỉ được append — không thể replay bằng chứng.
  - `aborts_if table::spec_contains(registry, nullifier) with E_DOUBLE_SPEND`: Từ chối bằng chứng bị replay.
  - `ensures table::spec_len(registry) == old(table::spec_len(registry)) + 1`: Chỉ tăng trưởng (append-only).
  - `forall nf: old(contains(nf)) ==> contains(nf)`: Nullifier hiện có không bao giờ bị xóa.
  - `invariant count == table::spec_len(registry)`: Count nhất quán với table.
  - Use case: Các protocol zk-intent cần bảo vệ replay (ngăn thực thi hai lần).

```bash
# Audit zk-intent patterns qua unified CLI
python -m cli zk verify-intent --module my_intent_module
python -m cli zk nullifier-check
python -m cli prove --module zk_nullifier_uniqueness --link-vulns
```

### Xử lý lỗi

- "Z3 not found": Thêm Z3 bin vào PATH, khởi động lại terminal.
- "Boogie error": Kiểm tra đã cài đặt .NET SDK chưa.
- Specs fail: Kiểm tra logic code hoặc spec có khớp với tài liệu Sui không (docs.sui.io/move/prover).
- Verbosity cao: Chỉnh Prover.toml verbosity = "High".

---
*Phát triển bởi DXD Labs.*
