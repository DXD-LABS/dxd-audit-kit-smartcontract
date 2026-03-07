/// MSL Prover Specification: Kiosk Ownership Safety
/// Invariant: NFT transfers out of a kiosk by an agent must always verify
/// cap.owner == kiosk.owner before extraction. Transfer policy must be enforced.
/// Linked to AGENT-011 mitigation.
module prover_examples::kiosk_ownership_safe {

    const E_OWNER_MISMATCH: u64 = 1;
    const E_POLICY_VIOLATION: u64 = 2;

    public struct KioskState has drop {
        owner: address,
        policy_enforced: bool,
    }

    public struct KioskCapState has drop {
        kiosk_owner_field: address,
    }

    public struct TransferRequest has drop {
        authorized: bool,
    }

    /// Authorize an NFT transfer — cap.owner must match kiosk.owner
    /// and transfer policy must be enforced.
    public fun authorize_transfer(
        kiosk: &KioskState,
        cap: &KioskCapState,
        policy_confirmed: bool,
    ): TransferRequest {
        assert!(cap.kiosk_owner_field == kiosk.owner, E_OWNER_MISMATCH);
        assert!(kiosk.policy_enforced && policy_confirmed, E_POLICY_VIOLATION);
        TransferRequest { authorized: true }
    }

    spec authorize_transfer {
        /// Transfer request is authorized only when ownership and policy are verified
        ensures result.authorized == true;
        /// Owner must match
        aborts_if cap.kiosk_owner_field != kiosk.owner with E_OWNER_MISMATCH;
        /// Policy must be enforced
        aborts_if !kiosk.policy_enforced || !policy_confirmed with E_POLICY_VIOLATION;
    }
}
