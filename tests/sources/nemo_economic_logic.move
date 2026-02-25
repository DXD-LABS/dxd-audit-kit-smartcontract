module vuln_db::nemo_economic_logic {
    const E_BRIDGE_FAIL: u64 = 500;

    struct BridgedFunds has key, store {
        id: sui::object::UID,
        amount: u64,
        verified: bool
    }

    // Mock bridge function
    public fun bridge(amount: u64, ctx: &mut sui::tx_context::TxContext): BridgedFunds {
        BridgedFunds {
            id: sui::object::new(ctx),
            amount,
            verified: false // In vulnerable version, it might not be verified immediately
        }
    }

    public fun verified_bridge(funds: &BridgedFunds): bool {
        funds.verified
    }

    // Vulnerable: No post-bridge verification
    public fun vuln_repay_yield(amount: u64, ctx: &mut sui::tx_context::TxContext) {
        let _bridged = bridge(amount, ctx);
        // Missing: assert!(verified_bridge(&bridged), E_BRIDGE_FAIL);
    }

    // Fixed: Verified bridge success
    public fun fixed_repay_yield(amount: u64, ctx: &mut sui::tx_context::TxContext) {
        let bridged = bridge(amount, ctx);
        assert!(verified_bridge(&bridged), E_BRIDGE_FAIL);
    }
}
