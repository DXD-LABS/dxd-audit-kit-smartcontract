/// Agent Policy Guard Prover Spec
/// Proves that delegated capabilities can only be used when
/// an explicit action intent has been verified by the policy engine.
module prover_examples::agent_policy_guard {
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    // ── Error codes ────────────────────────────────────────────────────────
    const E_POLICY_VIOLATION: u64 = 1;
    const E_UNAUTHORIZED:     u64 = 2;

    // ── Structs ────────────────────────────────────────────────────────────
    struct AgentContext has key, store {
        id: sui::object::UID,
        treasury: Coin<SUI>,
        policy_root: vector<u8>, // Root of authorized policies
    }

    struct ActionIntent has drop {
        target: address,
        amount: u64,
        verified: bool,
    }

    // ── Execute: only proceeds if intent is verified ────────────────────────
    public fun vault_transfer(
        agent: &mut AgentContext,
        intent: &ActionIntent,
        ctx: &mut TxContext
    ) {
        // Formal check: intent MUST be verified by a trusted authority
        // before reaching this point.
        assert!(intent.verified == true, E_POLICY_VIOLATION);

        // Authorization check
        assert!(tx_context::sender(ctx) != intent.target, E_UNAUTHORIZED);

        let extracted = coin::split(&mut agent.treasury, intent.amount, ctx);
        transfer::public_transfer(extracted, intent.target);
    }

    // ── Spec: formal verification properties ──────────────────────────────
    spec vault_transfer {
        pragma aborts_if_is_partial;

        // Safety Property 1: Must abort if intent is not verified
        aborts_if !intent.verified with E_POLICY_VIOLATION;

        // Safety Property 2: Must abort if unauthorized (self-transfer prevention)
        aborts_if tx_context::sender(ctx) == intent.target with E_UNAUTHORIZED;

        // Post-condition: Treasury balance must decrease exactly by amount
        ensures agent.treasury.value == old(agent.treasury.value) - intent.amount;

        // Post-condition: Intent remains immutable
        ensures intent.verified == old(intent.verified);
    }

    spec AgentContext {
        // Invariant: treasury must always have some dust for gas/ops
        // (Simplified for example)
        invariant agent.treasury.value >= 0;
    }
}
