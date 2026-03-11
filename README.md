# DXDLABS – Smart Contract Security Audits

![GitHub stars](https://img.shields.io/github/stars/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub license](https://img.shields.io/github/license/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![Static Analysis](https://github.com/DXD-LABS/dxd-audit-kit-smartcontract/workflows/Move%20Static%20Analysis/badge.svg)

This repository contains public security audit reports produced by DXDLABS.

## Structure

- `templates/` – report templates in English, Vietnamese, and Chinese.
- `clients/<YYYY-MM>-<project-name>/` – audit reports for individual clients.
- `resources/move/` – Move/Sui security patterns, vulnerable samples, and checklists.
- `resources/move/tests/` – Move test suite for safe snippets.
- `tools/` – configuration and examples of analysis tools used (Slither, Foundry, etc.).
- `docs/` – professional audit services and additional documentation.
- `docs/usage-guide.md` – step-by-step install and usage guide.
- `scorecard/` – BVSS Security Scorecard Tool (CLI + interactive Web, integrates vuln-db & static-analysis).
- `vuln-db/` – YAML vulnerability database and parser.
- `tests/` – Move PoC modules and unit/integration tests for vuln-db.

## Vuln DB + PoC Tests

- Sui CLI pinned to `mainnet-v1.64.2` for reproducible results.
- Generate summary: `cd vuln-db && python parser.py`
- Run unit tests: `cd tests && sui move test`
- Run unit + testnet integration: `cd tests && ./run_tests.sh`
- Windows (MSYS2): install PyYAML with `pacman -S mingw-w64-x86_64-python-yaml`

- ## For AI Agents

This repository provides comprehensive resources for AI agents performing smart contract security audits. Follow these guidelines to ensure thorough and high-quality audits.

### Quick Start Guide

1. **Read Core Documents First**:
   - [AGENT_GUIDELINES.md](./AGENT_GUIDELINES.md) - Complete audit methodology and best practices
   - [SENIOR_AGENT_ARCHITECTURE.md](./SENIOR_AGENT_ARCHITECTURE.md) - System architecture and capabilities
   - [SENIOR_QUALITY_GATES.md](./SENIOR_QUALITY_GATES.md) - Quality checkpoints and metrics
   - [SENIOR_CONTEXT_MANAGEMENT.md](./SENIOR_CONTEXT_MANAGEMENT.md) - Context handling strategies

2. **Follow the Audit Workflow**:
   - Phase 1: Reconnaissance (20%) - Understand project scope and goals
   - Phase 2: Static Analysis (30%) - Identify code-level vulnerabilities
   - Phase 3: Business Logic (25%) - Analyze economic and logic flaws
   - Phase 4: Integration Testing (15%) - Test component interactions
   - Phase 5: Reporting (10%) - Document findings clearly

3. **Use Available Resources**:
   - `/resources/move/` - Move/Sui security patterns and vulnerabilities
   - `/resources/move/checklists/` - Audit checklists for different protocols
   - `/resources/move/safe/` - Secure coding patterns
   - `/resources/move/vulnerable/` - Vulnerable code examples
   - `/templates/` - Report templates

### Key Principles

✅ **Thoroughness**: Analyze 100% of in-scope code  
✅ **Context-Aware**: Understand business logic and economics  
✅ **Systematic**: Follow structured methodology consistently  
✅ **Documentation**: Record findings with clear evidence  

### Severity Classification

- **Critical**: Direct loss of funds, protocol insolvency
- **High**: Indirect loss of funds, significant exploitation
- **Medium**: Griefing attacks, temporary DoS
- **Low**: Best practice violations, gas inefficiencies
- **Informational**: Documentation issues, suggestions

### Common Vulnerabilities to Check

1. **Access Control**: Missing or improper permission checks
2. **Reentrancy**: External calls before state updates
3. **Integer Issues**: Overflow/underflow in calculations
4. **Unchecked Calls**: Ignoring return values
5. **Oracle Manipulation**: Price feed attacks
6. **Flash Loan Attacks**: Economic exploitation
7. **Centralization Risks**: Admin key abuse

### Quality Checklist

Before submitting findings:

```markdown
- [ ] All in-scope code reviewed
- [ ] Severity properly assessed
- [ ] PoC provided for critical/high issues
- [ ] Recommendations are actionable
- [ ] No false positives
- [ ] Report well-structured
- [ ] Code examples tested
```

### Tools and References

**Static Analysis**:
- Slither (Ethereum)
- Mythril (Ethereum)
- Move Prover (Move/Sui)

**Dynamic Testing**:
- Echidna (Fuzzing)
- Foundry (Testing)

**Standards**:
- OWASP Smart Contract Top 10
- ERC Standards
- Move Documentation

For detailed guidance, always refer to [AGENT_GUIDELINES.md](./AGENT_GUIDELINES.md).

## Professional Audit Services

DxDLabs – Specialist in Move/Sui & EVM smart contract audits in Vietnam.  
With experience auditing real projects (DeFi, NFT, BTCfi), we help protocols launch safely and avoid exploits.

For more details, please see our [Professional Audit Services](docs/professional-audit-services.md) page.

## Move/Sui Audit Resources

A collection of security patterns and common vulnerabilities for Sui Move.

### Safe Patterns (`resources/move/safe/`)
- `btcfi-mint-redeem-safe.move`: Secure pattern for BTCfi (Liquid BTC) on Sui.
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
