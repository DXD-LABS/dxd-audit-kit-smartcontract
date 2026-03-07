#[allow(lint(coin_field))]
module agent_specific::agent_zk_intent_leak {
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::dynamic_field;
    use sui::hash;

    const E_PROOF_INVALID: u64 = 1;
    const E_PRIVACY_VIOLATION: u64 = 2;

    /// Simulated zk intent proof struct
    public struct ZkIntentProof has drop {
        is_valid: bool,
        /// If true, public_inputs contain sensitive data (wallet balance, intent details)
        exposes_sensitive_data: bool,
        /// Raw public inputs — may contain sensitive data in the vulnerable path
        public_inputs: vector<u8>,
        amount: u64,
    }

    /// Agent wallet holding user funds and memory via dynamic fields
    public struct AgentWallet has key {
        id: UID,
        balance: Coin<SUI>,
    }

    public fun create_wallet(fund: Coin<SUI>, ctx: &mut TxContext) {
        let wallet = AgentWallet {
            id: object::new(ctx),
            balance: fund,
        };
        transfer::share_object(wallet);
    }

    /// Creates a proof that exposes sensitive data (simulates weak zk verification)
    public fun make_leaky_proof(
        amount: u64,
        sensitive_payload: vector<u8>,
    ): ZkIntentProof {
        ZkIntentProof {
            is_valid: true,
            exposes_sensitive_data: true,   // ← weak proof: data visible in public_inputs
            public_inputs: sensitive_payload,
            amount,
        }
    }

    /// Creates a properly private proof (no sensitive data in public inputs)
    public fun make_private_proof(amount: u64): ZkIntentProof {
        ZkIntentProof {
            is_valid: true,
            exposes_sensitive_data: false,
            public_inputs: vector::empty<u8>(),
            amount,
        }
    }

    // -------------------------------------------------------------------------
    // VULNERABLE: proof accepted without privacy field check
    // -------------------------------------------------------------------------
    /// Writes raw public_inputs into dynamic field — observable by any on-chain reader.
    public fun execute_zk_intent_vulnerable(
        proof: ZkIntentProof,
        wallet: &mut AgentWallet,
        _ctx: &mut TxContext,
    ) {
        assert!(proof.is_valid, E_PROOF_INVALID);
        // ❌ Sensitive data written verbatim to on-chain dynamic field
        dynamic_field::add(&mut wallet.id, b"last_intent", proof.public_inputs);
    }

    // -------------------------------------------------------------------------
    // FIXED: full field check + only commitment hash stored on-chain
    // -------------------------------------------------------------------------
    public fun execute_zk_intent_fixed(
        proof: ZkIntentProof,
        wallet: &mut AgentWallet,
        _ctx: &mut TxContext,
    ) {
        assert!(proof.is_valid, E_PROOF_INVALID);
        // ✅ Guard: abort if proof leaks sensitive data in public inputs
        assert!(!proof.exposes_sensitive_data, E_PRIVACY_VIOLATION);
        // ✅ Only write Blake2b commitment — not raw data
        let commitment = hash::blake2b256(&proof.public_inputs);
        dynamic_field::add(&mut wallet.id, b"last_intent_hash", commitment);
    }

    // -------------------------------------------------------------------------
    // Test helpers
    // -------------------------------------------------------------------------
    #[test_only]
    public fun init_test(ctx: &mut TxContext) {
        let coin = coin::mint_for_testing<SUI>(1_000_000, ctx);
        create_wallet(coin, ctx);
    }

    #[test_only]
    public fun make_leaky_proof_for_test(amount: u64): ZkIntentProof {
        let mut payload = vector::empty<u8>();
        vector::push_back(&mut payload, 0xDE);
        vector::push_back(&mut payload, 0xAD);
        vector::push_back(&mut payload, 0xBE);
        vector::push_back(&mut payload, 0xEF);
        make_leaky_proof(amount, payload)
    }

    #[test_only]
    public fun make_private_proof_for_test(amount: u64): ZkIntentProof {
        make_private_proof(amount)
    }

    #[test_only]
    public fun proof_exposes_sensitive(proof: &ZkIntentProof): bool {
        proof.exposes_sensitive_data
    }

    #[test_only]
    public fun has_dynamic_field_last_intent(wallet: &AgentWallet): bool {
        dynamic_field::exists_(&wallet.id, b"last_intent")
    }

    #[test_only]
    public fun has_dynamic_field_last_intent_hash(wallet: &AgentWallet): bool {
        dynamic_field::exists_(&wallet.id, b"last_intent_hash")
    }
}
