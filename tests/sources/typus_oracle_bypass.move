module vuln_db::typus_oracle_bypass {
    use sui::tx_context::{Self, TxContext};

    struct Oracle has key, store {
        id: sui::object::UID,
        price: u64,
        admin: address
    }

    const E_UNAUTHORIZED: u64 = 403;

    public fun initialize(ctx: &mut TxContext) {
        let oracle = Oracle {
            id: sui::object::new(ctx),
            price: 100,
            admin: tx_context::sender(ctx)
        };
        sui::transfer::share_object(oracle);
    }

    // Vulnerable: missing auth check
    public entry fun vuln_update_v2(oracle: &mut Oracle, new_price: u64, _ctx: &mut TxContext) {
        oracle.price = new_price;
    }

    // Fixed: includes auth check
    public entry fun fixed_update_v2(oracle: &mut Oracle, new_price: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == oracle.admin, E_UNAUTHORIZED);
        oracle.price = new_price;
    }

    #[test_only]
    public fun get_price(oracle: &Oracle): u64 {
        oracle.price
    }
}
