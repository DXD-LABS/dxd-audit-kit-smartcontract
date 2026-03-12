module dxd_audit::gas_fund {
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};
    use sui::transfer;

    /// Dedicated fund for object storage and gas costs
    struct GasFund has key { 
        id: UID, 
        fund: Balance<SUI> 
    }

    /// Initialize a new gas fund
    public fun create_fund(ctx: &mut TxContext) {
        let fund = GasFund {
            id: object::new(ctx),
            fund: balance::zero()
        };
        transfer::share_object(fund);
    }

    /// Deposit SUI into the gas fund
    public fun deposit_gas(fund: &mut GasFund, amount: Coin<SUI>) {
        balance::join(&mut fund.fund, coin::into_balance(amount));
    }

    /// Extract gas (only possible for authorized maintenance, e.g., via AdminCap)
    /// This is a simplified version
    public fun extract_gas(fund: &mut GasFund, amount: u64, ctx: &mut TxContext): Coin<SUI> {
        coin::from_balance(balance::split(&mut fund.fund, amount), ctx)
    }
}
