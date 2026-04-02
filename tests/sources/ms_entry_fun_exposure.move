module vuln_db::ms_entry_fun_exposure {
    use sui::object::UID;
    use sui::tx_context::{Self, TxContext};

    struct Vault has key { id: UID, admin: address }

    /// ❌ VULNERABLE: No check if vault is already initialized or authority
    public entry fun vuln_initialize_vault(vault: &mut Vault, ctx: &mut TxContext) {
        vault.admin = tx_context::sender(ctx);
    }

    /// ✅ FIXED: Check state and authority
    public entry fun fixed_initialize_vault(vault: &mut Vault, ctx: &mut TxContext) {
        assert!(vault.admin == @0x0, 0); // E_ALREADY_INIT
        vault.admin = tx_context::sender(ctx);
    }
}
