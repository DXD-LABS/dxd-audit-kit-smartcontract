/// Module: vuln::friend_overexposure
/// VI: Ví dụ LỖI – Friend module quá rộng
/// EN: VULNERABILITY Example – Overexposed friend modules
/// ZH: 漏洞示例 – Friend 模块范围过大

module vuln::core {
    friend vuln::anyone;  // VI: LỖ HỔNG: Friend bất kỳ module nào → overexposure | EN: VULNERABILITY: Friend to any module → overexposure | ZH: 漏洞：Friend 任何模块 → 过度暴露

    public(friend) fun sensitive_action() {
        // VI: Logic nhạy cảm (mint, withdraw...)
        // EN: Sensitive logic (mint, withdraw...)
        // ZH: 敏感逻辑（铸造、提取...）
    }
}

module vuln::anyone {
    use vuln::core;

    public entry fun exploit() {
        core::sensitive_action();  // VI: Bất kỳ ai deploy module friend này là exploit được | EN: Anyone deploying this friend module can exploit it | ZH: 任何部署此 friend 模块的人都可以利用它
    }
}

// VI: Risk: Critical – Complete permission bypass
// EN: Risk: Critical – Complete permission bypass
// ZH: 风险：严重 – 完全权限绕过

// VI: Fix:
// EN: Fix:
// ZH: 修复：
// - VI: Chỉ friend các module cụ thể, trusted.
//   EN: Only friend specific, trusted modules.
//   ZH: 仅将特定的、受信任的模块设为 friend。
// - VI: Hoặc dùng capability thay friend.
//   EN: Or use capabilities instead of friends.
//   ZH: 或者使用 capability 代替 friend。