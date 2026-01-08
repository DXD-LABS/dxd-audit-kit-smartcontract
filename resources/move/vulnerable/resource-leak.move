/// Module: vuln::resource_leak
/// VI: Ví dụ LỖI – Resource leak (object không delete)
/// EN: VULNERABILITY Example – Resource leak (object not deleted)
/// ZH: 漏洞示例 – 资源泄漏（对象未删除）

module vuln::resource_leak {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct TempData has key {  // VI: Có key nhưng không store → có thể drop | EN: Has key but no store → can be dropped | ZH: 具有 key 但没有 store → 可以 drop
        id: UID,
        value: u64,
    }

    public entry fun create_temp(value: u64, ctx: &mut TxContext) {
        let temp = TempData {
            id: object::new(ctx),
            value,
        };
        // VI: LỖ HỔNG: Không transfer hoặc delete temp → leak object ID, tốn storage mãi mãi
        // EN: VULNERABILITY: Not transferring or deleting temp → leak object ID, wastes storage forever
        // ZH: 漏洞：未转移或删除 temp → 泄漏对象 ID，永久浪费存储空间
        
        // VI: Attacker spam → DoS storage
        // EN: Attacker spam → DoS storage
        // ZH: 攻击者垃圾信息攻击 → 存储 DoS
    }
}

// VI: Risk: Medium-High – Storage bloat, DoS
// EN: Risk: Medium-High – Storage bloat, DoS
// ZH: 风险：中高 – 存储膨胀，DoS

// VI: Fix:
// EN: Fix:
// ZH: 修复：
// - VI: Thêm transfer::transfer(temp, sender) hoặc object::delete(id) nếu không cần lưu.
//   EN: Add transfer::transfer(temp, sender) or object::delete(id) if storage is not needed.
//   ZH: 如果不需要存储，则添加 transfer::transfer(temp, sender) 或 object::delete(id)。