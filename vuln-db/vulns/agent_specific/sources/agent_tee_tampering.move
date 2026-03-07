module agent_specific::agent_tee_tampering {
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    const E_ATTESTATION_FAIL: u64 = 1;
    const E_STALE_ATTESTATION: u64 = 2;
    const E_HASH_MISMATCH: u64 = 3;
    const E_NOT_APPROVED: u64 = 4;
    const E_UNKNOWN_ACTION: u64 = 5;

    const MAX_STALE_EPOCHS: u64 = 10;
    const ACTION_TRANSFER: u8 = 1;

    /// Simulates a TEE attestation report from Nautilus/Intel SGX
    public struct AttestationReport has drop {
        is_valid: bool,
        issued_epoch: u64,
        /// report_data field binds the attestation to a specific input hash
        report_data: vector<u8>,
    }

    /// Represents compute output emitted by off-chain agent inference
    public struct ComputeResult has drop {
        action: u8,
        amount: u64,
        target: address,
    }

    /// Shared vault controlled by an agent
    #[allow(lint(coin_field))]
    public struct AgentVault has key {
        id: UID,
        balance: Coin<SUI>,
    }

    public fun create_vault(fund: Coin<SUI>, ctx: &mut TxContext) {
        let vault = AgentVault { id: object::new(ctx), balance: fund };
        transfer::share_object(vault);
    }

    // -------------------------------------------------------------------------
    // VULNERABLE: compute result accepted without any attestation check
    // -------------------------------------------------------------------------
    public fun accept_compute_vulnerable(
        action: u8,
        amount: u64,
        target: address,
        vault: &mut AgentVault,
        ctx: &mut TxContext,
    ) {
        // ❌ No attestation check — rogue/tampered output accepted as truth
        if (action == ACTION_TRANSFER) {
            let extracted = coin::split(&mut vault.balance, amount, ctx);
            transfer::public_transfer(extracted, target);
        } else {
            // ❌ Unknown action silently ignored
        }
    }

    // -------------------------------------------------------------------------
    // FIXED: attestation validity + freshness + hash-binding required;
    //        unknown action codes abort
    // -------------------------------------------------------------------------
    public fun accept_compute_fixed(
        action: u8,
        amount: u64,
        target: address,
        report: AttestationReport,
        expected_input_hash: vector<u8>,
        current_epoch: u64,
        vault: &mut AgentVault,
        ctx: &mut TxContext,
    ) {
        // ✅ Attestation must be valid
        assert!(report.is_valid, E_ATTESTATION_FAIL);
        // ✅ Must not be stale (replay protection)
        assert!(current_epoch - report.issued_epoch <= MAX_STALE_EPOCHS, E_STALE_ATTESTATION);
        // ✅ report_data must match committed input hash (binding)
        assert!(report.report_data == expected_input_hash, E_HASH_MISMATCH);
        // ✅ Only known action codes proceed; unknown codes abort
        if (action == ACTION_TRANSFER) {
            let extracted = coin::split(&mut vault.balance, amount, ctx);
            transfer::public_transfer(extracted, target);
        } else {
            abort E_UNKNOWN_ACTION
        }
    }

    // -------------------------------------------------------------------------
    // Test helpers
    // -------------------------------------------------------------------------
    #[test_only]
    public fun init_test(ctx: &mut TxContext) {
        let coin = coin::mint_for_testing<SUI>(200_000, ctx);
        create_vault(coin, ctx);
    }

    #[test_only]
    public fun make_invalid_report(): AttestationReport {
        AttestationReport {
            is_valid: false,
            issued_epoch: 0,
            report_data: vector[],
        }
    }

    #[test_only]
    public fun make_stale_report(): AttestationReport {
        AttestationReport {
            is_valid: true,
            issued_epoch: 0, // issued at epoch 0, current is e.g. 200 → stale
            report_data: vector[0xCAu8, 0xFEu8],
        }
    }

    #[test_only]
    public fun make_valid_report(epoch: u64, input_hash: vector<u8>): AttestationReport {
        AttestationReport {
            is_valid: true,
            issued_epoch: epoch,
            report_data: input_hash,
        }
    }

    #[test_only]
    public fun action_transfer(): u8 { ACTION_TRANSFER }
}
