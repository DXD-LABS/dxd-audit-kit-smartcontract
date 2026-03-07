#[test_only]
#[allow(unused_use)]
module agent_specific::shared_object_race_test {
    use sui::test_scenario;
    use agent_specific::shared_object_race::{Self, SharedTreasury};

    const AGENT_1: address = @0x1;
    const AGENT_2: address = @0x2;

    #[test]
    fun test_vulnerable_race_condition() {
        let mut scenario = test_scenario::begin(AGENT_1);
        
        test_scenario::next_tx(&mut scenario, AGENT_1);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            shared_object_race::init_test(ctx);
        };

        // Agent 1 prepares extraction
        test_scenario::next_tx(&mut scenario, AGENT_1);
        {
            let mut treasury = test_scenario::take_shared<SharedTreasury>(&scenario);
            shared_object_race::prepare_extraction_vulnerable(&mut treasury);
            test_scenario::return_shared(treasury);
        };

        // Agent 2 (malicious or concurrent) swoops in and executes extraction because it's locked,
        // stealing Agent 1's prepared extraction state due to lack of atomic execution!
        test_scenario::next_tx(&mut scenario, AGENT_2);
        {
            let mut treasury = test_scenario::take_shared<SharedTreasury>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            shared_object_race::execute_extraction_vulnerable(&mut treasury, 50_000, AGENT_2, ctx);
            test_scenario::return_shared(treasury);
        };
        
        test_scenario::next_tx(&mut scenario, AGENT_1);
        {
            let treasury = test_scenario::take_shared<SharedTreasury>(&scenario);
            // Lock is false, Agent 1 will fail its flow
            assert!(!shared_object_race::is_locked(&treasury), 0);
            test_scenario::return_shared(treasury);
        };

        test_scenario::end(scenario);
    }

    // Fixed test uses the Hot Potato which forces atomic execution in one PTB
}
