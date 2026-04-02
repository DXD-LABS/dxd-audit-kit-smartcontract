module vuln_db::ms_freeze_object_misuse {
    use sui::transfer;
    use sui::object::{Self, UID};

    struct ProtocolState has key, store { id: UID }

    /// ❌ VULNERABLE: Freezes the whole state object permanently
    public fun vuln_admin_freeze(obj: ProtocolState) {
        transfer::public_freeze_object(obj);
    }

    /// ✅ FIXED: Avoid freezing mission-critical shared objects 
    /// unless it is a final, intended decommissioning step.
}
