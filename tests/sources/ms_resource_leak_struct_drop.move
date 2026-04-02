module vuln_db::ms_resource_leak_struct_drop {
    struct InternalAsset { value: u64 } // No drop

    /// ❌ VULNERABLE: If condition is true, Move compiler catches the 'forgetting' error, 
    /// but logic flaws allow 'storing' in dynamic fields that are never cleaned up.
    public fun vuln_handle_asset(asset: InternalAsset, condition: bool) {
        if (condition) {
            // An attempt to 'forget' asset or move it to a sink that doesn't clean it up
            let _: InternalAsset = asset; 
            abort 0
        } else {
            let InternalAsset { value: _ } = asset; // Correctly unpacked
        }
    }

    /// ✅ FIXED: Ensure all paths consume/unpack the resource
    public fun fixed_handle_asset(asset: InternalAsset) {
        let InternalAsset { value: _ } = asset;
    }

    public fun create_asset(value: u64): InternalAsset {
        InternalAsset { value }
    }
}
