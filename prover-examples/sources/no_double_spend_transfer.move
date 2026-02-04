module examples::no_double_spend_transfer {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::tx_context::TxContext;

    // Simulate transfer từ sender → recipient, verify no double-spend
    public fun safe_transfer&lt;C&gt;(from: &amp;mut Coin&lt;C&gt;, amount: u64, recipient: &amp;mut Coin&lt;C&gt;, ctx: &amp;mut TxContext) {
        let value = coin::value(from);
        assert!(amount &lt;= value, 300);  // Insufficient balance abort
        let split = coin::split(from, amount, ctx);
        coin::join(recipient, split);
    }

    spec module {
        pragma verify = true;
        // Global invariant: Balance của bất kỳ coin nào không âm
        invariant forall addr: address where exists&lt;Coin&lt;C&gt;&gt;(addr): coin::value(exists&lt;Coin&lt;C&gt;&gt;(addr)) &gt;= 0;
    }

    spec safe_transfer {
        aborts_if amount &gt; old(coin::value(from));
        // Post: Sender balance giảm đúng amount
        ensures coin::value(from) == old(coin::value(from)) - amount;
        // Post: Recipient balance tăng đúng amount (no double-spend)
        ensures coin::value(recipient) == old(coin::value(recipient)) + amount;
        // Invariant hold sau transfer: Tổng balance conserve
        ensures global_balance&lt;C&gt;() == old(global_balance&lt;C&gt;());
    }

    // Helper spec cho global balance (giả sử track total supply)
    spec fun global_balance&lt;C&gt;(): u64 {
        // Simplified: Tổng tất cả coin&lt;C&gt; value
        // Trong thực tế, dùng aggregate từ framework
        0  // Placeholder, extend với real impl
    }
}