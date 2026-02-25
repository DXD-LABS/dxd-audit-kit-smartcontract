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

### Troubleshooting
- "Z3 not found": Add Z3 bin to PATH, restart terminal.
- "Boogie error": Check .NET SDK installed.
- Failing specs: Review code logic or spec match Sui docs (docs.sui.io/move/prover).
- Debug: Edit Prover.toml verbosity = "High" or auto_trace_level = "AllCalls".

---
*Developed by DXD Labs.*
