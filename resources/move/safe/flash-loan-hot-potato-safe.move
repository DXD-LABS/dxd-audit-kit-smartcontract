/// Module: safe::flash_loan
/// Description: Pattern an toÃ n cho Flash Loan (Hot Potato) trÃªn Sui | Safe pattern for Flash Loan (Hot Potato) on Sui | Sui ä¸Šé—ªç”µè´·ï¼ˆHot Potatoï¼‰çš„å®‰å…¨æ¨¡å¼
/// Flash loan Sui dÃ¹ng "hot potato" (object táº¡m thá»i) â€“ pháº£i tráº£ láº¡i trong cÃ¹ng tx | Sui flash loans use "hot potato" (temporary object) â€“ must be returned in the same tx | Sui é—ªç”µè´·ä½¿ç”¨â€œhot potatoâ€ï¼ˆä¸´æ—¶å¯¹è±¡ï¼‰â€”â€”å¿…é¡»åœ¨åŒä¸€ä¸ªäº¤æ˜“ä¸­è¿”å›ž

module safe::flash_loan {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    /// VI: Pool don gian de test va demo.
    /// EN: Simple pool for tests and demo.
    /// ZH: Yong yu ce shi he demo de jian dan pool.
    struct Pool has store { balance: u64 }
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

    /// Borrow flash loan â€“ tráº£ object láº¡i trong cÃ¹ng tx | Borrow flash loan â€“ return the object in the same tx | å€Ÿç”¨é—ªç”µè´· â€”â€” åœ¨åŒä¸€ä¸ªäº¤æ˜“ä¸­è¿”å›žå¯¹è±¡
    public fun borrow_flash_loan(pool: &mut Pool, amount: u64, ctx: &mut TxContext): FlashLoan {
        pool.balance = pool.balance - amount;
        FlashLoan { id: object::new(ctx), amount }
    }

    /// Repay flash loan â€“ pháº£i gá»i trong cÃ¹ng tx, khÃ´ng drop loan | Repay flash loan â€“ must be called in the same tx, cannot drop loan | å¿è¿˜é—ªç”µè´· â€”â€” å¿…é¡»åœ¨åŒä¸€ä¸ªäº¤æ˜“ä¸­è°ƒç”¨ï¼Œä¸èƒ½ä¸¢å¼ƒè´·æ¬¾
    public entry fun repay_flash_loan(loan: FlashLoan, pool: &mut Pool) {
        let FlashLoan { id, amount } = loan;
        pool.balance = pool.balance + amount;
        object::delete(id); // Destroy object an toÃ n | Safe object destruction | å®‰å…¨çš„å¯¹è±¡é”€æ¯
    }
}

// Best practice: FlashLoan cÃ³ key (khÃ´ng store), pháº£i destroy trong tx â†’ Ä‘áº£m báº£o repay. | Best practice: FlashLoan has key (no store), must be destroyed in tx â†’ ensures repayment. | æœ€ä½³å®žè·µï¼šFlashLoan å…·æœ‰ keyï¼ˆæ—  storeï¼‰ï¼Œå¿…é¡»åœ¨äº¤æ˜“ä¸­é”€æ¯ â†’ ç¡®ä¿è¿˜æ¬¾ã€‚
