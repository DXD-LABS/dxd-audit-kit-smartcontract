#[test_only]
module agent_specific::agent_unaudited_lib_vuln_test {
    use sui::test_scenario;
    use agent_specific::agent_unaudited_lib_vuln::{
        AgentConfig, BadAdminCap, ProtocolAdminCap,
        init_test,
        whitelist_auditor, whitelist_auditor_vulnerable,
        register_lib_audit, use_lib_fixed,
        use_lib_vulnerable,
        get_audit_verified, get_auditor,
    };

    const ADMIN:    address = @0xA;
    const ATTACKER: address = @0xB;
    const AUDITOR:  address = @0xC;

    /// ❌ Exploit: attacker directly calls backdoor_mint_cap → receives BadAdminCap.
    #[test]
    fun test_vulnerable_backdoor_cap_minted() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let cap = init_test(ctx);
            transfer::public_transfer(cap, ADMIN);
        };

        // ❌ Attacker calls backdoor on the unaudited lib directly
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            use_lib_vulnerable(ctx);
        };

        // BadAdminCap arrives at attacker — backdoor confirmed
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let cap = test_scenario::take_from_address<BadAdminCap>(&scenario, ATTACKER);
            test_scenario::return_to_address(ATTACKER, cap);
        };

        test_scenario::end(scenario);
    }

    /// ❌ Exploit: attacker self-whitelists via the vulnerable (un-gated) function,
    ///    then registers themselves as auditor → audit gate fully bypassed.
    #[test]
    fun test_self_whitelist_bypass() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let cap = init_test(ctx);
            transfer::public_transfer(cap, ADMIN);
        };

        // ❌ Attacker calls whitelist_auditor_vulnerable (no access check)
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            whitelist_auditor_vulnerable(&mut config, ATTACKER, ctx);
            test_scenario::return_shared(config);
        };

        // Attacker is now whitelisted — can register as auditor
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            register_lib_audit(&mut config, ctx); // should succeed — attacker bypassed gate
            assert!(get_audit_verified(&config), 0);
            assert!(get_auditor(&config) == ATTACKER, 1);
            test_scenario::return_shared(config);
        };

        // Now attacker can use the lib
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            use_lib_fixed(&config, ctx); // no abort — gate bypassed entirely
            test_scenario::return_shared(config);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed: using the lib without audit registration must abort.
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_unaudited_lib_vuln::E_UNAUDITED_LIB)]
    fun test_fixed_rejects_unaudited_lib_use() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let cap = init_test(ctx);
            transfer::public_transfer(cap, ADMIN);
        };

        // Attacker tries to use the lib without audit registration — aborts
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            use_lib_fixed(&config, ctx);
            test_scenario::return_shared(config);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed: non-whitelisted auditor cannot register lib.
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_unaudited_lib_vuln::E_UNVERIFIED_AUDITOR)]
    fun test_fixed_rejects_unwhitelisted_auditor() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let cap = init_test(ctx);
            transfer::public_transfer(cap, ADMIN);
        };

        // AUDITOR not whitelisted — registration must abort
        test_scenario::next_tx(&mut scenario, AUDITOR);
        {
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            register_lib_audit(&mut config, ctx);
            test_scenario::return_shared(config);
        };

        test_scenario::end(scenario);
    }

    /// ✅ Fixed: ProtocolAdminCap-gated whitelist → auditor registers → lib usable.
    #[test]
    fun test_fixed_cap_gated_whitelist_and_registration() {
        let mut scenario = test_scenario::begin(ADMIN);

        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let cap = init_test(ctx);
            transfer::public_transfer(cap, ADMIN);
        };

        // ✅ Admin (cap holder) whitelists AUDITOR — only valid path
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let admin_cap = test_scenario::take_from_address<ProtocolAdminCap>(&scenario, ADMIN);
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            whitelist_auditor(&admin_cap, &mut config, AUDITOR, ctx);
            test_scenario::return_to_address(ADMIN, admin_cap);
            test_scenario::return_shared(config);
        };

        // AUDITOR registers the lib
        test_scenario::next_tx(&mut scenario, AUDITOR);
        {
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            register_lib_audit(&mut config, ctx);
            assert!(get_audit_verified(&config), 0);
            assert!(get_auditor(&config) == AUDITOR, 1);
            test_scenario::return_shared(config);
        };

        // Now use of lib succeeds
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            use_lib_fixed(&config, ctx);
            test_scenario::return_shared(config);
        };

        test_scenario::end(scenario);
    }
}
