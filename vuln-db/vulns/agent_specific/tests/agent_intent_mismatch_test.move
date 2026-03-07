#[test_only]
#[allow(unused_use)]
module agent_specific::agent_intent_mismatch_test {
    use sui::test_scenario;
    use std::bcs;
    use sui::hash;
    use agent_specific::agent_intent_mismatch::{Self, AgentWallet};

    const USER: address = @0x1;
    const ATTACKER: address = @0x2;

    #[test]
    fun test_vulnerable_intent_mismatch() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_intent_mismatch::init_test(ctx);
        };

        // Expected intent: send 10 to USER
        let mut payload = vector::empty<u8>();
        let target: address = USER;
        let amount: u64 = 10;
        vector::append(&mut payload, bcs::to_bytes(&target));
        vector::append(&mut payload, bcs::to_bytes(&amount));
        let expected_hash = hash::blake2b256(&payload);

        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            
            // Attacker executes a different tx but passes the expected hash
            // The vulnerable function doesn't check it
            agent_intent_mismatch::execute_vulnerable(
                &mut wallet,
                ATTACKER,
                50_000,
                expected_hash,
                ctx
            );
            test_scenario::return_shared(wallet);
        };
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = agent_specific::agent_intent_mismatch::EIntentMismatch)]
    fun test_fixed_intent_mismatch() {
        let mut scenario = test_scenario::begin(USER);
        
        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            agent_intent_mismatch::init_test(ctx);
        };

        // Expected intent: send 10 to USER
        let mut payload = vector::empty<u8>();
        let target: address = USER;
        let amount: u64 = 10;
        vector::append(&mut payload, bcs::to_bytes(&target));
        vector::append(&mut payload, bcs::to_bytes(&amount));
        let expected_hash = hash::blake2b256(&payload);

        test_scenario::next_tx(&mut scenario, ATTACKER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            
            // Reverted because on-chain derivation of ATTACKER + 50_000 != expected_hash
            agent_intent_mismatch::execute_fixed(
                &mut wallet,
                ATTACKER,
                50_000,
                expected_hash,
                ctx
            );
            test_scenario::return_shared(wallet);
        };
        test_scenario::end(scenario);
    }
}
