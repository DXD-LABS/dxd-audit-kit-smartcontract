/// MSL Prover Specification: Multi-Agent Consensus Guard
/// Invariant: consensus.approved is true only when verified_votes >= threshold,
/// where each verified vote belongs to a registered agent.
/// Linked to AGENT-010 mitigation.
module prover_examples::agent_multi_consensus_guard {

    const E_UNKNOWN_AGENT: u64 = 1;
    const E_ALREADY_VOTED: u64 = 2;
    const E_NOT_APPROVED: u64 = 3;

    public struct ConsensusState has drop {
        threshold: u64,
        verified_votes: u64,
        registered_count: u64,
        approved: bool,
    }

    /// Cast a verified vote — caller must be a registered agent.
    /// Post-condition: approved iff verified_votes >= threshold.
    public fun cast_verified_vote(
        state: &mut ConsensusState,
        is_registered: bool,
        already_voted: bool,
        approve: bool,
    ) {
        assert!(is_registered, E_UNKNOWN_AGENT);
        assert!(!already_voted, E_ALREADY_VOTED);
        if (approve) {
            state.verified_votes = state.verified_votes + 1;
        };
        if (state.verified_votes >= state.threshold) {
            state.approved = true;
        };
    }

    spec cast_verified_vote {
        /// Must abort if caller is not a registered agent
        aborts_if !is_registered with E_UNKNOWN_AGENT;
        /// Must abort if agent already voted (replay prevention)
        aborts_if already_voted with E_ALREADY_VOTED;
        /// Approval only follows when verified threshold is met
        ensures state.approved ==> state.verified_votes >= state.threshold;
        /// verified_votes never exceeds registered_count
        ensures state.verified_votes <= state.registered_count;
    }

    /// Execute only if consensus is approved.
    public fun execute_if_consensus(state: &ConsensusState) {
        assert!(state.approved, E_NOT_APPROVED);
        // ... downstream action
    }

    spec execute_if_consensus {
        aborts_if !state.approved with E_NOT_APPROVED;
        /// Execution requires verified quorum
        requires state.approved ==> state.verified_votes >= state.threshold;
    }
}
