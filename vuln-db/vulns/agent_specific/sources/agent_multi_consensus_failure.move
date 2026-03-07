module agent_specific::agent_multi_consensus_failure {

    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::table::{Self, Table};

    const E_NOT_APPROVED: u64 = 1;
    const E_UNKNOWN_AGENT: u64 = 2;
    const E_ALREADY_VOTED: u64 = 3;


    /// Admin capability — only the holder may register agents
    public struct SwarmAdminCap has key, store { id: UID }

    /// Shared consensus object for multi-agent swarm votes
    public struct SwarmConsensus has key {
        id: UID,
        threshold: u64,
        /// Raw (unverified) approve count — vulnerable path uses this
        approve_count: u64,
        /// Verified approve count — fixed path uses this
        verified_votes: u64,
        approved: bool,
        /// Registry of known/registered agent addresses (admin-gated)
        registered_agents: Table<address, bool>,
        voted: Table<address, bool>,
    }

    /// Shared vault that gets drained when consensus approves
    #[allow(lint(coin_field))]
    public struct SwarmVault has key {
        id: UID,
        balance: Coin<SUI>,
        drain_amount: u64,
    }

    public fun create_consensus(threshold: u64, ctx: &mut TxContext): SwarmAdminCap {
        let consensus = SwarmConsensus {
            id: object::new(ctx),
            threshold,
            approve_count: 0,
            verified_votes: 0,
            approved: false,
            registered_agents: table::new(ctx),
            voted: table::new(ctx),
        };
        transfer::share_object(consensus);
        SwarmAdminCap { id: object::new(ctx) }
    }

    public fun create_vault(fund: Coin<SUI>, drain_amount: u64, ctx: &mut TxContext) {
        let vault = SwarmVault {
            id: object::new(ctx),
            balance: fund,
            drain_amount,
        };
        transfer::share_object(vault);
    }

    // -------------------------------------------------------------------------
    // VULNERABLE: any caller can cast an unverified vote
    // -------------------------------------------------------------------------
    /// ❌ No access control on register_agent — an attacker self-registers
    public fun register_agent_vulnerable(
        consensus: &mut SwarmConsensus,
        agent: address,
    ) {
        // ❌ No admin check — attacker can register themselves
        table::add(&mut consensus.registered_agents, agent, true);
    }

    public fun cast_vote_vulnerable(
        consensus: &mut SwarmConsensus,
        approve: bool,
        _ctx: &mut TxContext,
    ) {
        // ❌ No signature check — any caller increments approve_count
        if (approve) {
            consensus.approve_count = consensus.approve_count + 1;
        };
        // Threshold met by unverified votes → approved set to true
        if (consensus.approve_count >= consensus.threshold) {
            consensus.approved = true;
        };
    }

    public fun execute_if_approved_vulnerable(
        consensus: &SwarmConsensus,
        vault: &mut SwarmVault,
        target: address,
        ctx: &mut TxContext,
    ) {
        assert!(consensus.approved, E_NOT_APPROVED);
        let extracted = coin::split(&mut vault.balance, vault.drain_amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    // -------------------------------------------------------------------------
    // FIXED: AdminCap gates registration; registered-only agents vote; dedup
    // -------------------------------------------------------------------------
    /// ✅ Only AdminCap holder can register legitimate agents
    public fun register_agent(
        _admin: &SwarmAdminCap,
        consensus: &mut SwarmConsensus,
        agent: address,
    ) {
        // ✅ Caller must hold SwarmAdminCap — prevents self-registration sybil attack
        table::add(&mut consensus.registered_agents, agent, true);
    }

    public fun cast_vote_fixed(
        consensus: &mut SwarmConsensus,
        approve: bool,
        ctx: &mut TxContext,
    ) {
        let sender = ctx.sender();
        // ✅ Only registered agents may vote
        assert!(table::contains(&consensus.registered_agents, sender), E_UNKNOWN_AGENT);
        // ✅ Each agent votes at most once (dedup)
        assert!(!table::contains(&consensus.voted, sender), E_ALREADY_VOTED);
        table::add(&mut consensus.voted, sender, true);
        if (approve) {
            consensus.verified_votes = consensus.verified_votes + 1;
        };
        if (consensus.verified_votes >= consensus.threshold) {
            consensus.approved = true;
        };
    }

    public fun execute_if_approved_fixed(
        consensus: &SwarmConsensus,
        vault: &mut SwarmVault,
        target: address,
        ctx: &mut TxContext,
    ) {
        // ✅ Uses verified_votes path; approved is only set when threshold met by real agents
        assert!(consensus.approved, E_NOT_APPROVED);
        let extracted = coin::split(&mut vault.balance, vault.drain_amount, ctx);
        transfer::public_transfer(extracted, target);
    }

    // -------------------------------------------------------------------------
    // Test helpers
    // -------------------------------------------------------------------------
    #[test_only]
    public fun init_test(threshold: u64, ctx: &mut TxContext): SwarmAdminCap {
        let coin = coin::mint_for_testing<SUI>(500_000, ctx);
        let cap = create_consensus(threshold, ctx);
        create_vault(coin, 200_000, ctx);
        cap
    }

    #[test_only]
    public fun get_approve_count(consensus: &SwarmConsensus): u64 {
        consensus.approve_count
    }

    #[test_only]
    public fun get_verified_votes(consensus: &SwarmConsensus): u64 {
        consensus.verified_votes
    }

    #[test_only]
    public fun is_approved(consensus: &SwarmConsensus): bool {
        consensus.approved
    }
}
