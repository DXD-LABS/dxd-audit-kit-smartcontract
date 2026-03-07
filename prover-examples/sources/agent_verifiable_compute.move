/// MSL Prover Specification: Verifiable Compute Integrity (Nautilus TEE)
/// Invariant: compute results accepted on-chain must match a valid, fresh,
/// hash-bound TEE attestation report.
/// Linked to AGENT-009 mitigation.
module prover_examples::agent_verifiable_compute {
    use std::vector;

    const E_ATTESTATION_FAIL: u64 = 1;
    const E_STALE_ATTESTATION: u64 = 2;
    const E_HASH_MISMATCH: u64 = 3;
    const MAX_STALE_EPOCHS: u64 = 10;

    public struct AttestationReport has drop {
        is_valid: bool,
        issued_epoch: u64,
        report_data: vector<u8>,
    }

    public struct ComputeResult has drop {
        output_hash: vector<u8>,
        approved: bool,
    }

    /// Verify a TEE attestation report and produce an approved ComputeResult.
    /// Post-conditions enforce: validity, freshness, and hash-binding.
    public fun verify_and_accept(
        report: AttestationReport,
        expected_input_hash: vector<u8>,
        current_epoch: u64,
    ): ComputeResult {
        assert!(report.is_valid, E_ATTESTATION_FAIL);
        assert!(current_epoch - report.issued_epoch <= MAX_STALE_EPOCHS, E_STALE_ATTESTATION);
        assert!(report.report_data == expected_input_hash, E_HASH_MISMATCH);
        ComputeResult {
            output_hash: expected_input_hash,
            approved: true,
        }
    }

    spec verify_and_accept {
        /// Result is approved only when attestation is valid, fresh, and hash matches
        ensures result.approved == true;
        ensures result.output_hash == expected_input_hash;
        aborts_if !report.is_valid with E_ATTESTATION_FAIL;
        aborts_if current_epoch - report.issued_epoch > MAX_STALE_EPOCHS with E_STALE_ATTESTATION;
        aborts_if report.report_data != expected_input_hash with E_HASH_MISMATCH;
    }
}
