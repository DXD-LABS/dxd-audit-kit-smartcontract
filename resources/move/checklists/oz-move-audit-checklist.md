# OpenZeppelin Move Audit Checklist (v0.1.0 - Feb 2025)

## Overview
This checklist focuses on security patterns specific to applications integrating the **OpenZeppelin Move** library.

---

## 1. Token (Coin) Standards
- [ ] **Minting Authority**: Verify that `TreasuryCap` (Sui) or equivalent Mint Capability is strictly guarded and not exposed via `public` or `entry` functions without `init` or `AdminCap` checks.
- [ ] **Metadata Immutability**: Ensure `CoinMetadata` is either frozen or its `UpdateCap` is held by a secure multisig/DAO.
- [ ] **Burn Verification**: Verify that burning tokens correctly reduces `total_supply` if using a supply tracker.
- [ ] **DenyList Implementation**: Check if `DenyCap` is used correctly to prevent malicious actors from interacting with the token (Sui-specific).

## 2. Resource Management
- [ ] **Phantom Type Safety**: (MS-010) Ensure all generic Coin-related structs use the `phantom` keyword for type parameters to prevent type substitution attacks.
- [ ] **Dynamic Field Leaks**: (MS-001) If using OZ-based account/vault extensions, ensure dynamic fields are extracted before deletion.
- [ ] **Intentional Freezing**: (MS-011) Verify that `public_freeze_object` is not called on any object that requires future upgrades.

## 3. Access Control
- [ ] **Capability Wrapping**: (MS-004) Audit any logic that wraps an OZ `AccessControl` capability into another object. Ensure the 'unwrapper' is properly authorized.
- [ ] **Entry Function Exposure**: (MS-012) Audit all `entry` functions. Ensure they are thin wrappers around internal logic and perform strict `TxContext` sender checks.
- [ ] **Multi-Sig Integration**: Ensure that high-privilege actions (upgrades, minting) are gated by a Multi-Sig (e.g., `sui::multisig`).

## 4. Arithmetic & Logic
- [ ] **Rounding Directions**: Verify that math operations (especially in DEX/Lending) follow OZ best practices (e.g., round up for debt, round down for collateral).
- [ ] **Bitwise Security**: (MS-005) If using bit-packing for gas optimization, verify the mask and shift boundaries.

## 5. Upgradeability
- [ ] **Package Versioning**: Ensure the contract checks its own version against a `VersionControl` object to prevent 'stale' contract calls after an upgrade.
- [ ] **Capability Migration**: Verify that new versions of the package can correctly consume Capabilities issued by the old version.

---
*Reference: OpenZeppelin Move Research Release (Feb 2025) & MoveScanner 2026.*
