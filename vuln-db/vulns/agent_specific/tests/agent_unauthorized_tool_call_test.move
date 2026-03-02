#[test_only]
module agent_specific::agent_unauthorized_tool_call_test {
    use sui::test_scenario::{Self, Scenario};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use std::string::utf8;
    use agent_specific::agent_unauthorized_tool_call::{Self, AgentWallet};

    const USER: address = @0x1;
    const ATTACKER: address = @0x2;

    #[test]
    fun test_vulnerable_prompt_injection() {
        let mut scenario = test_scenario::begin(USER);
        
        // Setup agent wallet
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_unauthorized_tool_call::init_test(ctx);
        };

        // Attacker performs prompt injection
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            
            // Attacker off-chain tricks agent to call transfer to their address
            agent_unauthorized_tool_call::execute_tool_vulnerable(
                &mut wallet,
                utf8(b"transfer"),
                ATTACKER,
                50_000,
                ctx
            );
            
            test_scenario::return_shared(wallet);
        };

        // Verify attacker stole funds
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let coin = test_scenario::take_from_address<Coin<SUI>>(&scenario, ATTACKER);
            assert!(coin::value(&coin) == 50_000, 0);
            test_scenario::return_to_address(ATTACKER, coin);
        };

        test_scenario::end(scenario);
    }
    
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_unauthorized_tool_call::EUnauthorizedAction)]
    fun test_fixed_prevents_injection() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_unauthorized_tool_call::init_test(ctx);
        };

        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            
            // Attacker intent verification fails
            agent_unauthorized_tool_call::execute_tool_fixed(
                &mut wallet,
                utf8(b"transfer"),
                ATTACKER,
                50_000,
                false, // intent not verified
                ctx
            );
            
            test_scenario::return_shared(wallet);
        };
        
        test_scenario::end(scenario);
    }
}
