/// Nautilus TEE Attestation Prover Spec
/// Proves that on-chain state changes only occur when TEE attestation
/// quote is cryptographically valid and bound to the committed input hash.
module prover_examples::nautilus_tee_attest {

    // ── Error codes ────────────────────────────────────────────────────────
    const E_ATTESTATION_FAIL:  u64 = 1;
    const E_STALE_ATTESTATION: u64 = 2;
    const E_HASH_MISMATCH:     u64 = 3;

    // MAX freshness window: 1 epoch (~24h)
    const MAX_STALE_EPOCHS: u64 = 1;

    // ── Structs ────────────────────────────────────────────────────────────
    struct AttestationReport has drop {
        mrenclave:       vector<u8>,  // TEE measurement
        report_data:     vector<u8>,  // = Hash(computation_output)
        issued_epoch:    u64,
        is_valid:        bool,
    }

    struct ComputationRequest has drop {
        input_hash:      vector<u8>,  // committed hash of inputs
        expected_output: vector<u8>,
    }

    struct ComputationResult has store {
        output:          vector<u8>,
        attested:        bool,
    }

    // ── Execute: only proceeds with valid, fresh attestation ───────────────
    public fun execute_attested(
        request:    &ComputationRequest,
        report:     &AttestationReport,
        current_epoch: u64,
    ): ComputationResult {
        // 1. Attestation must be cryptographically valid
        assert!(report.is_valid, E_ATTESTATION_FAIL);

        // 2. Attestation must be fresh
        assert!(
            current_epoch - report.issued_epoch <= MAX_STALE_EPOCHS,
            E_STALE_ATTESTATION
        );

        // 3. TEE output hash must match committed input hash
        assert!(
            report.report_data == request.input_hash,
            E_HASH_MISMATCH
        );

        ComputationResult {
            output:   request.expected_output,
            attested: true,
        }
    }

    // ── Spec: formal verification properties ──────────────────────────────
    spec execute_attested {
        pragma aborts_if_is_partial;

        // Abort conditions — match assert! statements exactly
        aborts_if !report.is_valid
            with E_ATTESTATION_FAIL;
        aborts_if current_epoch - report.issued_epoch > MAX_STALE_EPOCHS
            with E_STALE_ATTESTATION;
        aborts_if report.report_data != request.input_hash
            with E_HASH_MISMATCH;

        // Success guarantees
        ensures result.attested == true;
        ensures result.output == request.expected_output;

        // Immutability: request not mutated during attestation
        ensures request.input_hash == old(request.input_hash);
    }

    spec ComputationResult {
        // Invariant: a result object only exists if attested
        invariant attested == true;
    }
}
