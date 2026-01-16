# Solidity → Move Migration Guide (Sui) – Tips cho dev EVM | Solidity → Move Migration Guide (Sui) – Tips for EVM Devs | Solidity → Move 迁移指南 (Sui) – EVM 开发者提示

1. **Ownership**: Solidity `owner` → Move capability (`AdminCap has key`). | Solidity `owner` → Move capability (`AdminCap has key`). | Solidity `owner` → Move capability (`AdminCap has key`)。
2. **Reentrancy**: Không có reentrancy classic ở Move → thay bằng capability abuse. | No classic reentrancy in Move → replaced by capability abuse. | Move 中没有传统的重入漏洞 → 取而代之的是权能滥用 (capability abuse)。
3. **Storage**: Solidity storage slot → Move object `UID` + `dynamic_field`. | Solidity storage slot → Move object `UID` + `dynamic_field`. | Solidity 存储槽 → Move 对象 `UID` + `dynamic_field`。
4. **Upgrade**: Solidity proxy → Move package upgrade với `UpgradeCap`. | Solidity proxy → Move package upgrade with `UpgradeCap`. | Solidity 代理 → 使用 `UpgradeCap` 的 Move 包升级。
5. **Token**: ERC20 → `Coin<T>` + `Balance<T>` (built-in check overflow). | ERC20 → `Coin<T>` + `Balance<T>` (built-in overflow checks). | ERC20 → `Coin<T>` + `Balance<T>`（内置溢出检查）。
6. **NFT**: ERC721 → Kiosk + TransferPolicy (royalty enforced). | ERC721 → Kiosk + TransferPolicy (royalty enforced). | ERC721 → Kiosk + TransferPolicy（强制执行版税）。

**Common pitfall**: Dev EVM hay copy pattern cũ → tạo vuln capability leak. | **Common pitfall**: EVM devs often copy old patterns → creating capability leak vulnerabilities. | **常见陷阱**：EVM 开发者经常复制旧模式 → 导致权能泄漏漏洞。
Tham khảo snippets trong repo để migrate an toàn! | Refer to the snippets in this repo for a safe migration! | 参考此仓库中的代码片段进行安全迁移！
