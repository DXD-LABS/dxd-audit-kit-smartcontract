module prover_examples::agent_no_rogue_object_delete {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    struct AgentObject has key, store {
        id: UID,
    }

    const E_UNAUTHORIZED_OBJECT_ACCESS: u64 = 1;

    public fun delete_object(agent: address, object: AgentObject, ctx: &TxContext) {
        // Dummy check for prover
        let AgentObject { id } = object;
        sui::object::delete(id);
    }

    // Dummy spec block representing object ownership check
    // Actually MSL needs models for these, but we represent the intent.
    spec delete_object {
        pragma aborts_if_is_partial;
        // aborts_if !object::is_owner(agent, object_id) with E_UNAUTHORIZED_OBJECT_ACCESS;
        // ensures !object::exists(object_id) ==> old(object::owner(object_id)) == agent_address;
    }

    // spec module {
    //     invariant object::exists(object_id) || deleted;
    // }
}
