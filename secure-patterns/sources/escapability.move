module dxd_audit::escapability {
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::tx_context::{TxContext};
    use sui::transfer;

    /// Treasury structure that can be escaped
    struct Treasury has key { 
        id: UID, 
        balance: Balance<SUI>,
        is_paused: bool
    }

    /// Normal withdraw (may be blocked by pause)
    public fun withdraw(treasury: &mut Treasury, amount: u64, ctx: &mut TxContext): Coin<SUI> {
        assert!(!treasury.is_paused, 0);
        coin::from_balance(balance::split(&mut treasury.balance, amount), ctx)
    }

    /// Emergency escape (always available)
    public fun escape_withdraw(treasury: &mut Treasury, ctx: &mut TxContext): Coin<SUI> {
        let amount = balance::value(&treasury.balance);
        coin::from_balance(balance::split(&mut treasury.balance, amount), ctx)
    }

    spec module {
        pragma verify = true;
    }

    spec escape_withdraw {
        ensures balance::value(treasury.balance) == 0;
        ensures coin::value(result) == old(balance::value(treasury.balance));
    }
}
