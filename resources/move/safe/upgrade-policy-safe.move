/// Module: safe::upgrade_policy
/// Description: Enforce upgrade policy cho package trên Sui | Enforce upgrade policy for packages on Sui | 在 Sui 上强制执行包的升级策略
/// Sử dụng UpgradeCap để kiểm soát việc nâng cấp | Use UpgradeCap to control upgrades | 使用 UpgradeCap 控制升级

module safe::upgrade_policy {
    use sui::package::{Self, UpgradeCap};
    use sui::tx_context::TxContext;

    /// Chỉ cho phép nâng cấp nếu tuân thủ chính sách (ví dụ: không cho phép downgrade)
    /// Only allow upgrades if policy is met (e.g., no downgrade allowed)
    /// 仅在符合策略的情况下允许升级（例如，不允许降级）
    public entry fun authorize_upgrade(
        cap: &mut UpgradeCap,
        policy: u8,
        digest: vector<u8>
    ) {
        // Enforce policy: 0 = Compatible, 1 = Additive, etc.
        // Mặc định Sui hỗ trợ các chính sách thông qua package::authorize_upgrade
        package::authorize_upgrade(cap, policy, digest);
    }

    /// Khóa package vĩnh viễn (Immutable) - Không thể nâng cấp nữa
    /// Lock package permanently (Immutable) - Cannot be upgraded anymore
    /// 永久锁定包（不可变）- 无法再升级
    public entry fun make_immutable(cap: UpgradeCap) {
        package::make_immutable(cap);
    }
}

// Best practice: Luôn quản lý UpgradeCap cẩn thận. Sử dụng Multisig cho AdminCap sở hữu UpgradeCap.
// Khóa package sau khi đã ổn định để tối đa hóa tính phi tập trung.
// Best practice: Always manage UpgradeCap carefully. Use Multisig for AdminCap owning UpgradeCap.
// Lock package after it's stable to maximize decentralization.
// 最佳实践：始终小心管理 UpgradeCap。对拥有 UpgradeCap 的 AdminCap 使用多重签名。
// 稳定后锁定包，以实现最大程度的去中心化。
