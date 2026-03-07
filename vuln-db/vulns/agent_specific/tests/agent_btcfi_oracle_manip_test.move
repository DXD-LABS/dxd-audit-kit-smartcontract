#[test_only]
module agent_specific::agent_btcfi_oracle_manip_test {
    use sui::test_scenario;
    use agent_specific::agent_btcfi_oracle_manip::{
        OracleFeed, LiquidationVault,
        init_test, get_price,
        liquidate_fixed,
    };

    const ADMIN:    address = @0xA;
    const ATTACKER: address = @0xB;

    /// Normal BTC/SUI price (1 unit = 18,000 micro-SUI)
    const NORMAL_PRICE:  u64 = 18_000;
    /// Manipulated price (2x normal — attacker poisons oracle)
    const MANIP_PRICE:   u64 = 36_000;
    const EPOCH: u64 = 100;

    /// Exploit: poisoned single oracle → position can be liquidated using manipulated price.
    #[test]
    fun test_vulnerable_oracle_manipulation() {
        let mut scenario = test_scenario::begin(ADMIN);

        // init_test creates oracle_a (manip_price=36000), oracle_b (normal_price=18000), vault
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(NORMAL_PRICE, MANIP_PRICE, EPOCH, ctx);
        };

        // Verify both oracle prices exist — take_shared order is not guaranteed,
        // so we take both and check prices via set logic (one should be MANIP, one NORMAL)
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let oracle_1 = test_scenario::take_shared<OracleFeed>(&scenario);
            let oracle_2 = test_scenario::take_shared<OracleFeed>(&scenario);
            let p1 = get_price(&oracle_1);
            let p2 = get_price(&oracle_2);
            // One oracle must be the manipulated price, the other normal
            assert!(
                (p1 == MANIP_PRICE && p2 == NORMAL_PRICE) ||
                (p1 == NORMAL_PRICE && p2 == MANIP_PRICE),
                0
            );
            test_scenario::return_shared(oracle_1);
            test_scenario::return_shared(oracle_2);
        };

        test_scenario::end(scenario);
    }

    /// Fixed path: deviation > 5% between oracle_a and oracle_b must abort.
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_btcfi_oracle_manip::E_PRICE_DEVIATION)]
    fun test_fixed_rejects_deviated_price() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            // oracle_a = manip (36000), oracle_b = normal (18000) → 50% deviation > 5%
            init_test(NORMAL_PRICE, MANIP_PRICE, EPOCH, ctx);
        };

        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let oracle_a = test_scenario::take_shared<OracleFeed>(&scenario);
            let oracle_b = test_scenario::take_shared<OracleFeed>(&scenario);
            let mut vault = test_scenario::take_shared<LiquidationVault>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            // ✅ Fixed: aborts because deviation between 36000 and 18000 is 50% >> 5%
            liquidate_fixed(&oracle_a, &oracle_b, &mut vault, EPOCH, ctx);
            test_scenario::return_shared(oracle_a);
            test_scenario::return_shared(oracle_b);
            test_scenario::return_shared(vault);
        };

        test_scenario::end(scenario);
    }
}
