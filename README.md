# DXDLABS – Smart Contract Security Audits

This repository contains public security audit reports produced by DXDLABS.

## Structure

- `templates/` – report templates in English, Vietnamese, and Chinese.
- `clients/<YYYY-MM>-<project-name>/` – audit reports for individual clients.
- `resources/move/` – Move/Sui security patterns, vulnerable samples, and checklists.
- `tools/` – configuration and examples of analysis tools used (Slither, Foundry, etc.).

## Move/Sui Audit Resources

A collection of security patterns and common vulnerabilities for Sui Move.

### Safe Patterns (`resources/move/safe/`)
- `capability-safe.move`: Best practices for using Capabilities to control permissions.
- `coin-management-safe.move`: Secure patterns for handling Coins, splitting, and merging.
- `dynamic-fields-safe.move`: Safe usage of Dynamic Fields for flexible storage.
- `event-emitting-safe.move`: Proper event emission for off-chain indexing.
- `object-ownership-safe.move`: Ensuring clear object ownership and transfer logic.
- `shared-object-safe.move`: Secure management of Shared Objects and access control.

### Vulnerable Samples (`resources/move/vulnerable/`)
- `capability-abuse.move`: Example of permission bypass via public reference to Capabilities.
- `dos-expensive-loop.move`: Denial of Service vulnerability due to unbounded loops.
- `friend-module-overexposure.move`: Risks of over-exposing internal functions via `friend` modules.
- `missing-reinit-guard.move`: Security flaw where initialization functions can be called multiple times.
- `resource-leak.move`: Example of object ID leakage and storage bloat.

### Checklists (`resources/move/checklists/`)
- `move-audit-checklist.md`: Comprehensive checklist for auditing Sui Move smart contracts.

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
