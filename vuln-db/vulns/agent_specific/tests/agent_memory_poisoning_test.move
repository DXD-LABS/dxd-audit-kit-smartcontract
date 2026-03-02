#[test_only]
module agent_specific::agent_memory_poisoning_test {
    use sui::test_scenario::{Self, Scenario};
    use agent_specific::agent_memory_poisoning::{Self, AgentContext};

    const USER: address = @0x1;
    const ATTACKER: address = @0x2;

    #[test]
    fun test_vulnerable_memory_poisoning() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_memory_poisoning::init_test(ctx);
        };

        // Attacker poisons memory off-chain (simulated here)
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut agent = test_scenario::take_shared<AgentContext>(&scenario);
            agent_memory_poisoning::poison_memory(&mut agent);
            test_scenario::return_shared(agent);
        };

        // Rogue agent uses poisoned memory to approve attacker's contract
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut agent = test_scenario::take_shared<AgentContext>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            
            // Attacker succeeds in getting approved without being owner
            agent_memory_poisoning::approve_contract_vulnerable(&mut agent, ATTACKER, ctx);
            assert!(agent_memory_poisoning::is_approved(&agent, ATTACKER), 0);
            
            test_scenario::return_shared(agent);
        };

        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = agent_specific::agent_memory_poisoning::EInvalidState)]
    fun test_fixed_prevents_poisoning() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_memory_poisoning::init_test(ctx);
        };

        // Attacker poisons memory off-chain
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut agent = test_scenario::take_shared<AgentContext>(&scenario);
            agent_memory_poisoning::poison_memory(&mut agent);
            test_scenario::return_shared(agent);
        };

        // Attempt fails because fixed version enforced true ownership vs relying on LLM memory state
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut agent = test_scenario::take_shared<AgentContext>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            
            agent_memory_poisoning::approve_contract_fixed(&mut agent, ATTACKER, false, ctx);
            
            test_scenario::return_shared(agent);
        };

        test_scenario::end(scenario);
    }
}
