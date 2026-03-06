/// Nautilus TEE Computation Integrity Prover Spec
/// Proves that an on-chain receipt is only minted when the TEE report hash
/// matches the committed input hash — ensuring computation integrity.
module prover_examples::nautilus_computation_integrity {

    use sui::table::{Self, Table};

    // ── Error codes ────────────────────────────────────────────────────────
    const E_INTEGRITY_FAIL:  u64 = 1;
    const E_ALREADY_MINTED:  u64 = 2;

    // ── Structs ────────────────────────────────────────────────────────────
    struct ComputationCommit has drop {
        input_hash:   vector<u8>,   // committed before TEE execution
        tee_hash:     vector<u8>,   // TEE report_data after execution
    }

    struct MintedReceipts has key {
        id:       sui::object::UID,
        registry: Table<vector<u8>, bool>,  // input_hash → minted
    }

    struct Receipt has key, store {
        id:         sui::object::UID,
        input_hash: vector<u8>,
        verified:   bool,
    }

    // ── Mint: only if TEE hash matches committed input hash ────────────────
    public fun mint_receipt(
        commit:   &ComputationCommit,
        registry: &mut MintedReceipts,
        ctx:      &mut sui::tx_context::TxContext,
    ): Receipt {
        // 1. TEE report hash must match committed input
        assert!(commit.tee_hash == commit.input_hash, E_INTEGRITY_FAIL);

        // 2. Prevent double-minting
        assert!(
            !table::contains(&registry.registry, commit.input_hash),
            E_ALREADY_MINTED
        );

        // 3. Record minting
        table::add(&mut registry.registry, commit.input_hash, true);

        Receipt {
            id:         sui::object::new(ctx),
            input_hash: commit.input_hash,
            verified:   true,
        }
    }

    // ── Spec: formal verification properties ──────────────────────────────
    spec mint_receipt {
        pragma aborts_if_is_partial;

        aborts_if commit.tee_hash != commit.input_hash
            with E_INTEGRITY_FAIL;
        aborts_if table::spec_contains(registry.registry, commit.input_hash)
            with E_ALREADY_MINTED;

        // Receipt is verified on success
        ensures result.verified == true;
        ensures result.input_hash == commit.input_hash;

        // Registry grows by exactly 1 entry
        ensures table::spec_len(registry.registry)
             == old(table::spec_len(registry.registry)) + 1;
    }

    spec Receipt {
        // Invariant: any Receipt object must have verified = true
        invariant verified == true;
    }
}
