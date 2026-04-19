/// Agent Shared Object Consistency Prover Spec
/// Proves that shared object updates are bounded and consistent,
/// preventing "Hamsterwheel" style computation exhaustion on-chain.
module prover_examples::agent_shared_object_consistency {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};

    // ── Error codes ────────────────────────────────────────────────────────
    const E_ITERATION_LIMIT: u64 = 1;

    // Standard safety bound for on-chain loops
    const MAX_CONSISTENCY_ITERATIONS: u64 = 100;

    // ── Structs ────────────────────────────────────────────────────────────
    struct SharedState has key {
        id: UID,
        counter: u64,
        history: vector<u8>,
    }

    // ── Sync: bounded shared object update ──────────────────────────────────
    public fun sync_state(
        state: &mut SharedState,
        payload: vector<u8>,
        iterations: u64,
        _ctx: &mut TxContext
    ) {
        // Formal defense: strictly bound iterations to prevent gas/verifier DoS
        assert!(iterations <= MAX_CONSISTENCY_ITERATIONS, E_ITERATION_LIMIT);

        let i = 0;
        while (i < iterations) {
            state.counter = state.counter + 1;
            i = i + 1;
        };

        state.history = payload;
    }

    // ── Spec: formal verification properties ──────────────────────────────
    spec sync_state {
        pragma aborts_if_is_partial;

        // Safety Property 1: Must abort if iterations exceed safety bound
        // This mitigates "Hamsterwheel" style unbounded loops.
        aborts_if iterations > MAX_CONSISTENCY_ITERATIONS with E_ITERATION_LIMIT;

        // Post-condition: counter must increase exactly by iterations
        ensures state.counter == old(state.counter) + iterations;

        // Post-condition: history update matches payload
        ensures state.history == payload;
    }

    spec SharedState {
        // Invariant: counter remains within reasonable bounds for shared objects
        invariant counter < 18446744073709551615; // Max u64
    }
}
