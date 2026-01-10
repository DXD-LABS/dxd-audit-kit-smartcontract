# DXDLABS – Smart Contract Security Audits

![GitHub stars](https://img.shields.io/github/stars/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub license](https://img.shields.io/github/license/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/DXD-LABS/dxd-audit-kit-smartcontract?style=flat-square)

This repository contains public security audit reports produced by DXDLABS.

## Structure

- `templates/` – report templates in English, Vietnamese, and Chinese.
- `clients/<YYYY-MM>-<project-name>/` – audit reports for individual clients.
- `resources/move/` – Move/Sui security patterns, vulnerable samples, and checklists.
- `tools/` – configuration and examples of analysis tools used (Slither, Foundry, etc.).

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

### Checklists (`resources/move/checklists/`)
- `move-audit-checklist.md`: Comprehensive checklist for auditing Sui Move smart contracts.
- `move-defi-checklist.md`: Specific checklist for DeFi (Flash Loan, Lending, DEX) and NFT/Kiosk.

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
