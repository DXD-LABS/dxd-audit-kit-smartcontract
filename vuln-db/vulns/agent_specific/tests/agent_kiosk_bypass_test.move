#[test_only]
module agent_specific::agent_kiosk_bypass_test {
    use sui::test_scenario;
    use agent_specific::agent_kiosk_bypass::{
        AgentKiosk, KioskOwnerCap, NftAsset,
        init_test, mint_nft_for_test, make_rogue_cap,
        transfer_nft_vulnerable, transfer_nft_fixed,
    };

    const OWNER:  address = @0xA;
    const ROGUE:  address = @0xB;
    const VICTIM: address = @0xC;

    /// ❌ Exploit: rogue agent uses a KioskOwnerCap mismatched to kiosk owner
    ///    and transfers an NFT without policy enforcement.
    #[test]
    fun test_vulnerable_kiosk_bypass() {
        let mut scenario = test_scenario::begin(OWNER);

        test_scenario::next_tx(&mut scenario, OWNER);
        let cap = {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx)
        };

        test_scenario::next_tx(&mut scenario, OWNER);
        let nft = {
            let ctx = test_scenario::ctx(&mut scenario);
            mint_nft_for_test(ctx)
        };

        test_scenario::next_tx(&mut scenario, ROGUE);
        {
            let mut kiosk = test_scenario::take_shared<AgentKiosk>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            // kiosk.owner == OWNER; rogue cap says owner == ROGUE
            let rogue_cap = make_rogue_cap(sui::object::id(&kiosk), ROGUE, ctx);
            // ❌ Vulnerable: no owner check — NFT sent to VICTIM
            transfer_nft_vulnerable(&mut kiosk, &rogue_cap, nft, VICTIM, ctx);
            sui::transfer::public_transfer(rogue_cap, ROGUE);
            test_scenario::return_shared(kiosk);
        };

        // NFT arrived at VICTIM without legitimate purchase
        test_scenario::next_tx(&mut scenario, VICTIM);
        {
            let nft = test_scenario::take_from_address<NftAsset>(&scenario, VICTIM);
            test_scenario::return_to_address(VICTIM, nft);
        };

        sui::transfer::public_transfer(cap, OWNER);
        test_scenario::end(scenario);
    }

    /// ✅ Fixed: rogue cap with mismatched owner is rejected (E_OWNER_MISMATCH).
    #[test]
    #[expected_failure(abort_code = agent_specific::agent_kiosk_bypass::E_OWNER_MISMATCH)]
    fun test_fixed_rejects_rogue_cap() {
        let mut scenario = test_scenario::begin(OWNER);

        test_scenario::next_tx(&mut scenario, OWNER);
        let cap = {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx)
        };

        test_scenario::next_tx(&mut scenario, OWNER);
        let nft = {
            let ctx = test_scenario::ctx(&mut scenario);
            mint_nft_for_test(ctx)
        };

        test_scenario::next_tx(&mut scenario, ROGUE);
        {
            let mut kiosk = test_scenario::take_shared<AgentKiosk>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            let rogue_cap = make_rogue_cap(sui::object::id(&kiosk), ROGUE, ctx);
            // ✅ Aborts: rogue_cap.owner (ROGUE) ≠ kiosk.owner (OWNER)
            transfer_nft_fixed(&mut kiosk, &rogue_cap, nft, VICTIM, ctx);
            sui::transfer::public_transfer(rogue_cap, ROGUE);
            test_scenario::return_shared(kiosk);
        };

        sui::transfer::public_transfer(cap, OWNER);
        test_scenario::end(scenario);
    }

    /// ✅ Fixed: kiosk owner calling with their own cap succeeds.
    #[test]
    fun test_fixed_owner_can_transfer() {
        let mut scenario = test_scenario::begin(OWNER);

        test_scenario::next_tx(&mut scenario, OWNER);
        let cap = {
            let ctx = test_scenario::ctx(&mut scenario);
            init_test(ctx)
        };

        test_scenario::next_tx(&mut scenario, OWNER);
        let nft = {
            let ctx = test_scenario::ctx(&mut scenario);
            mint_nft_for_test(ctx)
        };

        test_scenario::next_tx(&mut scenario, OWNER);
        {
            let mut kiosk = test_scenario::take_shared<AgentKiosk>(&scenario);
            let ctx = test_scenario::ctx(&mut scenario);
            // ✅ cap.owner == kiosk.owner == sender == OWNER — should succeed
            transfer_nft_fixed(&mut kiosk, &cap, nft, VICTIM, ctx);
            test_scenario::return_shared(kiosk);
        };

        // NFT arrived at VICTIM via legitimate owner transfer
        test_scenario::next_tx(&mut scenario, VICTIM);
        {
            let nft = test_scenario::take_from_address<NftAsset>(&scenario, VICTIM);
            test_scenario::return_to_address(VICTIM, nft);
        };

        sui::transfer::public_transfer(cap, OWNER);
        test_scenario::end(scenario);
    }
}
