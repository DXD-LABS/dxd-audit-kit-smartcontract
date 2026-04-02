module vuln_db::ms_token_issuance_ability_abuse {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, TreasuryCap};

    struct AdminCap has key, store { id: UID }
    struct Treasury<phantom T> has key { id: UID, cap: TreasuryCap<T> }

    /// ❌ VULNERABLE: Any module can trigger minting if they obtain the TreasuryCap
    public fun vuln_mint_token<T>(cap: &mut TreasuryCap<T>, amount: u64, ctx: &mut TxContext) {
        let coin = coin::mint(cap, amount, ctx);
        sui::transfer::public_transfer(coin, tx_context::sender(ctx));
    }

    /// ✅ FIXED: Only authorized AdminCap owners can mint
    public fun fixed_mint_token<T>(_admin: &AdminCap, cap: &mut TreasuryCap<T>, amount: u64, ctx: &mut TxContext) {
        let coin = coin::mint(cap, amount, ctx);
        sui::transfer::public_transfer(coin, tx_context::sender(ctx));
    }
}
