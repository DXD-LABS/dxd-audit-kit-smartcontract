module agent_specific::agent_unaudited_lib_vuln {

    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::table::{Self, Table};

    const E_UNVERIFIED_AUDITOR: u64 = 1;
    const E_UNAUDITED_LIB: u64 = 2;
    const E_ALREADY_REGISTERED: u64 = 3;


    // =========================================================================
    // Simulated unaudited malicious library (embedded as inner module for PoC)
    // In a real attack, this would be an external package dependency.
    // =========================================================================

    /// Backdoor AdminCap that should never be publicly mintable
    public struct BadAdminCap has key, store {
        id: UID,
    }

    /// Protocol AdminCap — only the holder can whitelist auditors
    public struct ProtocolAdminCap has key, store {
        id: UID,
    }

    /// ❌ VULNERABLE: any caller can mint an AdminCap via this backdoor
    public fun backdoor_mint_cap(ctx: &mut TxContext): BadAdminCap {
        BadAdminCap { id: object::new(ctx) }
    }

    // =========================================================================
    // Agent module that consumes the unaudited lib
    // =========================================================================

    /// Agent config that holds treasury and audit registry
    #[allow(lint(coin_field))]
    public struct AgentConfig has key {
        id: UID,
        treasury: Coin<SUI>,
        audit_verified: bool,
        auditor: address,
        /// Whitelisted auditor addresses (set by protocol admin)
        whitelisted_auditors: Table<address, bool>,
    }

    public fun create_agent_config(fund: Coin<SUI>, ctx: &mut TxContext): ProtocolAdminCap {
        let config = AgentConfig {
            id: object::new(ctx),
            treasury: fund,
            audit_verified: false,
            auditor: @0x0,
            whitelisted_auditors: table::new(ctx),
        };
        transfer::share_object(config);
        ProtocolAdminCap { id: object::new(ctx) }
    }

    // -------------------------------------------------------------------------
    // VULNERABLE: whitelist_auditor open to any caller — anyone can self-whitelist
    // -------------------------------------------------------------------------
    /// ❌ No access control: attacker calls this, then register_lib_audit, then use_lib_fixed
    public fun whitelist_auditor_vulnerable(
        config: &mut AgentConfig,
        auditor: address,
        _ctx: &mut TxContext,
    ) {
        // ❌ No admin check — any caller can whitelist themselves
        if (!table::contains(&config.whitelisted_auditors, auditor)) {
            table::add(&mut config.whitelisted_auditors, auditor, true);
        }
    }

    // -------------------------------------------------------------------------
    // FIXED: whitelist_auditor gated by ProtocolAdminCap
    // -------------------------------------------------------------------------
    /// ✅ Only the ProtocolAdminCap holder can whitelist auditors
    public fun whitelist_auditor(
        _admin: &ProtocolAdminCap,
        config: &mut AgentConfig,
        auditor: address,
        _ctx: &mut TxContext,
    ) {
        // ✅ admin cap check is implicit — Move capability-based access control
        if (!table::contains(&config.whitelisted_auditors, auditor)) {
            table::add(&mut config.whitelisted_auditors, auditor, true);
        }
    }

    // -------------------------------------------------------------------------
    // VULNERABLE: agent uses unaudited lib function — backdoor is accessible
    // -------------------------------------------------------------------------
    /// Any caller invokes backdoor_mint_cap from the unaudited lib directly.
    /// Since `backdoor_mint_cap` is public, an attacker gets a BadAdminCap
    /// and can use it to bypass any cap-gated functions downstream.
    public fun use_lib_vulnerable(ctx: &mut TxContext) {
        // ❌ Directly calling the unaudited lib's backdoor
        let cap = backdoor_mint_cap(ctx);
        transfer::public_transfer(cap, ctx.sender());
    }

    // -------------------------------------------------------------------------
    // FIXED: lib must be verified before use; audit_verified flag required
    // -------------------------------------------------------------------------
    public fun register_lib_audit(
        config: &mut AgentConfig,
        ctx: &mut TxContext,
    ) {
        let sender = ctx.sender();
        // ✅ Only whitelisted auditors can verify the lib
        assert!(
            table::contains(&config.whitelisted_auditors, sender),
            E_UNVERIFIED_AUDITOR
        );
        assert!(!config.audit_verified, E_ALREADY_REGISTERED);
        config.audit_verified = true;
        config.auditor = sender;
    }

    public fun use_lib_fixed(
        config: &AgentConfig,
        _ctx: &mut TxContext,
    ) {
        // ✅ Abort if the lib dependency has not been audited and registered
        assert!(config.audit_verified, E_UNAUDITED_LIB);
        // Safe lib usage only after audit gate passes
    }

    // -------------------------------------------------------------------------
    // Test helpers
    // -------------------------------------------------------------------------
    #[test_only]
    public fun init_test(ctx: &mut TxContext): ProtocolAdminCap {
        let coin = coin::mint_for_testing<SUI>(100_000, ctx);
        create_agent_config(coin, ctx)
    }

    #[test_only]
    public fun get_audit_verified(config: &AgentConfig): bool {
        config.audit_verified
    }

    #[test_only]
    public fun get_auditor(config: &AgentConfig): address {
        config.auditor
    }
}
