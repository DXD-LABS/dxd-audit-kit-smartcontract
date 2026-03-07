#[test_only]
#[allow(unused_use)]
module agent_specific::agent_spend_limit_bypass_test {
    use sui::test_scenario;
    use agent_specific::agent_spend_limit_bypass::{Self, AgentConfig};

    const USER: address = @0x1;
    const ATTACKER: address = @0x2;

    #[test]
    fun test_vulnerable_spend_limit_bypass() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_spend_limit_bypass::init_test(ctx);
        };

        // First normal spend
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            agent_spend_limit_bypass::execute_workflow_step_vulnerable(&mut config, 8_000, USER, ctx);
            test_scenario::return_shared(config);
        };

        // Attacker poisons memory off-chain (simulated on-chain for PoC)
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            agent_spend_limit_bypass::poison_memory(&mut config);
            test_scenario::return_shared(config);
        };

        // Second spend bypasses limit because tracking was wiped
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            agent_spend_limit_bypass::execute_workflow_step_vulnerable(&mut config, 8_000, ATTACKER, ctx);
            test_scenario::return_shared(config);
        };

        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = agent_specific::agent_spend_limit_bypass::EOverSpendLimit)]
    fun test_fixed_prevents_bypass() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_spend_limit_bypass::init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            agent_spend_limit_bypass::execute_workflow_step_fixed(&mut config, 8_000, USER, ctx);
            test_scenario::return_shared(config);
        };

        // Even with memory poisoned
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut config = test_scenario::take_shared<AgentConfig>(&scenario);
            agent_spend_limit_bypass::poison_memory(&mut config);
            let ctx = test_scenario::ctx(&mut scenario);
            // This will abort because fixed version ignores the tainted flag
            agent_spend_limit_bypass::execute_workflow_step_fixed(&mut config, 8_000, ATTACKER, ctx);
            test_scenario::return_shared(config);
        };

        test_scenario::end(scenario);
    }
}
