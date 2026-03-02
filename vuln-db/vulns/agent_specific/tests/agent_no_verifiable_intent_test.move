#[test_only]
module agent_specific::agent_no_verifiable_intent_test {
    use sui::test_scenario::{Self, Scenario};
    use agent_specific::agent_no_verifiable_intent::{Self, AgentWallet};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    const USER: address = @0x1;
    const ATTACKER: address = @0x2;

    #[test]
    fun test_vulnerable_no_proof_action() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_no_verifiable_intent::init_test(ctx);
        };

        // Rogue AI agent unilaterally decides to send funds to itself/attacker
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            
            // Succeeds without any proof
            agent_no_verifiable_intent::execute_action_vulnerable(&mut wallet, ATTACKER, 50_000, ctx);
            
            test_scenario::return_shared(wallet);
        };

        // Output validation
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let coin = test_scenario::take_from_address<Coin<SUI>>(&scenario, ATTACKER);
            assert!(coin::value(&coin) == 50_000, 0);
            test_scenario::return_to_address(ATTACKER, coin);
        };

        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = agent_specific::agent_no_verifiable_intent::EMissingIntentProof)]
    fun test_fixed_requires_proof() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_no_verifiable_intent::init_test(ctx);
        };

        // Rogue AI agent tries to execute without valid proof
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            
            // Agent generated an invalid proof since it doesn't have user signature/intent
            let proof = agent_no_verifiable_intent::verify_intent(false);
            
            // Fails due to lack of valid proof
            agent_no_verifiable_intent::execute_action_fixed(&mut wallet, ATTACKER, 50_000, proof, ctx);
            
            test_scenario::return_shared(wallet);
        };

        test_scenario::end(scenario);
    }
}
