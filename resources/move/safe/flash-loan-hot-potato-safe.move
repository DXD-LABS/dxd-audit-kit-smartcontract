/// Module: safe::flash_loan
/// Description: Pattern an toàn cho Flash Loan (Hot Potato) trên Sui | Safe pattern for Flash Loan (Hot Potato) on Sui | Sui 上闪电贷（Hot Potato）的安全模式
/// Flash loan Sui dùng "hot potato" (object tạm thời) – phải trả lại trong cùng tx | Sui flash loans use "hot potato" (temporary object) – must be returned in the same tx | Sui 闪电贷使用“hot potato”（临时对象）——必须在同一个交易中返回

module safe::flash_loan {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct FlashLoan has key { id: UID, amount: u64 }

    /// Borrow flash loan – trả object lại trong cùng tx | Borrow flash loan – return the object in the same tx | 借用闪电贷 —— 在同一个交易中返回对象
    public fun borrow_flash_loan(pool: &mut Pool, amount: u64, ctx: &mut TxContext): FlashLoan {
        let loan = FlashLoan { id: object::new(ctx), amount };
        // Logic pool giảm balance...
        loan
    }

    /// Repay flash loan – phải gọi trong cùng tx, không drop loan | Repay flash loan – must be called in the same tx, cannot drop loan | 偿还闪电贷 —— 必须在同一个交易中调用，不能丢弃贷款
    public entry fun repay_flash_loan(loan: FlashLoan, pool: &mut Pool) {
        // Logic pool tăng balance + fee... | Pool logic: increase balance + fee... | 池逻辑：增加余额 + 手续费...
        let FlashLoan { id, amount: _ } = loan;
        object::delete(id); // Destroy object an toàn | Safe object destruction | 安全的对象销毁
    }
}

// Best practice: FlashLoan có key (không store), phải destroy trong tx → đảm bảo repay. | Best practice: FlashLoan has key (no store), must be destroyed in tx → ensures repayment. | 最佳实践：FlashLoan 具有 key（无 store），必须在交易中销毁 → 确保还款。