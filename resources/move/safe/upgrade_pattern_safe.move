module examples::upgrade_pattern_safe {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    /// VI: UpgradeCap quản lý phiên bản của package.
    /// EN: UpgradeCap manages the package version.
    struct UpgradeCap has key { id: UID, version: u64 }

    public fun upgrade(cap: &mut UpgradeCap, new_version: u64) {
        assert!(new_version > cap.version, 1004); // E_INVALID_VERSION
        cap.version = new_version;
    }

    spec upgrade {
        aborts_if new_version <= cap.version;
        ensures cap.version == new_version;
    }
}
