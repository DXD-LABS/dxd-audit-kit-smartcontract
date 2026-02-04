module prover_examples::lending_collateral {
    /// Lending loan struct
    struct Loan has drop { borrowed: u64, collateral_value: u64 }

    /// Borrow if over-collateralized (150%)
    public fun borrow(amount: u64, coll_value: u64): Loan {
        assert!(coll_value >= amount * 150 / 100, 100);
        Loan {
            borrowed: amount,
            collateral_value: coll_value
        }
    }

    spec module {
        pragma verify = true;
    }

    spec borrow {
        aborts_if coll_value < amount * 150 / 100;
        ensures result.borrowed == amount;
        ensures result.collateral_value >= result.borrowed * 150 / 100;
    }
}