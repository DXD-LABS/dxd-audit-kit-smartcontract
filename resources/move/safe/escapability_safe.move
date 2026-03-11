module examples::escapability_safe {
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::tx_context::TxContext;
    use sui::sui::SUI;

    /// VI: Vault hỗ trợ cơ chế emergency withdraw (escape).
    /// EN: Vault supporting emergency withdraw (escape) mechanism.
    struct Vault has key { id: UID, balance: Balance<SUI> }

    public fun emergency_withdraw(vault: &mut Vault, ctx: &mut TxContext): Coin<SUI> {
        let amount = balance::value(&vault.balance);
        assert!(amount > 0, 1003); // E_EMPTY_VAULT
        coin::from_balance(balance::withdraw_all(&mut vault.balance), ctx)
    }

    spec emergency_withdraw {
        aborts_if balance::value(vault.balance) == 0;
        ensures balance::value(vault.balance) == 0;
    }
}
