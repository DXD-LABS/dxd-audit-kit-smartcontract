/// VI: Mau an toan cho capability quan ly quyen admin.
/// EN: Safe pattern for capability-based admin control.
/// ZH: Capability an toan mau hinh cho quyen quan tri.
module safe::capability {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;

    /// VI: AdminCap la "chia khoa" quyen han.
    /// EN: AdminCap is the permission "key".
    /// ZH: AdminCap shi quan han "yao shi".
    struct AdminCap has key { id: UID }

    /// VI: Tao AdminCap duy nhat.
    /// EN: Create a unique AdminCap.
    /// ZH: Chuang jian wei yi AdminCap.
    public fun create_admin_cap(ctx: &mut TxContext): AdminCap {
        AdminCap { id: object::new(ctx) }
    }

    /// VI: Han dong nhay cam, chi admin co the goi.
    /// EN: Sensitive action, only admin can call.
    /// ZH: Min gan thao tac, zhi admin ke yi goi.
    public entry fun restricted_action(_cap: &AdminCap) {
        // Admin-only logic goes here.
    }

    /// VI: Chuyen cap sang dia chi moi.
    /// EN: Transfer cap to a new address.
    /// ZH: Jiang cap zhuan gei xin di zhi.
    public entry fun transfer_cap(cap: AdminCap, recipient: address) {
        transfer::transfer(cap, recipient);
    }
}
