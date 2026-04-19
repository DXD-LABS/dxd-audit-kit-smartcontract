# Changelog

All notable changes to the DXD Audit Kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-04-14

### Added
- **Core Strategy**: Defined the "North Star" mission (Public Good security infrastructure).
- **Automation**: Root-level `one-click-audit.sh` for environment validation and test execution.
- **Toolchain Pinning**: Environment check script `scripts/check-env.sh` (Sui 1.64.2).
- **Vulnerability Database**:
  - Implemented `DXD-SUI-YYYY-XXX` ID format.
  - Added 5 real-world hack cases:
    - 1. BlueMove Access Bypass (DXD-SUI-2024-001)
    - 2. Souffl3 Math Logic Error (DXD-SUI-2024-002)
    - 3. Fake Token Spoofing (DXD-SUI-2024-003)
    - 4. Typus Dynamic Field Collision (DXD-SUI-2024-004)
    - 5. Upgrade Migration Corruption (DXD-SUI-2024-005)
- **Traceability**: `docs/TRACEABILITY.md` defines mapping from DB -> PoC -> Checklist.
- **Governance**: Added `CONTRIBUTING.md`, `SECURITY.md`, and optimized `ci.yml`.
- **Badge Support**: Added CI status badge to `README.md`.

### Changed
- Standardized `README.md` with 5-minute Quickstart and Repo Map.
- Updated CI workflow to use pre-built Sui binaries for faster execution.

---
*DXD Labs - Public Good Grant Proposal Ready*
