/// Module: safe::coin_management
/// VI: Pattern an toàn quản lý Coin trong Sui
/// EN: Safe pattern for Coin management in Sui
/// ZH: Sui 中代币管理的安全模式

module safe::coin_management {
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::tx_context::TxContext;

    /// VI: Withdraw coin an toàn – không để dư coin trong contract
    /// EN: Safe coin withdrawal – do not leave excess coins in the contract
    /// ZH: 安全提取代币 – 不要在合约中留下多余的代币
    public entry fun safe_withdraw<T>(coin: &mut Coin<T>, amount: u64, recipient: address, ctx: &TxContext) {
        let withdrawn = coin::split(coin, amount, ctx);
        transfer::public_transfer(withdrawn, recipient);
        // VI: Không giữ coin dư trong contract → giảm rủi ro
        // EN: Do not keep excess coins in the contract → reduce risk
        // ZH: 不要在合约中保留多余的代币 → 降低风险
    }

    /// VI: Merge coin an toàn – tránh overflow (Sui Coin có built-in check)
    /// EN: Safe coin merge – avoid overflow (Sui Coin has built-in checks)
    /// ZH: 安全合并代币 – 避免溢出（Sui Coin 具有内置检查）
    public entry fun safe_merge<T>(dest: &mut Coin<T>, source: Coin<T>) {
        coin::merge(dest, source);
    }
}

// VI: Best practice:
// EN: Best practices:
// ZH: 最佳实践：
// - VI: Không lưu Coin lâu dài trong contract (dễ bị lock).
// - EN: Do not store Coins in the contract for a long time (easy to get locked).
// - ZH: 不要长期在合约中存储代币（容易被锁定）。
// - VI: Luôn split + transfer ngay khi withdraw.
// - EN: Always split + transfer immediately upon withdrawal.
// - ZH: 提取时始终立即进行 split + transfer。
// - VI: Dùng Coin<T> chuẩn Sui thay vì custom balance.
// - EN: Use Sui standard Coin<T> instead of custom balance.
// - ZH: 使用 Sui 标准 Coin<T> 而不是自定义余额。