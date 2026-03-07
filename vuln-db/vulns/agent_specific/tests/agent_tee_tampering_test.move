#[test_only]
module agent_specific::agent_tee_tampering_test {
    use sui::test_scenario;
    use sui::coin;
    use sui::sui::SUI;
    use agent_specific::agent_tee_tampering::{
        AgentVault,
        init_test, make_invalid_report, make_stale_report, make_valid_report,
        accept_compute_vulnerable, accept_compute_fixed,
        action_transfer,
    };

    const USER:     address = @0xA;
    const ATTACKER: address = @0xB;

    /// ❌ Exploit: rogue compute accepted without attestation — vault drained.
    #[test]
    fun test_vulnerable_tee_tampering() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut vault = test_scenario::take_shared<AgentVault>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            // ❌ No attestation check — arbitrary action executes
            accept_compute_vulnerable(action_transfer(), 50_000, ATTACKER, &mut vault, ctx);
            test_scenario::return_shared(vault);
        };

        // Verify attacker received funds from vault
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let coin = test_scenario::take_from_address<coin::Coin<SUI>>(&scenario, ATTACKER);
            assert!(coin::value(&coin) == 50_000, 0);
            test_scenario::return_to_address(ATTACKER, coin);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed path: invalid attestation is rejected (E_ATTESTATION_FAIL).
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_tee_tampering::E_ATTESTATION_FAIL)]
    fun test_fixed_rejects_invalid_attestation() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut vault = test_scenario::take_shared<AgentVault>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let report = make_invalid_report();
            // ✅ Aborts — attestation is_valid = false
            accept_compute_fixed(
                action_transfer(), 50_000, ATTACKER,
                report, b"expected_hash", 5,
                &mut vault, ctx,
            );
            test_scenario::return_shared(vault);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed path: stale attestation is rejected (E_STALE_ATTESTATION).
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_tee_tampering::E_STALE_ATTESTATION)]
    fun test_fixed_rejects_stale_attestation() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut vault = test_scenario::take_shared<AgentVault>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let report = make_stale_report(); // issued_epoch = 0, current = 200 → stale
            // ✅ Aborts — attestation is stale (200 - 0 > 10)
            accept_compute_fixed(
                action_transfer(), 50_000, ATTACKER,
                report, b"expected_hash", 200,
                &mut vault, ctx,
            );
            test_scenario::return_shared(vault);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed path: hash mismatch is rejected (E_HASH_MISMATCH).
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_tee_tampering::E_HASH_MISMATCH)]
    fun test_fixed_rejects_hash_mismatch() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut vault = test_scenario::take_shared<AgentVault>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let report = make_valid_report(5, b"correct_hash");
            // ✅ Aborts — report_data ≠ expected_input_hash
            accept_compute_fixed(
                action_transfer(), 50_000, ATTACKER,
                report, b"tampered_hash", 5,
                &mut vault, ctx,
            );
            test_scenario::return_shared(vault);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed path: unknown action aborts (E_UNKNOWN_ACTION).
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_tee_tampering::E_UNKNOWN_ACTION)]
    fun test_fixed_rejects_unknown_action() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut vault = test_scenario::take_shared<AgentVault>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let input = b"correct_hash";
            let report = make_valid_report(5, input);
            // ✅ Aborts — action code 99 is unknown
            accept_compute_fixed(
                99u8, 50_000, ATTACKER,
                report, input, 5,
                &mut vault, ctx,
            );
            test_scenario::return_shared(vault);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed path: valid attestation with matching hash succeeds — funds transferred.
    #[test]
    fun test_fixed_accepts_valid_tee_compute() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut vault = test_scenario::take_shared<AgentVault>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let input_hash = b"verified_input_hash";
            let report = make_valid_report(5, input_hash);
            // ✅ All checks pass — transfer executes
            accept_compute_fixed(
                action_transfer(), 30_000, USER,
                report, input_hash, 5,
                &mut vault, ctx,
            );
            test_scenario::return_shared(vault);
        };

        // Verify USER received 30_000
        test_scenario::next_tx(&mut scenario, USER);
        {
            let coin = test_scenario::take_from_address<coin::Coin<SUI>>(&scenario, USER);
            assert!(coin::value(&coin) == 30_000, 0);
            test_scenario::return_to_address(USER, coin);
        };

        test_scenario::end(scenario);
    }
}
