#[test_only]
module agent_specific::agent_multi_consensus_failure_test {
    use sui::test_scenario;
    use sui::coin;
    use sui::sui::SUI;
    use agent_specific::agent_multi_consensus_failure::{
        SwarmConsensus, SwarmVault, SwarmAdminCap,
        init_test,
        register_agent, register_agent_vulnerable,
        cast_vote_vulnerable, cast_vote_fixed,
        execute_if_approved_vulnerable,
        get_approve_count, get_verified_votes, is_approved,
    };

    const ADMIN:    address = @0xA;
    const ROGUE_1:  address = @0xB;
    const ROGUE_2:  address = @0xC;
    const ROGUE_3:  address = @0xD;
    const AGENT_1:  address = @0xE;
    const ATTACKER: address = @0xF;

    const THRESHOLD: u64 = 5;

    /// ❌ Vulnerable: 5 unregistered rogues cast votes → threshold met, vault drained.
    #[test]
    fun test_vulnerable_consensus_bypass() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let cap = init_test(THRESHOLD, ctx);
            transfer::public_transfer(cap, ADMIN);
        };

        // 5 unverified rogue votes — bypass threshold
        test_scenario::next_tx(&mut scenario, ROGUE_1);
        {
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            cast_vote_vulnerable(&mut consensus, true, ctx);
            assert!(get_approve_count(&consensus) == 1, 0);
            test_scenario::return_shared(consensus);
        };
        test_scenario::next_tx(&mut scenario, ROGUE_2);
        {
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            cast_vote_vulnerable(&mut consensus, true, ctx);
            test_scenario::return_shared(consensus);
        };
        test_scenario::next_tx(&mut scenario, ROGUE_3);
        {
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            cast_vote_vulnerable(&mut consensus, true, ctx);
            test_scenario::return_shared(consensus);
        };
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            cast_vote_vulnerable(&mut consensus, true, ctx);
            test_scenario::return_shared(consensus);
        };
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            cast_vote_vulnerable(&mut consensus, true, ctx);
            // ❌ approved = true even though no registered agents voted
            assert!(is_approved(&consensus), 0);
            test_scenario::return_shared(consensus);
        };

        // Execute drain using bogus approval
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            let mut vault = test_scenario::take_shared<SwarmVault>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            execute_if_approved_vulnerable(&consensus, &mut vault, ATTACKER, ctx);
            test_scenario::return_shared(consensus);
            test_scenario::return_shared(vault);
        };

        // Verify attacker drained the vault
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let coin = test_scenario::take_from_address<coin::Coin<SUI>>(&scenario, ATTACKER);
            assert!(coin::value(&coin) == 200_000, 0);
            test_scenario::return_to_address(ATTACKER, coin);
        };

        test_scenario::end(scenario);
    }

    /// ❌ Vulnerable fixed-path via SYBIL: attacker self-registers using vulnerable registrar,
    ///    then votes with cast_vote_fixed — sybil succeeds because cast_vote_fixed only checks
    ///    registered_agents (populated via vulnerable registrar).
    #[test]
    fun test_sybil_attack_on_fixed_path_via_vulnerable_register() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let cap = init_test(1, ctx); // threshold = 1 for simplicity
            transfer::public_transfer(cap, ADMIN);
        };

        // Attacker self-registers using the vulnerable (un-gated) registrar
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            register_agent_vulnerable(&mut consensus, ATTACKER);
            test_scenario::return_shared(consensus);
        };

        // Attacker now passes cast_vote_fixed because they are in registered_agents
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            cast_vote_fixed(&mut consensus, true, ctx);
            // ❌ Sybil succeeds — threshold met via self-registered attacker
            assert!(is_approved(&consensus), 0);
            test_scenario::return_shared(consensus);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed path: unregistered agent vote is rejected with E_UNKNOWN_AGENT.
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_multi_consensus_failure::E_UNKNOWN_AGENT)]
    fun test_fixed_rejects_unregistered_agent() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let cap = init_test(THRESHOLD, ctx);
            transfer::public_transfer(cap, ADMIN);
        };

        // ROGUE_1 not registered — vote must abort
        test_scenario::next_tx(&mut scenario, ROGUE_1);
        {
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            cast_vote_fixed(&mut consensus, true, ctx);
            test_scenario::return_shared(consensus);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed path: cap-gated register + verified vote works correctly.
    #[test]
    fun test_fixed_admin_cap_gated_registration_and_vote() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let cap = init_test(THRESHOLD, ctx);
            transfer::public_transfer(cap, ADMIN);
        };

        // Admin (cap holder) registers AGENT_1
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let admin_cap = test_scenario::take_from_address<SwarmAdminCap>(&scenario, ADMIN);
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            register_agent(&admin_cap, &mut consensus, AGENT_1);
            test_scenario::return_to_address(ADMIN, admin_cap);
            test_scenario::return_shared(consensus);
        };

        // AGENT_1 casts a verified vote
        test_scenario::next_tx(&mut scenario, AGENT_1);
        {
            let mut consensus = test_scenario::take_shared<SwarmConsensus>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            cast_vote_fixed(&mut consensus, true, ctx);
            assert!(get_verified_votes(&consensus) == 1, 0);
            test_scenario::return_shared(consensus);
        };

        test_scenario::end(scenario);
    }
}
