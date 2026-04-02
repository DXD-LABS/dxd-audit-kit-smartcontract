module vuln_db::ms_resource_leak_dynamic_field {
    use sui::object::{Self, UID};
    use sui::dynamic_field;

    struct Parent has key, store {
        id: UID,
    }

    /// ❌ VULNERABLE: id is deleted, but dynamic fields attached to it remain
    public fun vuln_delete_parent(parent: Parent) {
        let Parent { id } = parent;
        object::delete(id);
    }

    /// ✅ FIXED: Explicitly remove dynamic fields before deleting ID
    public fun fixed_delete_parent(parent: Parent) {
        let Parent { id } = parent;
        if (dynamic_field::exists_(&id, b"field_key")) {
            let _: u64 = dynamic_field::remove(&mut id, b"field_key");
        };
        object::delete(id);
    }
}
