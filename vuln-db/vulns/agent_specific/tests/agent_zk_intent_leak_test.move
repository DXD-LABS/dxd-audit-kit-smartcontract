#[test_only]
module agent_specific::agent_zk_intent_leak_test {
    use sui::test_scenario;
    use agent_specific::agent_zk_intent_leak::{
        AgentWallet,
        init_test, make_leaky_proof_for_test, make_private_proof_for_test,
        execute_zk_intent_vulnerable, execute_zk_intent_fixed,
        proof_exposes_sensitive,
        has_dynamic_field_last_intent, has_dynamic_field_last_intent_hash,
    };

    const USER: address = @0xA;
    const ATTACKER: address = @0xB;

    /// Demonstrates the exploit: leaky proof is accepted, sensitive data written on-chain.
    #[test]
    fun test_vulnerable_zk_intent_leak() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        // Attacker passes a leaky proof — sensitive data exposed
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let proof = make_leaky_proof_for_test(1000);
            // Verify that the proof exposes sensitive data
            assert!(proof_exposes_sensitive(&proof), 0);
            // ❌ Vulnerable call — sensitive data written to dynamic field
            execute_zk_intent_vulnerable(proof, &mut wallet, ctx);
            // Dynamic field 'last_intent' now holds raw sensitive bytes
            assert!(has_dynamic_field_last_intent(&wallet), 1);
            test_scenario::return_shared(wallet);
        };

        test_scenario::end(scenario);
    }

    /// Demonstrates the fix: leaky proof aborts; private proof succeeds with commitment only.
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_zk_intent_leak::E_PRIVACY_VIOLATION)]
    fun test_fixed_rejects_leaky_proof() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let proof = make_leaky_proof_for_test(1000);
            // ✅ Fixed version aborts — leaky proof rejected
            execute_zk_intent_fixed(proof, &mut wallet, ctx);
            test_scenario::return_shared(wallet);
        };

        test_scenario::end(scenario);
    }

    /// Fixed path with private proof should succeed and write only commitment.
    #[test]
    fun test_fixed_accepts_private_proof() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let proof = make_private_proof_for_test(1000);
            assert!(!proof_exposes_sensitive(&proof), 0);
            execute_zk_intent_fixed(proof, &mut wallet, ctx);
            // Only the commitment hash is stored — no raw data
            assert!(has_dynamic_field_last_intent_hash(&wallet), 1);
            assert!(!has_dynamic_field_last_intent(&wallet), 2);
            test_scenario::return_shared(wallet);
        };

        test_scenario::end(scenario);
    }
}
