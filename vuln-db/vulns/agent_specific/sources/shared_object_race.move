#[allow(lint(coin_field))]
module agent_specific::shared_object_race {
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    const E_RACE_CONDITION_EXPLOITED: u64 = 1;

    /// Shared treasury vault accessed by multiple agents concurrently
    public struct SharedTreasury has key {
        id: UID,
        balance: Coin<SUI>,
        extraction_locked: bool
    }

    public fun init_treasury(fund: Coin<SUI>, ctx: &mut TxContext) {
        let treasury = SharedTreasury {
            id: object::new(ctx),
            balance: fund,
            extraction_locked: false
        };
        transfer::share_object(treasury);
    }

    /// Vulnerable: Relies on two separate steps where state can change between transactions 
    /// due to Sui's parallel execution and agent asynchronous behavior.
    public fun prepare_extraction_vulnerable(treasury: &mut SharedTreasury) {
        treasury.extraction_locked = true;
    }

    public fun execute_extraction_vulnerable(
        treasury: &mut SharedTreasury, 
        amount: u64, 
        target: address, 
        ctx: &mut TxContext
    ) {
        assert!(treasury.extraction_locked == true, E_RACE_CONDITION_EXPLOITED);
        
        let extracted = coin::split(&mut treasury.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
        
        treasury.extraction_locked = false; // Reset
    }

    /// Fixed: Combines the lock and extraction into a single atomic PTB via programmable transaction blocks 
    /// or ensures strong consistency through Hot Potato pattern.
    /// Note: ExtractionTicket intentionally lacks `drop` and `store` abilities.
    /// This enforces the Hot-Potato pattern: once prepared, the extraction MUST be executed
    /// or the transaction will abort.
    public struct ExtractionTicket { amount: u64 }

    public fun prepare_extraction_fixed(treasury: &mut SharedTreasury, amount: u64): ExtractionTicket {
        treasury.extraction_locked = true;
        ExtractionTicket { amount }
    }

    public fun execute_extraction_fixed(
        treasury: &mut SharedTreasury, 
        ticket: ExtractionTicket,
        target: address, 
        ctx: &mut TxContext
    ) {
        let ExtractionTicket { amount } = ticket;
        assert!(treasury.extraction_locked == true, E_RACE_CONDITION_EXPLOITED);
        
        let extracted = coin::split(&mut treasury.balance, amount, ctx);
        transfer::public_transfer(extracted, target);
        
        treasury.extraction_locked = false; // Reset
    }

    #[test_only]
    public fun init_test(ctx: &mut TxContext) {
        let coin = coin::mint_for_testing<SUI>(100_000, ctx);
        init_treasury(coin, ctx);
    }

    #[test_only]
    public fun is_locked(treasury: &SharedTreasury): bool {
        treasury.extraction_locked
    }
}
