module examples::liquidation_safe {
    use sui::math;

    struct Position has key {
        borrowed: u64,
        collateral_value: u64,  // Từ oracle
    }

    const LIQUIDATION_THRESHOLD: u64 = 120;  // 120% collateral ratio để safe

    // Check nếu cần liquidation
    public fun needs_liquidation(pos: &Position): bool {
        let ratio = if (pos.collateral_value == 0) { 0 } else { math::mul_div(pos.borrowed * 100, 100, pos.collateral_value) };
        ratio > LIQUIDATION_THRESHOLD
    }

    // Liquidate chỉ nếu under-collateral
    public fun liquidate(pos: &mut Position) {
        assert!(needs_liquidation(pos), 400);  // Abort nếu không cần
        // Logic liquidation...
    }

    spec module {
        pragma verify = true;
    }

    spec needs_liquidation {
        ensures result == (pos.collateral_value * 100 / pos.borrowed < 100 / LIQUIDATION_THRESHOLD);
    }

    spec liquidate {
        aborts_if !needs_liquidation(old(pos));
        // Invariant: Sau liquidation, position cleared hoặc adjusted
        ensures pos.borrowed == 0 || pos.collateral_value >= pos.borrowed * LIQUIDATION_THRESHOLD / 100;
    }
}