/// Module: vuln::no_upgrade_guard
/// Description: 
/// EN: VULNERABILITY - No version check during upgrade allows package downgrade attacks.
/// VI: LỖ HỔNG - Không kiểm tra version khi upgrade cho phép tấn công hạ cấp package (downgrade).
/// ZH: 漏洞 - 升级期间没有版本检查，允许进行包降级攻击。

module vuln::no_upgrade_guard {
    use sui::package::UpgradeCap;

    public entry fun unsafe_upgrade(cap: &mut UpgradeCap, _version: u64) {
        // LỖ HỔNG/VULN: Attacker downgrades to old version → re-enable old exploits (降级攻击)
        // package::authorize_upgrade(cap, ...);
    }
}

// Fix:
// EN: Ensure the new version is strictly greater than the current version.
// VI: Đảm bảo version mới phải lớn hơn version hiện tại.
// ZH: 确保新版本严格大于当前版本。
// assert!(version > current_version, EInvalidVersion);