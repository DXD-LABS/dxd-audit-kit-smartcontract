module vuln_db::ms_phantom_type_bypass {
    use sui::balance::Balance;
    use sui::object::UID;

    /// ❌ VULNERABLE: Missing 'phantom' allowing compiler to perform 
    /// certain type substitutions in complex generic hierarchies.
    struct PoolVulnerable<T> has key {
        id: UID,
        balance: Balance<T>
    }

    /// ✅ FIXED: Use 'phantom' when T is only used in a phantom context 
    /// (like Balance<T> where T is just a tag).
    struct PoolFixed<phantom T> has key {
        id: UID,
        balance: Balance<T>
    }
}
