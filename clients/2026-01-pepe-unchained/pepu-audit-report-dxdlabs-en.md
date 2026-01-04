# DXDLABS – Smart Contract Security Audit Report

> **Version:** 1.2 (Internal Source Code Review Token.sol)  
> **Languages:** English / Vietnamese / Chinese (Simplified)

---

### Update Note (2026-01-04)
Version 1.2 is based on the `Token.sol` source code provided by the client. Compared to the previously audited version on Etherscan, this source code has **completely removed the tax logic** and sensitive governance functions such as `setTax` and `openTrading`. This significantly reduces the Honeypot risk for investors.

---

### 1. Overview

- **Project name:** Pepe Unchained (PEPU)  
- **Client:** Pepe Unchained Team  
- **Repository / Source Code:** Internal `Token.sol` file.
- **Audit date:** 2026-01-04  
- **Auditors:** DXDLABS

**Scope:**

- **Networks:** Ethereum Mainnet
- **Contracts / folders reviewed:**
    - `Token.sol`
- **Out of scope:**
    - Off-chain services.

---

### 2. Executive Summary

- **Overall assessment:** PASSED (High logic security for token)
- **Risk summary:**

| Severity | Count |
| :--- | :--- |
| Critical | 0 |
| High | 0 |
| Medium | 0 |
| Low | 1 |
| Informational | 2 |

- **Key observations:**
    - **Major Improvement:** Tax logic has been removed. The current contract is a standard ERC20 token, transparent, and without hidden sell-blocking or transaction fee mechanisms.
    - **Fixed Supply:** All 8 billion tokens are minted once in the constructor to reserve wallets. No minting function exists after deployment.
    - **Ownership:** Still uses `Ownable`, but power functions have been reduced, primarily limited to managing contract ownership.
    - **Code Quality:** Custom ERC20 implementation (not directly using OpenZeppelin libraries) but strictly follows the EIP-20 standard.

---

### 3. Methodology

DXDLABS used a combination of automated tooling and manual review:

- **Architecture & design review:**
    - Review of ERC20 implementation and initial token allocation mechanism.
- **Static analysis:**
    - Tools: Slither.
- **Manual line-by-line review:**
    - Checked `_transfer`, `_mint`, `_burn` logic and supply distribution.

---

### 4. Risk Classification

DXDLABS uses the following severity levels:

- **Critical:** Direct loss of funds or protocol control.
- **High:** Significant financial or functional impact.
- **Medium:** Limited financial or functional impact.
- **Low:** Minor issues, old version, gas inefficiencies.
- **Informational:** Best practices, clarity, or maintainability.

---

### 5. Summary of Findings

| ID | Severity | Title | Status |
| :--- | :--- | :--- | :--- |
| DXD-01 | Low | Using Outdated Solidity Version (0.8.9) | Unresolved |
| DXD-02 | Informational | Hardcoded Wallet Addresses in Constructor | Unresolved |
| DXD-03 | Informational | Missing receive/fallback function for ETH | Unresolved |

---

### 6. Detailed Findings

#### DXD-01 – Using Outdated Solidity Version (Low)

**Status:** Unresolved

**Description:**  
The contract uses `pragma solidity 0.8.9`. While the 0.8.x version integrates overflow checks, version 0.8.9 was released a long time ago and lacks minor optimization and security fixes available in newer versions.

**Impact:**  
Low risk, primarily related to not benefiting from gas and security improvements in newer compilers (such as 0.8.26+).

**Recommendation:**  
Update to the latest Solidity version (e.g., 0.8.26 or 0.8.28) to ensure maximum compatibility and security.

---

#### DXD-02 – Hardcoded Wallet Addresses in Constructor (Informational)

**Status:** Unresolved

**Description:**  
The reserve token recipient addresses (presale, staking, etc.) are hardcoded directly in the constructor.

**Impact:**  
Reduces flexibility. If there is an error in the wallet address or a need to change the wallet just before deployment, the source code must be modified and recompiled.

**Recommendation:**  
These addresses should be passed as parameters to the constructor during deployment.

---

#### DXD-03 – Missing receive/fallback function for ETH (Informational)

**Status:** Unresolved

**Description:**  
The contract does not have a `receive()` or `fallback()` function to accept ETH. If someone accidentally sends ETH to the contract address, the transaction will revert.

**Impact:**  
This is actually a security feature to prevent ETH from being stuck, but in some cases, it can be confusing for users.

**Recommendation:**  
Maintain the current state if there is no intention to receive ETH, or add a function to handle it if necessary.

---

### 7. Code Quality & Best Practices

- **Standard Compliance:** ERC20 implementation is very clean and readable.
- **Gas Optimization:** Using `unchecked` in balance reduction functions is a good practice to save gas.
- **Supply Security:** Minting the total supply in the constructor ensures no one can create additional tokens unintentionally.

---

### 8. Smart Investor's Perspective

From an investment perspective, this `Token.sol` version provides much more peace of mind than typical meme token versions:

1.  **No Hidden Fees:** The complete removal of the tax mechanism (0% Buy/Sell Tax) is a testament to fairness. Investors do not have to worry about "set tax 100%" or exorbitant transaction fees.
2.  **Transparent Allocation:** Hardcoding reserve wallet addresses makes it easy for investors to verify the unlock or movement schedule of these funds on the blockchain from the start.
3.  **Lean Contract:** Fewer management functions mean fewer "traps." This is a pure token serving the Pepe Unchained ecosystem.
4.  **Advice:** Although the code is safe, investors should still monitor wallets holding large amounts of tokens (marketing, liquidity reserves) to understand the team's sell-off roadmap.

---

### 9. Appendix

**Environment:**

- **Compiler:** Solidity 0.8.9
- **EVM version:** London / Paris

**Tools used:**

- Slither, Manual Review.
