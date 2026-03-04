module prover_examples::agent_intent_verification {

    struct IntentRecord has drop {
        intent_hash: vector<u8>,
        intent_verified: bool,
    }

    struct ActionIntent has drop {
        intent_hash: vector<u8>,
    }

    const E_INTENT_MISMATCH: u64 = 1;

    public fun execute_action(record: &mut IntentRecord, action: ActionIntent) {
        assert!(record.intent_hash == action.intent_hash, E_INTENT_MISMATCH);
        record.intent_verified = true;
    }

    spec execute_action {
        pragma aborts_if_is_partial;
        aborts_if record.intent_hash != action.intent_hash with E_INTENT_MISMATCH;
        ensures record.intent_hash == old(record.intent_hash);
        ensures record.intent_verified == true;
        modifies record.intent_verified;
    }

    spec IntentRecord {
        invariant intent_verified == true;
    }
}
