/// MSL Prover Specification: ZK Intent Privacy Invariant
/// Invariant: executing a zk intent must never write sensitive (raw) data to on-chain state.
/// Linked to AGENT-008 mitigation.
module prover_examples::agent_zk_intent_privacy {
    use sui::object::UID;
    use std::vector;
    use std::hash;

    const E_PRIVACY_VIOLATION: u64 = 1;
    const E_OVERSIZED: u64 = 2;

    public struct ZkIntentProof has drop {
        is_valid: bool,
        exposes_sensitive_data: bool,
        public_inputs: vector<u8>,
        amount: u64,
    }

    public struct AgentWallet has key {
        id: UID,
        /// Only commitment hashes stored — never raw intent data
        last_intent_hash: vector<u8>,
    }

    /// Execute a zk-intent while preserving privacy invariant.
    /// Post-condition: wallet.last_intent_hash is a 32-byte Blake2b commitment,
    /// never the raw public_inputs.
    public fun execute_with_privacy(
        proof: ZkIntentProof,
        wallet: &mut AgentWallet,
    ) {
        assert!(proof.is_valid, 1);
        // MSL: abort if proof exposes sensitive data
        assert!(!proof.exposes_sensitive_data, E_PRIVACY_VIOLATION);
        // Only store commitment hash on-chain
        let commitment = hash::blake2b256(&proof.public_inputs);
        wallet.last_intent_hash = commitment;
    }

    spec execute_with_privacy {
        /// No sensitive data from proof flows into wallet state directly
        ensures wallet.last_intent_hash == hash::blake2b256(proof.public_inputs);
        /// Proof must not expose sensitive data (privacy invariant)
        aborts_if proof.exposes_sensitive_data with E_PRIVACY_VIOLATION;
        aborts_if !proof.is_valid with 1;
    }
}
