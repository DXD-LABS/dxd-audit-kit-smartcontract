/// MSL Prover Specification: BTCfi Oracle Deviation Bounds
/// Invariant: a liquidation may only proceed when:
///   (1) both oracle feeds are fresh (staleness <= MAX_STALE_EPOCHS)
///   (2) price deviation between feeds <= MAX_DEVIATION_BPS (5%)
/// Linked to AGENT-012 mitigation.
module prover_examples::agent_btcfi_oracle_bounds {

    const E_STALE_PRICE: u64 = 1;
    const E_PRICE_DEVIATION: u64 = 2;
    const E_NOT_UNDERCOLLATERALIZED: u64 = 3;
    const MAX_STALE_EPOCHS: u64 = 5;
    /// 500 bps = 5%
    const MAX_DEVIATION_BPS: u64 = 500;

    public struct OracleSnapshot has drop {
        price: u64,
        last_updated: u64,
    }

    public struct LiquidationDecision has drop {
        /// True only when all guards pass
        authorized: bool,
        /// Aggregate price used
        safe_price: u64,
    }

    /// Validate dual-oracle data and authorize a liquidation price.
    /// Post-conditions enforce freshness and deviation invariants.
    public fun validate_and_price(
        oracle_a: &OracleSnapshot,
        oracle_b: &OracleSnapshot,
        current_epoch: u64,
    ): LiquidationDecision {
        assert!(current_epoch - oracle_a.last_updated <= MAX_STALE_EPOCHS, E_STALE_PRICE);
        assert!(current_epoch - oracle_b.last_updated <= MAX_STALE_EPOCHS, E_STALE_PRICE);
        let avg = (oracle_a.price + oracle_b.price) / 2;
        let deviation = if (oracle_a.price > oracle_b.price) {
            oracle_a.price - oracle_b.price
        } else {
            oracle_b.price - oracle_a.price
        };
        assert!(deviation * 10_000 / avg <= MAX_DEVIATION_BPS, E_PRICE_DEVIATION);
        LiquidationDecision { authorized: true, safe_price: avg }
    }

    spec validate_and_price {
        /// Both feeds must be fresh
        aborts_if current_epoch - oracle_a.last_updated > MAX_STALE_EPOCHS with E_STALE_PRICE;
        aborts_if current_epoch - oracle_b.last_updated > MAX_STALE_EPOCHS with E_STALE_PRICE;
        /// Price deviation must be within bounds
        aborts_if (abs(oracle_a.price, oracle_b.price)) * 10_000 / ((oracle_a.price + oracle_b.price) / 2) > MAX_DEVIATION_BPS with E_PRICE_DEVIATION;
        /// Safe aggregated price is always the average of both feeds
        ensures result.safe_price == (oracle_a.price + oracle_b.price) / 2;
        ensures result.authorized == true;
    }
}
