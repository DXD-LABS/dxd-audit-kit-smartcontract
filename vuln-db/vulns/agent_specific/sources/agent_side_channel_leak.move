module agent_specific::agent_side_channel_leak {
    use sui::dynamic_field;
    use sui::hash;

    const E_OVERSIZED_MEMORY: u64 = 1;
    const E_SIZE_MISMATCH: u64 = 2;

    /// Fixed block size for constant-time/constant-size memory writes (256 bytes)
    const FIXED_BLOCK_SIZE: u64 = 256;

    /// Agent wallet whose memory access patterns may leak via gas/size side-channels
    public struct AgentWallet has key {
        id: UID,
        owner: address,
    }

    public fun create_wallet(ctx: &mut TxContext) {
        let wallet = AgentWallet {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
        };
        transfer::share_object(wallet);
    }

    // -------------------------------------------------------------------------
    // VULNERABLE: variable-length data stored on-chain → gas/size side-channel
    // -------------------------------------------------------------------------
    /// Writes raw variable-length memory_data to dynamic field.
    /// An observer can infer the length (and content hints) from:
    /// - Object byte size delta in on-chain state
    /// - Gas consumption difference between small vs. large writes
    public fun store_memory_vulnerable(
        wallet: &mut AgentWallet,
        memory_data: vector<u8>,
        key: vector<u8>,
        _ctx: &mut TxContext,
    ) {
        // ❌ Variable-length write — leaks data via size/gas side-channel
        dynamic_field::add(&mut wallet.id, key, memory_data);
    }

    // -------------------------------------------------------------------------
    // FIXED: pad to FIXED_BLOCK_SIZE; store only Blake2b commitment on-chain
    // -------------------------------------------------------------------------
    public fun store_memory_fixed(
        wallet: &mut AgentWallet,
        memory_data: vector<u8>,
        key: vector<u8>,
        _ctx: &mut TxContext,
    ) {
        // ✅ Reject if data already exceeds the fixed block
        assert!(vector::length(&memory_data) <= FIXED_BLOCK_SIZE, E_OVERSIZED_MEMORY);
        // ✅ Pad to exactly FIXED_BLOCK_SIZE — constant gas + constant on-chain size
        let mut padded = memory_data;
        while (vector::length(&padded) < FIXED_BLOCK_SIZE) {
            vector::push_back(&mut padded, 0u8);
        };
        assert!(vector::length(&padded) == FIXED_BLOCK_SIZE, E_SIZE_MISMATCH);
        // ✅ Only store commitment hash — not raw data
        let commitment = hash::blake2b256(&padded);
        dynamic_field::add(&mut wallet.id, key, commitment);
    }

    // -------------------------------------------------------------------------
    // Test helpers
    // -------------------------------------------------------------------------
    #[test_only]
    public fun init_test(ctx: &mut TxContext) {
        create_wallet(ctx);
    }

    #[test_only]
    public fun make_small_payload(): vector<u8> {
        let mut v = vector::empty<u8>();
        vector::push_back(&mut v, 0xABu8);
        v  // 1 byte — minimal gas
    }

    #[test_only]
    public fun make_large_payload(): vector<u8> {
        let mut v = vector::empty<u8>();
        let mut i = 0u64;
        while (i < 200) {
            vector::push_back(&mut v, 0xFFu8);
            i = i + 1;
        };
        v  // 200 bytes — higher gas; reveals larger secret
    }

    #[test_only]
    public fun fixed_block_size(): u64 { FIXED_BLOCK_SIZE }

    #[test_only]
    public fun has_dynamic_field(wallet: &AgentWallet, key: vector<u8>): bool {
        dynamic_field::exists_(&wallet.id, key)
    }
}
