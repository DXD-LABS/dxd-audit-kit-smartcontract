module examples::object_centric_safe {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    /// VI: Object-centric tránh global state, giảm tranh chấp shared objects.
    /// EN: Object-centric avoids global state, reducing shared object contention.
    struct MyObject has key { id: UID, value: u64 }

    public fun create_object(value: u64, ctx: &mut TxContext): MyObject {
        MyObject { id: object::new(ctx), value }
    }

    /// VI: Update trực tiếp trên object thay vì qua global storage.
    /// EN: Update directly on object instead of via global storage.
    public fun update_object(obj: &mut MyObject, new_value: u64) {
        obj.value = new_value;
    }
}
