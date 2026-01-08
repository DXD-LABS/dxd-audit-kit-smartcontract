/// Module: vuln::capability
/// VI: Ví dụ LỖI – Capability bị abuse do borrow public
/// EN: VULNERABILITY Example – Capability abuse due to public borrow
/// ZH: 漏洞示例 – 由于公开借用导致的 Capability 滥用

module vuln::capability {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct AdminCap has key { id: UID }

    public fun create_admin_cap(ctx: &mut TxContext): AdminCap {
        AdminCap { id: object::new(ctx) }
    }

    /// VI: LỖ HỔNG: Public borrow &AdminCap → bất kỳ ai cũng có thể dùng quyền admin!
    /// EN: VULNERABILITY: Public borrow &AdminCap → anyone can use admin privileges!
    /// ZH: 漏洞：公开借用 &AdminCap → 任何人都可以使用管理员权限！
    public entry fun dangerous_action(cap: &AdminCap) {
        // VI: Attacker gọi function này với reference cap → abuse quyền
        // EN: Attacker calls this function with cap reference → privilege abuse
        // ZH: 攻击者使用 cap 引用调用此函数 → 权限滥用
        
        // VI: Ví dụ: withdraw toàn bộ fee, mint unlimited...
        // EN: Example: withdraw all fees, mint unlimited...
        // ZH: 例如：提取所有费用、无限铸造...
    }
}

// VI: Risk: High – Permission bypass
// EN: Risk: High – Permission bypass
// ZH: 风险：高 – 权限绕过

// VI: Fix:
// EN: Fix:
// ZH: 修复：
// 1. VI: Dùng parameter ownership (AdminCap thay vì &AdminCap)
//    EN: Use parameter ownership (AdminCap instead of &AdminCap)
//    ZH: 使用参数所有权（AdminCap 而不是 &AdminCap）
// 2. VI: Hoặc check owner: assert!(object::owner(cap) == tx_sender(), ENotOwner)
//    EN: Or check owner: assert!(object::owner(cap) == tx_sender(), ENotOwner)
//    ZH: 或者检查所有者：assert!(object::owner(cap) == tx_sender(), ENotOwner)