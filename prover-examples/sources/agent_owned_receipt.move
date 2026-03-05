module prover_examples::agent_owned_receipt {
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;

    /// Represent a user's isolated state (Owned Object) instead of a Shared Object Table.
    /// This prevents shared object congestion and allows parallel execution.
    struct UserReceipt has key, store {
        id: UID,
        owner: address,
        deposited_amount: u64,
        borrowed_amount: u64
    }

    /// Mint a new receipt for a user
    public fun mint_receipt(ctx: &mut TxContext) {
        let receipt = UserReceipt {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            deposited_amount: 0,
            borrowed_amount: 0
        };
        transfer::transfer(receipt, tx_context::sender(ctx));
    }

    /// Modify state purely via Owned Object
    public fun deposit(receipt: &mut UserReceipt, amount: u64) {
        receipt.deposited_amount = receipt.deposited_amount + amount;
    }

    spec module {
        pragma verify = true;
    }

    spec deposit {
        aborts_if receipt.deposited_amount + amount > MAX_U64;
        ensures receipt.deposited_amount == old(receipt.deposited_amount) + amount;
        ensures receipt.owner == old(receipt.owner);
    }
}
