/// zk-Nullifier Uniqueness Prover Spec
/// Proves that the nullifier registry is append-only and
/// a zk-intent proof can only be consumed once (no double-spend/replay).
/// Extends the no_double_spend pattern with explicit nullifier semantics.
module prover_examples::zk_nullifier_uniqueness {

    use sui::table::{Self, Table};

    // ── Error codes ────────────────────────────────────────────────────────
    const E_DOUBLE_SPEND: u64 = 1;
    const E_EMPTY_NULLIFIER: u64 = 2;

    // ── Structs ────────────────────────────────────────────────────────────
    struct NullifierRegistry has key {
        id:       sui::object::UID,
        registry: Table<vector<u8>, bool>,  // nullifier → consumed
        count:    u64,
    }

    struct IntentProof has drop {
        nullifier:   vector<u8>,  // Hash(commitment_hash || "nullifier")
        intent_hash: vector<u8>,
        is_valid:    bool,
    }

    // ── Add nullifier: aborts if already exists ────────────────────────────
    public fun add_nullifier(
        registry: &mut NullifierRegistry,
        proof:    &IntentProof,
    ) {
        // 1. Nullifier must be non-empty
        assert!(!vector::is_empty(&proof.nullifier), E_EMPTY_NULLIFIER);

        // 2. Nullifier must NOT already exist (no replay)
        assert!(
            !table::contains(&registry.registry, proof.nullifier),
            E_DOUBLE_SPEND
        );

        // 3. Record nullifier as spent
        table::add(&mut registry.registry, proof.nullifier, true);
        registry.count = registry.count + 1;
    }

    // ── Query: check if nullifier exists ──────────────────────────────────
    public fun is_spent(
        registry: &NullifierRegistry,
        nullifier: vector<u8>,
    ): bool {
        table::contains(&registry.registry, nullifier)
    }

    // ── Specs ──────────────────────────────────────────────────────────────
    spec add_nullifier {
        pragma aborts_if_is_partial;

        aborts_if vector::is_empty(proof.nullifier)
            with E_EMPTY_NULLIFIER;
        aborts_if table::spec_contains(registry.registry, proof.nullifier)
            with E_DOUBLE_SPEND;

        // Registry grows by exactly 1 — append-only property
        ensures table::spec_len(registry.registry)
             == old(table::spec_len(registry.registry)) + 1;
        ensures registry.count == old(registry.count) + 1;

        // The nullifier is now recorded as spent
        ensures table::spec_contains(registry.registry, proof.nullifier);

        // Existing nullifiers are NOT removed — append-only invariant
        ensures forall nf: vector<u8>:
            old(table::spec_contains(registry.registry, nf))
                ==> table::spec_contains(registry.registry, nf);
    }

    spec is_spent {
        ensures result == table::spec_contains(registry.registry, nullifier);
    }

    spec NullifierRegistry {
        // Registry count matches table length
        invariant count == table::spec_len(registry);
    }
}
