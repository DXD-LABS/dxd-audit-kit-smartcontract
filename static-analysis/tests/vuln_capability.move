module 0x1::vuln_capability {
    use sui::object::{Self, UID};

    struct Dummy has key, store {
        id: UID,
    }

    public fun flash_loan_without_guard(dummy: &mut Dummy) {
        // placeholder to trigger custom regex rules
        let _ = dummy;
    }
}
