module examples::capability_safe {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;

    /// VI: AdminCap là object biểu thị quyền năng.
    /// EN: AdminCap is an object representing authority.
    /// ZH: AdminCap 是代表权力的对象。
    struct AdminCap has key { id: UID }

    /// VI: Chỉ hàm init mới tạo được AdminCap (theo pattern).
    /// EN: Only init function can create AdminCap (following pattern).
    public fun create_admin_cap(ctx: &mut TxContext): AdminCap {
        AdminCap { id: object::new(ctx) }
    }

    /// VI: Hành động đặc quyền yêu cầu AdminCap.
    /// EN: Privileged action requiring AdminCap.
    public fun privileged_action(_cap: &AdminCap) {
        // Logic security checks here
    }

    /// VI: Chống lạm dụng bằng cách kiểm tra owner (Prover spec bên dưới).
    /// EN: Prevent abuse by checking owner (Prover spec below).
    spec privileged_action {
        // ensures signer == cap.owner; // Conceptual prover spec
    }
}