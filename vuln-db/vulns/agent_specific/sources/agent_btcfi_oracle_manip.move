#[allow(lint(coin_field))]
module agent_specific::agent_btcfi_oracle_manip {
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    const E_STALE_PRICE: u64 = 1;
    const E_PRICE_DEVIATION: u64 = 2;
    const E_NOT_UNDERCOLLATERALIZED: u64 = 3;
    const E_ZERO_PRICE: u64 = 4;

    const MAX_STALE_EPOCHS: u64 = 5;
    /// Max allowed deviation: 500 basis points = 5%
    const MAX_DEVIATION_BPS: u64 = 500;

    /// Simulated BTCfi oracle price feed
    public struct OracleFeed has key {
        id: UID,
        /// BTC/SUI price in micro-SUI per satoshi (simulated)
        btc_sui_price: u64,
        last_updated: u64,
    }

    /// Vault holding a borrower's BTC collateral (simulated as SUI for PoC)
    public struct LiquidationVault has key {
        id: UID,
        collateral: Coin<SUI>,
        collateral_amount: u64,
        /// Debt in micro-SUI (simulated)
        debt_amount: u64,
    }

    public fun create_oracle(price: u64, epoch: u64, ctx: &mut TxContext): address {
        let feed = OracleFeed {
            id: object::new(ctx),
            btc_sui_price: price,
            last_updated: epoch,
        };
        let addr = object::id_address(&feed);
        transfer::share_object(feed);
        addr
    }

    public fun create_vault(
        collateral: Coin<SUI>,
        collateral_amount: u64,
        debt_amount: u64,
        ctx: &mut TxContext,
    ) {
        let vault = LiquidationVault {
            id: object::new(ctx),
            collateral,
            collateral_amount,
            debt_amount,
        };
        transfer::share_object(vault);
    }

    // -------------------------------------------------------------------------
    // VULNERABLE: single oracle, no staleness or deviation check
    // -------------------------------------------------------------------------
    public fun liquidate_vulnerable(
        oracle: &OracleFeed,
        vault: &mut LiquidationVault,
        ctx: &mut TxContext,
    ) {
        // ❌ Single-source oracle — price can be far from real market value
        let price = oracle.btc_sui_price;
        let collateral_value = vault.collateral_amount * price;
        // Attacker manipulates oracle to make healthy position appear undercollateralized
        if (collateral_value < vault.debt_amount) {
            let seized = coin::split(&mut vault.collateral, vault.collateral_amount, ctx);
            transfer::public_transfer(seized, ctx.sender());
        } else {
            assert!(false, E_NOT_UNDERCOLLATERALIZED);
        }
    }

    // -------------------------------------------------------------------------
    // FIXED: dual-oracle aggregation + deviation bound + staleness check
    // -------------------------------------------------------------------------
    public fun liquidate_fixed(
        oracle_a: &OracleFeed,
        oracle_b: &OracleFeed,
        vault: &mut LiquidationVault,
        current_epoch: u64,
        ctx: &mut TxContext,
    ) {
        // ✅ Staleness: both feeds must be recent
        assert!(current_epoch - oracle_a.last_updated <= MAX_STALE_EPOCHS, E_STALE_PRICE);
        assert!(current_epoch - oracle_b.last_updated <= MAX_STALE_EPOCHS, E_STALE_PRICE);
        // ✅ Deviation guard: feeds must agree within MAX_DEVIATION_BPS
        let avg_price = (oracle_a.btc_sui_price + oracle_b.btc_sui_price) / 2;
        assert!(avg_price > 0, E_ZERO_PRICE);
        let deviation = if (oracle_a.btc_sui_price > oracle_b.btc_sui_price) {
            oracle_a.btc_sui_price - oracle_b.btc_sui_price
        } else {
            oracle_b.btc_sui_price - oracle_a.btc_sui_price
        };
        assert!(
            deviation * 10_000 / avg_price <= MAX_DEVIATION_BPS,
            E_PRICE_DEVIATION
        );
        let collateral_value = vault.collateral_amount * avg_price;
        if (collateral_value < vault.debt_amount) {
            let seized = coin::split(&mut vault.collateral, vault.collateral_amount, ctx);
            transfer::public_transfer(seized, ctx.sender());
        } else {
            assert!(false, E_NOT_UNDERCOLLATERALIZED);
        }
    }

    // -------------------------------------------------------------------------
    // Test helpers
    // -------------------------------------------------------------------------
    #[test_only]
    public fun init_test(
        normal_price: u64,
        manip_price: u64,
        epoch: u64,
        ctx: &mut TxContext,
    ) {
        // oracle_a = manipulated price, oracle_b = true price
        create_oracle(manip_price, epoch, ctx);
        create_oracle(normal_price, epoch, ctx);
        let collateral = coin::mint_for_testing<SUI>(100_000, ctx);
        // debt_amount chosen so that at normal_price, vault is healthy;
        // but at manip_price, it appears undercollateralized
        create_vault(collateral, 10, 180_001, ctx); // 10 units * 18000 normal = 180000 < debt=180001
    }

    #[test_only]
    public fun get_price(oracle: &OracleFeed): u64 {
        oracle.btc_sui_price
    }
}
