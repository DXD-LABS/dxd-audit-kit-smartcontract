/// zk-Intent Verification Prover Spec
/// Proves that an action can only execute when a zk-proof is valid
/// and the intent commitment was made before the execution transaction.
/// Extends the agent_intent_verification pattern with commitment ordering.
module prover_examples::zk_intent_verify {

    // ── Error codes ────────────────────────────────────────────────────────
    const E_PROOF_INVALID:     u64 = 1;
    const E_NOT_COMMITTED:     u64 = 2;
    const E_HASH_MISMATCH:     u64 = 3;

    // ── Structs ────────────────────────────────────────────────────────────
    struct IntentCommitment has store {
        commitment_hash: vector<u8>,  // Hash(action || params || randomness)
        committed:       bool,         // true after commit tx
    }

    struct ZkProof has drop {
        intent_hash: vector<u8>,  // the hash this proof attests to
        proof_bytes: vector<u8>,  // Groth16/Plonk proof bytes (opaque)
        is_valid:    bool,         // set by on-chain verifier
    }

    struct ActionRecord has store {
        intent_hash: vector<u8>,
        executed:    bool,
    }

    // ── Commit: must happen before execute ─────────────────────────────────
    public fun commit_intent(
        record: &mut IntentCommitment,
        hash:   vector<u8>,
    ) {
        record.commitment_hash = hash;
        record.committed = true;
    }

    // ── Execute: only proceeds with valid committed proof ──────────────────
    public fun execute_action(
        commitment: &IntentCommitment,
        proof:      &ZkProof,
        action:     &mut ActionRecord,
    ) {
        // 1. Intent must have been committed in a prior tx
        assert!(commitment.committed, E_NOT_COMMITTED);

        // 2. Proof must be valid (verified by on-chain zk verifier)
        assert!(proof.is_valid, E_PROOF_INVALID);

        // 3. Proof must attest to the committed hash
        assert!(
            proof.intent_hash == commitment.commitment_hash,
            E_HASH_MISMATCH
        );

        action.intent_hash = commitment.commitment_hash;
        action.executed = true;
    }

    // ── Specs ──────────────────────────────────────────────────────────────
    spec commit_intent {
        ensures record.committed == true;
        ensures record.commitment_hash == hash;
    }

    spec execute_action {
        pragma aborts_if_is_partial;

        aborts_if !commitment.committed
            with E_NOT_COMMITTED;
        aborts_if !proof.is_valid
            with E_PROOF_INVALID;
        aborts_if proof.intent_hash != commitment.commitment_hash
            with E_HASH_MISMATCH;

        // Success guarantees
        ensures action.executed == true;
        ensures action.intent_hash == commitment.commitment_hash;

        // Commitment not mutated during execution
        ensures commitment.commitment_hash == old(commitment.commitment_hash);
        ensures commitment.committed == old(commitment.committed);
    }

    spec IntentCommitment {
        // If committed is true, commitment_hash must be non-empty
        invariant committed ==> len(commitment_hash) > 0;
    }

    spec ActionRecord {
        invariant executed ==> len(intent_hash) > 0;
    }
}
