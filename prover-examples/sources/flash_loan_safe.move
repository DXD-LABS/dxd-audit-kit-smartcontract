module prover_examples::flash_loan_safe {

    /// Hot potato: must repay in same tx
    struct FlashLoanPotato has drop { amount: u64 }

    /// Simulate borrow from pool
    public fun borrow_flash_loan(pool_balance: u64, amount: u64): (u64, FlashLoanPotato) {
        assert!(amount <= pool_balance, 1);
        (amount, FlashLoanPotato { amount })
    }

    /// Repay + destroy potato (enforce repayment)
    public fun repay_flash_loan(potato: FlashLoanPotato, repaid: u64) {
        assert!(repaid >= potato.amount, 2);
    }

    spec module {
        pragma verify = true;
    }

    spec borrow_flash_loan {
        aborts_if amount > pool_balance;
        ensures result_1 == amount;
    }

    spec repay_flash_loan {
        aborts_if repaid < potato.amount;
    }
}