#[test_only]
module agent_specific::agent_side_channel_leak_test {
    use sui::test_scenario;

    use agent_specific::agent_side_channel_leak::{
        AgentWallet,
        init_test, store_memory_vulnerable, store_memory_fixed,
        make_small_payload, make_large_payload, fixed_block_size, has_dynamic_field,
    };

    const USER: address = @0xA;

    /// Demonstrates the exploit:
    /// - Small payload → minimal dynamic field size
    /// - Large payload → larger dynamic field size
    /// Both are accepted by the vulnerable function, revealing data via size difference.
    #[test]
    fun test_vulnerable_side_channel_leak() {
        let mut scenario = test_scenario::begin(USER);

        test_scenario::next_tx(&mut scenario, USER);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx);
        };

        // Write small payload (1 byte)
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let small = make_small_payload();
            assert!(vector::length(&small) == 1, 0); // 1 byte — minimal gas
            // ❌ Variable-size write — size leaks to on-chain observer
            store_memory_vulnerable(&mut wallet, small, b"key_s", ctx);
            assert!(has_dynamic_field(&wallet, b"key_s"), 1);
            test_scenario::return_shared(wallet);
        };

        // Write large payload (200 bytes) — observable gas/size difference
        test_scenario::next_tx(&mut scenario, USER);
        {
            let mut wallet = test_scenario::take_shared<AgentWallet>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let large = make_large_payload();
            assert!(vector::length(&large) == 200, 0); // 200 bytes — higher gas
            // ❌ Larger write exposes data presence to any on-chain observer
            store_memory_vulnerable(&mut wallet, large, b"key_l", ctx);
            assert!(has_dynamic_field(&wallet, b"key_l"), 1);
            test_scenario::return_shared(wallet);
        };

        // An observer can infer that key_l stored more data than key_s
        // by comparing object sizes or gas costs — side-channel confirmed.

        test_scenario::end(scenario);
    }

    /// Fixed path: oversized payload (>256 bytes) must be rejected.
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_side_channel_leak::E_OVERSIZED_MEMORY)]
    fun test_fixed_rejects_oversized_payload() {
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
            // Build a 300-byte payload — exceeds FIXED_BLOCK_SIZE=256
            let mut oversized = vector::empty<u8>();
            let mut i = 0u64;
            while (i < 300) {
                vector::push_back(&mut oversized, 0xFFu8);
                i = i + 1;
            };
            // ✅ Fixed aborts — oversized
            store_memory_fixed(&mut wallet, oversized, b"key_big", ctx);
            test_scenario::return_shared(wallet);
        };

        test_scenario::end(scenario);
    }

    /// Fixed path: small payload is padded to FIXED_BLOCK_SIZE; commitment stored.
    #[test]
    fun test_fixed_pads_to_constant_size() {
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
            let small = make_small_payload(); // 1 byte
            assert!(vector::length(&small) < fixed_block_size(), 0);
            // ✅ Fixed: padded to 256 bytes, commitment hash stored
            store_memory_fixed(&mut wallet, small, b"key_padded", ctx);
            // Only commitment stored — no variable-size raw data
            assert!(has_dynamic_field(&wallet, b"key_padded"), 1);
            test_scenario::return_shared(wallet);
        };

        test_scenario::end(scenario);
    }
}
