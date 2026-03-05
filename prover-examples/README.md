# Move Prover Examples

Practical examples for Move Prover formal verification using MSL (Move Specification Language).

## Setup & Run Guide

### Prerequisites

- **Sui CLI**: `cargo install --locked sui --git https://github.com/MystenLabs/sui.git`
- **Z3 Solver**:
  - Ubuntu: `sudo apt update && sudo apt install z3 libz3-dev`
  - Mac: `brew install z3`
  - Windows: Download from Microsoft Z3 GitHub releases, add bin directory to PATH
- **Boogie**: `dotnet tool install -g boogie` (requires .NET SDK)

### Run Prover

```bash
cd prover-examples
sui move prove
```

All specs should verify OK.

### Examples

- **safe_transfer.move**: Safe coin transfer verification, aborts on insufficient balance, no double-spend (old balance = new + amount transferred).
- **no_double_spend.move**: Balance invariant >=0, safe withdraw.
- **flash_loan_safe.move**: Verify flash loan repayment enforced (DeepBook-style, hot potato destroyed if repaid).
- **lending_collateral.move**: Borrow only if over-collateralized 150%, no under-collateral invariant.
- **oracle_safe.move**: Oracle price freshness check (aborts if timestamp stale > max_age).
- **no_double_spend_transfer.move**: No double-spend coin transfer (aborts insufficient balance, sender balance -= amount, recipient += amount, total conserve invariant).
- **liquidation_safe.move**: Safe liquidation check (needs_liquidation true only under-collateral >120%, aborts liquidate healthy position).
- **oracle_deviation_safe.move**: Oracle freshness + deviation check (aborts stale >300s or deviation >5%).

### AI-Agent Specific Examples

Examples for proving invariants critical to AI agent security on Sui (agent wallets, machine transactions):

- **agent_spend_limit_enforce.move**: Prove strict cumulative spend limit cho agent wallet (prevent rogue or poisoned spends).
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

- **agent_owned_receipt.move**: Prove secure isolation in Owned Object receipts vs Shared Object congestion (derived from Navi Protocol audit).
  - `ensures receipt.deposited_amount == old(receipt.deposited_amount) + amount`: Safe state modification isolated to user.
  - `ensures receipt.owner == old(receipt.owner)`: Receipt ownership immutable.
  - `aborts_if receipt.deposited_amount + amount > MAX_U64`: Prevent overflow.
  - Use case: High-frequency Agent DeFi actions avoiding global shared object congestion by using owned receipts for accounting.

### Troubleshooting

- "Z3 not found": Add Z3 bin to PATH, restart terminal.
- "Boogie error": Check .NET SDK installed.
- Failing specs: Review code logic or spec match Sui docs (docs.sui.io/move/prover).
- Debug: Edit Prover.toml verbosity = "High" or auto_trace_level = "AllCalls".

---
*Developed by DXD Labs.*
