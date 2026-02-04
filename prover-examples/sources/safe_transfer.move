module prover_examples::safe_transfer {
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::tx_context::TxContext;

    spec module {
    }

    public fun transfer_safe&lt;T&gt;(coin: &amp;mut Coin&lt;T&gt;, amount: u64, recipient: address, ctx: &amp;mut TxContext) {
        let value = coin::value(coin);
        assert!(amount &lt;= value, 1);
        let split = coin::split(coin, amount, ctx);
        transfer::public_transfer(split, recipient);
    }

    spec transfer_safe {
        aborts_if amount &gt; coin::value(coin);
        ensures exists&lt;Coin&lt;T&gt;&gt;(recipient);
        ensures old(coin::value(coin)) == coin::value(coin) + amount;
    }
}