module vuln_db::ms_capability_leak_wrapping {
    use sui::object::{Self, UID};
    use sui::coin::TreasuryCap;

    struct MintCap<phantom T> has key, store { id: UID, cap: TreasuryCap<T> }

    /// ❌ VULNERABLE: Individual capabilities wrapped in generic 'store' objects
    struct PublicProfileVulnerable<phantom T> has key, store {
        id: UID,
        mint_cap: MintCap<T>, 
    }

    /// ✅ FIXED: No storage for capability in public objects
    struct PublicProfileFixed has key {
        id: UID,
    }

    public fun extract_cap<T>(profile: PublicProfileVulnerable<T>): MintCap<T> {
        let PublicProfileVulnerable { id, mint_cap } = profile;
        object::delete(id);
        mint_cap
    }
}
