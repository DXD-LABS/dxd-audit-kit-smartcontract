/// Module: vuln::flash_loan_abuse
/// Description: LỖI – Flash loan không destroy → leak object | ERROR – Flash loan not destroyed → object leak | 错误 – 闪电贷未销毁 → 对象泄漏

module vuln::flash_loan_abuse {
    struct FlashLoan has key { id: UID, amount: u64 }

    public fun borrow_flash_loan(pool: &mut Pool, amount: u64, ctx: &mut TxContext): FlashLoan {
        FlashLoan { id: object::new(ctx), amount }
    }

    // LỖ HỔNG: Không bắt buộc repay/destroy → attacker giữ loan mãi | VULNERABILITY: Repay/destroy not enforced → attacker can keep the loan indefinitely | 漏洞：未强制还款/销毁 → 攻击者可以永久保留贷款
}

// Risk: High – Storage leak, DoS | Risk: High – Storage leak, DoS | 风险：高 – 存储泄漏，DoS
// Fix: Bắt buộc destroy trong repay function. | Fix: Enforce destruction in the repay function. | 修复：在 repay 函数中强制销毁。