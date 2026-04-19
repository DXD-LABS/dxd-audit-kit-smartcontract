# DXDLABS – Smart Contract Security Audits

![GitHub stars](https://img.shields.io/github/stars/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub license](https://img.shields.io/github/license/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![Static Analysis](https://github.com/DXD-LABS/dxd-audit-kit-smartcontract/workflows/Move%20Static%20Analysis/badge.svg)
![Sui CLI](https://img.shields.io/badge/Sui%20CLI-1.64.2-blue?style=flat-square&logo=sui)

This repository contains public security audit reports produced by DXDLABS.

## North Star
A public-good security engine and the gold standard for Sui Move smart contract auditing, empowering developers with standardized secure patterns and automated verification tools.

## 5-minute Quickstart
### Prerequisites
- **Sui CLI**: Pinned to version `1.64.2` (Full compatibility).
- **Python 3.10+**: For `vuln-db` parsing and automation.

### Commands
#### Local Setup
```bash
git clone https://github.com/DXD-LABS/dxd-audit-kit-smartcontract.git
cd dxd-audit-kit-smartcontract
./one-click-audit.sh  # Checks environment, runs tests, and generates summary
```

#### Formal Verification (Docker - Recommended)
The gold standard for high-assurance audits. Run the full formal verification suite in a standardized environment:
```bash
docker build -t sui-audit-kit .
docker run --rm -v $(pwd):/repo sui-audit-kit /bin/bash -c "cd prover-examples && sui move prove"
```
*Total verification coverage: 10+ core security invariants (No double-spend, repayment enforcement, etc.)*

#### Local Setup
```bash
./one-click-audit.sh  # Basic unit tests and static analysis
```

#### Windows Native (PowerShell)
For a direct Windows experience without WSL/Docker:
1. Open PowerShell as **Administrator** and enable script execution (one-time):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. Run the audit:
   ```powershell
   ./one-click-audit.ps1
   ```

## Traceability & ID System
To ensure professional audit standards, every vulnerability in this repository is assigned a unique tracking ID: **`DXD-SUI-YYYY-XXX`**.

- **Source of Truth**: [master-list.json](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/vuln-db/master-list.json)
- **Specification**: [ID_SYSTEM.md](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/docs/ID_SYSTEM.md)

| ID | Category | Description |
| :--- | :--- | :--- |
| `DXD-SUI-2024-001` | ACC | BlueMove Access Bypass |
| `DXD-SUI-2026-001` | ORC | BTCfi Oracle Manipulation |

Refer to the `vuln-db/` summary reports for full details.

### Expected Output
```text
[+] Scan Complete: 0 vulnerabilities found in secure-patterns/
[+] Summary: 15/15 checks passed.
```

## Repo Map

### 🛡️ Security Standards
- `secure-patterns/` – Research-based Sui design patterns (2025-2026).
- `resources/move/safe/` – Snippets for secure coin management, kiosks, and capabilities.

### 🔍 Audit Artifacts
- `vuln-db/` – Machine-readable vulnerability database (YAML).
- `tests/` – Move PoC modules for security invariant testing.
- `clients/` – Public audit reports for transparency.
- `templates/` – Professional audit report templates (EN/VI/ZH).

### 🛠️ Developer Tooling
- `scorecard/` – BVSS Security Scorecard tool (CLI + Web).
- `prover-examples/` – Formal verification examples using Move Prover.
- `scripts/` – Infrastructure and environment management.
- `vuln-db/` – Automated registry with links to formal proofs.

## Who is this for?

| Persona | Benefit | Recommended Start |
| :--- | :--- | :--- |
| **Builder** | Prevention of common vulnerabilities | [Secure Patterns](./secure-patterns/) |
| **Auditor** | Standardized workflow & templates | [Vuln DB](./vuln-db/) & [Tests](./tests/) |
| **Contributor** | Adding to the public good knowledge base | [CONTRIBUTING.md](./CONTRIBUTING.md) |

## What this repo is / is not
- **It is**: A curated security knowledge base, a gold-standard collection of audit reports, and a suite of secure design patterns for Sui Move.
- **It is not**: A replacement for professional security audits, a general-purpose Move tutorial, or a dumping ground for unverified code.

## Vuln DB + PoC Tests

- Sui CLI pinned to `mainnet-v1.64.2` for reproducible results.
- Generate summary: `cd vuln-db && python parser.py`
- Run unit tests: `cd tests && sui move test`
- Run unit + testnet integration: `cd tests && ./run_tests.sh`
- Windows (MSYS2): install PyYAML with `pacman -S mingw-w64-x86_64-python-yaml`

## 🤖 For AI Agents
This repository is optimized for AI-driven security analysis. For detailed instructions on methodology, tools, and quality gates, see the [AI Agent Security Audit Guide](./docs/AI_AGENT_GUIDE.md).

## Professional Audit Services

DxDLabs – Specialist in Move/Sui & EVM smart contract audits in Vietnam.  
With experience auditing real projects (DeFi, NFT, BTCfi), we help protocols launch safely and avoid exploits.

For more details, please see our [Professional Audit Services](docs/professional-audit-services.md) page.

## Move/Sui Audit Resources

A collection of security patterns and common vulnerabilities for Sui Move.

### Pattern An toàn (`resources/move/safe/`)

- `btcfi-mint-redeem-safe.move`: Pattern an toàn cho BTCfi (Liquid BTC) trên Sui.
- `capability-safe.move`: Best practices for using Capabilities to control permissions.
- `coin-management-safe.move`: Secure patterns for handling Coins, splitting, and merging.
- `coin-split-merge-safe.move`: Safe pattern for split/merge Coin in Sui.
- `dynamic-field-upgrade-safe.move`: Safe pattern using Dynamic Fields for upgrades.
- `dynamic-fields-safe.move`: Safe usage of Dynamic Fields for flexible storage.
- `event-emitting-safe.move`: Proper event emission for off-chain indexing.
- `flash-loan-hot-potato-safe.move`: Safe pattern for Flash Loan (Hot Potato) on Sui.
- `kiosk-pattern-safe.move`: Secure Kiosk pattern for NFT management and marketplaces.
- `nft-kiosk-listing-safe.move`: Safe pattern for listing NFTs on Kiosk (marketplace).
- `object-ownership-safe.move`: Ensuring clear object ownership and transfer logic.
- `oracle-integration-safe.move`: Best practices for secure oracle price integration and staleness checks.
- `package-upgrade-safe.move`: Secure package upgrade pattern with version control.
- `shared-object-safe.move`: Secure management of Shared Objects and access control.
- `upgrade-policy-safe.move`: Enforce policy during package upgrade.

### Vulnerable Samples (`resources/move/vulnerable/`)

- `btcfi-balance-overflow.move`: Custom balance logic leading to overflow/underflow vulnerabilities.
- `capability-abuse.move`: Example of permission bypass via public reference to Capabilities.
- `coin-overflow-merge.move`: Custom balance merge leading to u64 overflow.
- `dos-expensive-loop.move`: Denial of Service vulnerability due to unbounded loops.
- `dynamic-field-upgrade-abuse.move`: Dynamic field overwrite without version check.
- `flash-loan-hot-potato-abuse.move`: Flash loan without proper repayment/destruction enforcement.
- `friend-module-overexposure.move`: Risks of over-exposing internal functions via `friend` modules.
- `kiosk-withdraw-abuse.move`: Vulnerability where Kiosk lacks ownership checks for withdrawals.
- `missing-reinit-guard.move`: Security flaw where initialization functions can be called multiple times.
- `nft-kiosk-listing-abuse.move`: Listing NFT without policy, bypassing royalty fees.
- `oracle-stale-price.move`: Vulnerability using old oracle prices for manipulation.
- `package-downgrade-attack.move`: Risk of package downgrade due to missing version checks.
- `resource-leak.move`: Example of object ID leakage and storage bloat.

### Upgrade & Migration (`resources/move/upgrade-migration/`)
- `package-upgrade-best-practices.md` ([Multi](resources/move/upgrade-migration/package-upgrade-best-practices.md)): Best practices for secure package upgrades and versioning.
- `solidity-to-move-migration-guide.md` ([Multi](resources/move/upgrade-migration/solidity-to-move-migration-guide.md)): Essential tips for EVM developers migrating to Move/Sui.

### Migration & Upgrade Pitfalls (`resources/move/migration-upgrade/`)
- `solidity-to-move-migration-pitfalls.md` ([Multi](resources/move/migration-upgrade/solidity-to-move-migration-pitfalls.md)): Common mistakes when migrating from Solidity to Move.
- `package-upgrade-pitfalls.md` ([Multi](resources/move/migration-upgrade/package-upgrade-pitfalls.md)): Common pitfalls during Move package upgrades.

### Checklists (`resources/move/checklists/`)
- `move-audit-checklist.md`: Comprehensive checklist for auditing Sui Move smart contracts.
- `move-defi-checklist.md`: Specific checklist for DeFi (Flash Loan, Lending, DEX) and NFT/Kiosk.
- `move-btcfi-checklist.md` ([Multi](resources/move/checklists/move-btcfi-checklist.md)): Security checklist for BTCfi (Liquid BTC) protocols.
- `move-btcfi-edge-cases.md` ([Multi](resources/move/checklists/move-btcfi-edge-cases.md)): Edge cases checklist for BTCfi on Sui.
- `quick-audit-template.md` ([Multi](resources/move/checklists/quick-audit-template.md)): Fast audit template for daily use (5-10 mins).

### Audit Reports & Best Practices (`resources/move/`)
- `sui-dev-resource-hub.md` ([Multi](resources/move/sui-dev-resource-hub.md)): Curated collection of essential resources for Sui developers.

### Sui Secure Design Patterns
- [Capability Pattern](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/resources/move/sui-patterns/capability-witness-pattern.md)
- [Object-Centric Design](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/resources/move/sui-patterns/object-centric-pattern.md)
- [Emergency & Time Patterns](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/resources/move/sui-patterns/emergency-time-patterns.md)
- [Upgrade & Archival Patterns](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/resources/move/sui-patterns/upgrade-archival-patterns.md)

### Research-Based Sui Design Patterns (2025-2026) (`secure-patterns/`)
- **[Access Control](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_access_control.yaml)**: Fine-grained permissions via capabilities.
- **[Time Incentivization](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_time_incentivization.yaml)**: Time-based rewards using `sui::clock`.
- **[Escapability](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_escapability.yaml)**: Guaranteed user exit mechanisms.
- **[Transaction Blocks](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_transaction_blocks.yaml)**: Atomic multi-step operations.
- **[Gas Storage Fund](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_gas_fund.yaml)**: Managing liveness for shared objects.
- **[Witness Pattern](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/secure-patterns/patterns/pattern_witness.yaml)**: Type-safe generic constraints.

### Sui Developer Resources
- **[Sui Developer Resources 2025-2026](file:///d:/DXD%20LABS/dxdlabs-audit-smartcontract/resources/sui-resources.md)**: Curated list of docs, videos, and communities.
- `report-examples/example-move-lending-audit-report.md` ([Multi](resources/move/report-examples/example-move-lending-audit-report.md)): Example audit report for a lending protocol on Sui.
- `security-scorecard-template.md` ([Multi](resources/move/security-scorecard-template.md)): Template for summarizing audit findings with scoring.
- `weekly-security-tip-teaser.md` ([Multi](resources/move/weekly-security-tip-teaser.md)): Upcoming weekly security tips for Move/Sui.
- `best-practices-summary.md` ([Multi](resources/move/best-practices-summary.md)): Quick summary of security best practices for Move/Sui.
- `one-liner-tips.md` ([Multi](resources/move/one-liner-tips.md)): Viral security tips for Move/Sui developers and auditors.

### Audit Tools & Scripts (`resources/move/tools-scripts/`)
- `run-move-audit.sh`: Quick bash script to run Sui Move analyzer and tests.
- `one-click-audit.sh`: One-click audit starter script for Move/Sui.
- `generate-report-template.py`: Python script to auto-fill audit report templates from findings.

### Tests (`resources/move/tests/`)
- `safe-snippets-tests.move`: Move tests for hot safe snippets (capability, flash loan, kiosk).

### Real-World Audit Cases (`resources/move/real-cases/`)
- `cetus-clmm-pool-vuln-2025.md` ([Multi](resources/move/real-cases/cetus-clmm-pool-vuln-2025.md)): Spoof-token exploit in pricing logic (Cetus 2025).
- `nemo-pricing-logic-vuln.md` ([Multi](resources/move/real-cases/nemo-pricing-logic-vuln.md)): Pricing logic exploit in USDC pool (Nemo 2025).
- `cross-chain-token-compat.md` ([Multi](resources/move/real-cases/cross-chain-token-compat.md)): Cross-chain token compatibility vulnerability (Sui 2024).
- `amm-rounding-error-exploit.md` ([Multi](resources/move/real-cases/amm-rounding-error-exploit.md)): AMM rounding error manipulation (Sui 2025).
- `navi-health-factor-manip.md` ([Multi](resources/move/real-cases/navi-health-factor-manip.md)): Health factor manipulation via oracle staleness (NAVI).
- `scallop-isolation-bypass.md` ([Multi](resources/move/real-cases/scallop-isolation-bypass.md)): Isolation mode bypass in lending protocols (Scallop).

### Move Prover Examples (`prover-examples/`)

Hands-on examples for Move Prover formal verification using MSL specs.

- **Basics**: safe_transfer (no double-spend), no_double_spend (balance invariant).
- **DeFi**: flash_loan_safe (repayment enforced), lending_collateral (over-collateralized), oracle_safe (price freshness).
- Dual-language guides (VN/EN/ZH): Setup Sui CLI/Z3/Boogie, run `sui move prove`.
- GitHub Actions CI: Auto-verify on PRs.

See [prover-examples/README.md](./prover-examples/README.md).

### 💎 Verified Patterns (High-Assurance)
Our "Verified Patterns" methodology bridges the gap between identified vulnerabilities and production-ready code. Every **Critical** vulnerability in our registry is prioritized for formal verification.

Current Verified Patterns:
- **AGENT-001 (Unauthorized Tool Call)**: [Verified Move Proof](prover-examples/sources/agent_unauthorized_tool_prevent.move)
- **AGENT-002 (Spend Limit Bypass)**: [Verified Move Proof](prover-examples/sources/agent_spend_limit_enforce.move)
- **AGENT-003 (Permission Abuse)**: [Verified Move Proof](prover-examples/sources/agent_policy_guard.move)
- **DeFi Guard**: [Safe Transfer Proof](prover-examples/sources/safe_transfer.move)

## Report Format

Each report follows the same structure:

1. Overview (project, scope, commit hash, networks).
2. Executive Summary (risk table, key findings).
3. Methodology.
4. Risk Classification.
5. Summary of Findings.
6. Detailed Findings.
7. Code Quality & Best Practices.
8. Appendix (environment, tools, test summary).

See `templates/report-template.en.md` for details.
