# Solidity → Move Migration Pitfalls (Sui) – Những lỗi dev EVM hay mắc phải | Solidity → Move Migration Pitfalls (Sui) – Common mistakes for EVM developers | Solidity → Move 迁移陷阱 (Sui) – EVM 开发者常犯的错误

Dev từ EVM sang Move thường "copy pattern cũ" → tạo vuln lớn. Dưới đây là top pitfalls + fix (khó kiếm guide chi tiết): | Developers moving from EVM to Move often "copy old patterns" → creating major vulnerabilities. Here are the top pitfalls + fixes (detailed guides are hard to find): | 从 EVM 转向 Move 的开发者经常“复制旧模式” → 导致重大漏洞。以下是主要的陷阱 + 修复方法（详细指南很难找到）：

1. **Reentrancy mindset** | **重入心态**
   - Solidity: Reentrancy classic (Checks-Effects-Interactions).
   - Move: Không có reentrancy do object ownership → nhưng dễ tạo **capability abuse** hoặc **hot potato leak**. | Move: No classic reentrancy due to object ownership → but easy to create **capability abuse** or **hot potato leak**. | Move：由于对象所有权机制，没有传统的重入攻击 → 但容易产生 **权能滥用 (capability abuse)** 或 **热土豆泄漏 (hot potato leak)**。
   - Fix: Luôn dùng ownership (AdminCap has key), không public borrow. Xem: `capability-safe.move`. | Fix: Always use ownership (`AdminCap` has `key`), do not borrow publicly. See: `capability-safe.move`. | 修复：始终使用所有权（`AdminCap` 具有 `key`），不要公开借用。参见：`capability-safe.move`。

2. **Storage slot → Object UID** | **存储插槽 → 对象 UID**
   - Solidity: Storage slot fixed → dễ collision khi upgrade. | Solidity: Fixed storage slots → easy to have collisions during upgrades. | Solidity：固定存储插槽 → 升级时容易发生冲突。
   - Move: Object UID unique → nhưng dev hay quên delete object cũ → storage bloat. | Move: Unique Object UID → but developers often forget to delete old objects → storage bloat. | Move：唯一的对象 UID → 但开发者经常忘记删除旧对象 → 导致存储膨胀。
   - Fix: Luôn `object::delete` khi không cần. Xem: `resource-leak.move`. | Fix: Always use `object::delete` when not needed. See: `resource-leak.move`. | 修复：不需要时始终使用 `object::delete`。参见：`resource-leak.move`。

3. **Proxy upgrade → Package upgrade** | **代理升级 → 包升级**
   - Solidity: Proxy + implementation slot.
   - Move: Package upgrade với UpgradeCap → dễ downgrade attack nếu không version guard. | Move: Package upgrade with `UpgradeCap` → prone to downgrade attacks without version guards. | Move：使用 `UpgradeCap` 进行包升级 → 如果没有版本保护，容易受到降级攻击。
   - Fix: Assert version tăng dần. Xem: `package-upgrade-safe.move`. | Fix: Assert incrementing versions. See: `package-upgrade-safe.move`. | 修复：断言版本递增。参见：`package-upgrade-safe.move`。

4. **ERC20/721 → Coin<T> & Kiosk**
   - Solidity: Custom balance/approve.
   - Move: Coin<T> built-in check → nhưng dev hay custom balance → overflow. | Move: `Coin<T>` built-in checks → but developers often use custom balances → overflow. | Move：`Coin<T>` 内置检查 → 但开发者经常使用自定义余额 → 导致溢出。
   - Fix: Dùng `Coin<T>` + `Balance<T>`. Xem: `coin-management-safe.move` & `kiosk-pattern-safe.move`. | Fix: Use `Coin<T>` + `Balance<T>`. See: `coin-management-safe.move` & `kiosk-pattern-safe.move`. | 修复：使用 `Coin<T>` + `Balance<T>`。参见：`coin-management-safe.move` 和 `kiosk-pattern-safe.move`。

**Tip**: Khi migrate, bắt đầu bằng capability pattern – tránh copy logic EVM cũ. | **Tip**: When migrating, start with the capability pattern – avoid copying old EVM logic. | **提示**：迁移时，从权能模式开始 —— 避免复制旧的 EVM 逻辑。
