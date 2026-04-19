# Contributing to DXD Audit Kit

Thank you for your interest in contributing to the DXD Audit Kit! This project is a community-driven repository of Sui Move security knowledge and verification tools.

## How to Contribute

### 1. Adding a New Vulnerability
To add a new vulnerability to the `vuln-db`, please follow these steps:
1.  **ID Allocation**: Check the existing IDs in `vuln-db/vulns/` and allocate the next sequential ID in the format `DXD-SUI-YYYY-XXX`.
2.  **YAML Entry**: Create a new `.yaml` file in `vuln-db/vulns/` using the template found in `docs/TRACEABILITY.md`.
3.  **PoC Implementation**: Create a corresponding Move module in `tests/sources/` that demonstrates the vulnerability and provides a fixed version.
4.  **Verification**: Run `./one-click-audit.sh` to ensure your PoC passes (and the vulnerable version fails as expected).

### 2. Improving Documentation
We welcome improvements to our guides, checklists, and READMEs. Please ensure you maintain the multi-lingual support (English, Vietnamese, Chinese) where applicable.

## Development Environment
- **Sui CLI**: 1.64.2 (Strict requirement for CI compatibility)
- **Python**: 3.10+
- **PyYAML**: Required for the vulnerability parser

## Workflow
1.  Fork the repository.
2.  Create a feature branch (`feat/new-vuln-id`).
3.  Commit your changes following [Conventional Commits](https://www.conventionalcommits.org/).
4.  Submit a Pull Request.

## Code of Conduct
Please be respectful and professional in all interactions. This project aims to be a safe space for security researchers to share knowledge.

---
*DXD Labs - Securing the Move Ecosystem*
