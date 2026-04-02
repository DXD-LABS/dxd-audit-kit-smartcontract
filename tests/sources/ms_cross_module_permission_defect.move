module vuln_db::ms_cross_module_permission_defect {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, TreasuryCap};

    struct AdminCap has key, store { id: UID }
    struct Treasury<phantom T> has key { id: UID, cap: TreasuryCap<T> }

    /// ❌ VULNERABLE: Any module can call this if they have treasury reference
    public fun vuln_internal_mint<T>(treasury: &mut Treasury<T>, amount: u64, ctx: &mut TxContext) {
        let coin = coin::mint(&mut treasury.cap, amount, ctx);
        sui::transfer::public_transfer(coin, tx_context::sender(ctx));
    }

    /// ✅ FIXED: Require AdminCap as proof of authority
    public fun fixed_internal_mint<T>(_cap: &AdminCap, treasury: &mut Treasury<T>, amount: u64, ctx: &mut TxContext) {
        let coin = coin::mint(&mut treasury.cap, amount, ctx);
        sui::transfer::public_transfer(coin, tx_context::sender(ctx));
    }
}
