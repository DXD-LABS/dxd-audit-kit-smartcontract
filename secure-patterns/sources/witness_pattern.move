module dxd_audit::witness_pattern {
    use sui::tx_context::{TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;

    /// The One-Time Witness (OTW) for this module
    /// Must be named after the module and must have the 'drop' ability.
    struct WITNESS_PATTERN has drop {}

    /// Dummy witness for generic constraints
    struct GenericWitness has drop {}

    /// Example of a function requiring a witness
    public fun initialize_guarded<W: drop>(_witness: W, ctx: &mut TxContext) {
        // This function can only be called if the caller can produce the witness
        let dummy = DummyObject { id: object::new(ctx) };
        transfer::transfer(dummy, @0x0);
    }

    struct DummyObject has key { id: UID }

    spec module {
        pragma verify = true;
    }
}
