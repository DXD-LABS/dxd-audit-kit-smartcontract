module agent_specific::agent_kiosk_bypass {
    use sui::object::ID;
    use sui::coin::Coin;
    use sui::sui::SUI;

    const E_OWNER_MISMATCH: u64 = 1;
    const E_POLICY_VIOLATION: u64 = 2;

    /// Simulated NFT asset (Sui kiosk item)
    public struct NftAsset has key, store {
        id: UID,
        name: vector<u8>,
        creator: address,
    }

    /// Simplified kiosk structure (Sui's kiosk has key)
    public struct AgentKiosk has key {
        id: UID,
        owner: address,
        /// Whether the kiosk enforces transfer policy
        policy_enforced: bool,
    }

    /// Kiosk owner capability (scoped to one kiosk)
    public struct KioskOwnerCap has key, store {
        id: UID,
        kiosk_id: ID,
        owner: address,
    }

    public fun create_kiosk(ctx: &mut TxContext): KioskOwnerCap {
        let owner = ctx.sender();
        let kiosk = AgentKiosk {
            id: object::new(ctx),
            owner,
            policy_enforced: true,
        };
        let kiosk_id = object::id(&kiosk);
        let cap = KioskOwnerCap {
            id: object::new(ctx),
            kiosk_id,
            owner,
        };
        transfer::share_object(kiosk);
        cap
    }

    public fun mint_nft(name: vector<u8>, ctx: &mut TxContext): NftAsset {
        NftAsset {
            id: object::new(ctx),
            name,
            creator: ctx.sender(),
        }
    }

    // -------------------------------------------------------------------------
    // VULNERABLE: transfer NFT out of kiosk without owner match or policy check
    // -------------------------------------------------------------------------
    public fun transfer_nft_vulnerable(
        _kiosk: &mut AgentKiosk,
        _cap: &KioskOwnerCap,
        nft: NftAsset,
        recipient: address,
        _ctx: &mut TxContext,
    ) {
        // ❌ No check: cap.owner vs kiosk.owner — rogue agent bypasses ownership
        // ❌ No policy enforcement — transfer_policy rules skipped
        transfer::public_transfer(nft, recipient);
    }

    // -------------------------------------------------------------------------
    // FIXED: assert cap owner matches kiosk owner + policy must be enforced
    //        + only the cap owner (or their delegated agent) can initiate transfer
    // -------------------------------------------------------------------------
    public fun transfer_nft_fixed(
        kiosk: &mut AgentKiosk,
        cap: &KioskOwnerCap,
        nft: NftAsset,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        // ✅ Cap must be bound to this kiosk's owner
        assert!(cap.owner == kiosk.owner, E_OWNER_MISMATCH);
        // ✅ Transfer policy must be enforced (royalties, rules)
        assert!(kiosk.policy_enforced, E_POLICY_VIOLATION);
        // ✅ Only the cap owner themselves may initiate (agents must hold the cap)
        assert!(cap.owner == ctx.sender(), E_OWNER_MISMATCH);
        transfer::public_transfer(nft, recipient);
    }

    // -------------------------------------------------------------------------
    // Test helpers
    // -------------------------------------------------------------------------
    #[test_only]
    public fun init_test(ctx: &mut TxContext): KioskOwnerCap {
        create_kiosk(ctx)
    }

    #[test_only]
    public fun mint_nft_for_test(ctx: &mut TxContext): NftAsset {
        mint_nft(b"TestNFT", ctx)
    }

    #[test_only]
    public fun make_rogue_cap(kiosk_id: ID, rogue_owner: address, ctx: &mut TxContext): KioskOwnerCap {
        KioskOwnerCap {
            id: object::new(ctx),
            kiosk_id,
            owner: rogue_owner, // Does not match real kiosk.owner
        }
    }

    #[test_only]
    public fun get_kiosk_owner(kiosk: &AgentKiosk): address {
        kiosk.owner
    }
}
