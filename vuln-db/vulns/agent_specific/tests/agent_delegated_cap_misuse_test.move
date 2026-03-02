#[test_only]
module agent_specific::agent_delegated_cap_misuse_test {
    use sui::test_scenario::{Self, Scenario};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use agent_specific::agent_delegated_cap_misuse::{Self, AgentContext, AdminCap};

    const USER: address = @0x1;
    const ATTACKER: address = @0x2;

    #[test]
    fun test_vulnerable_cap_misuse() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        let cap = {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_delegated_cap_misuse::init_test(ctx)
        };

        // User delegates capability to agent
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut agent = test_scenario::take_shared<AgentContext>(&scenario);
            agent_delegated_cap_misuse::delegate_cap(&mut agent, cap);
            test_scenario::return_shared(agent);
        };

        // Rogue agent/Attacker triggers the misuse function
        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut agent = test_scenario::take_shared<AgentContext>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            agent_delegated_cap_misuse::misuse_cap_vulnerable(&mut agent, ATTACKER, 50_000, ctx);
            test_scenario::return_shared(agent);
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
}
