/// Module: safe::coin_split_merge
/// Description: Pattern an toàn split/merge Coin trong Sui | Safe pattern for split/merge Coin in Sui | Sui 中 Coin 拆分/合并的安全模式

module safe::coin_split_merge {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::tx_context::TxContext;

    public entry fun safe_split<T>(coin: &mut Coin<T>, amount: u64, recipient: address, ctx: &mut TxContext) {
        let split = coin::split(coin, amount, ctx);
        transfer::public_transfer(split, recipient);
    }

    public entry fun safe_merge<T>(dest: &mut Coin<T>, source: Coin<T>) {
        coin::merge(dest, source);
    }
}

// Best practice: Dùng coin::split/merge chuẩn, không custom balance để tránh overflow. | Best practice: Use standard coin::split/merge, avoid custom balance to prevent overflow. | 最佳实践：使用标准的 coin::split/merge，避免自定义余额以防止溢出。