/// VI: Mau an toan cho flash loan (hot potato) tren Sui.
/// EN: Safe pattern for flash loan (hot potato) on Sui.
/// ZH: Sui shang flash loan (hot potato) an toan mau hinh.
module safe::flash_loan {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    /// VI: Pool don gian de test.
    /// EN: Simple pool for tests.
    /// ZH: Yong yu ce shi de jian dan pool.
    struct Pool has store { balance: u64 }
    /// VI: FlashLoan phai bi huy trong cung tx.
    /// EN: FlashLoan must be destroyed in the same tx.
    /// ZH: FlashLoan xu yao zai cung tx bi xiao hui.
    struct FlashLoan has key { id: UID, amount: u64 }

    /// VI: Tao pool voi so du.
    /// EN: Create a pool with balance.
    /// ZH: Chuang jian you yu e de pool.
    public fun new_pool(balance: u64): Pool {
        Pool { balance }
    }

    /// VI: Doc so du pool.
    /// EN: Read pool balance.
    /// ZH: Du qu pool yu e.
    public fun pool_balance(pool: &Pool): u64 {
        pool.balance
    }

    /// VI: Muon flash loan va giam so du pool.
    /// EN: Borrow a flash loan and reduce pool balance.
    /// ZH: Jie chu flash loan bing jian shao pool yu e.
    public fun borrow_flash_loan(pool: &mut Pool, amount: u64, ctx: &mut TxContext): FlashLoan {
        pool.balance = pool.balance - amount;
        FlashLoan { id: object::new(ctx), amount }
    }

    /// VI: Hoan tra va tang so du pool.
    /// EN: Repay and increase pool balance.
    /// ZH: Gui hui bing zeng jia pool yu e.
    public entry fun repay_flash_loan(loan: FlashLoan, pool: &mut Pool) {
        let FlashLoan { id, amount } = loan;
        pool.balance = pool.balance + amount;
        object::delete(id);
    }
}
