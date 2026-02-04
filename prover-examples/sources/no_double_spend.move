module prover_examples::no_double_spend {
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct Treasury has key, store {
        id: UID,
        balance: Balance&lt;SUI&gt;,
    }

    spec module {
        invariant forall addr: address where exists&lt;Treasury&gt;(addr) : balance::value(Treasury{addr}.balance) &gt;= 0;
    }

    public fun withdraw(treasury: &amp;mut Treasury, amount: u64, ctx: &amp;mut TxContext) {
        let bal = balance::value(&amp;treasury.balance);
        assert!(amount &lt;= bal, 1);
        let taken = balance::split(&amp;mut treasury.balance, amount);
        balance::destroy_zero(taken);
    }

    spec withdraw {
        aborts_if amount &gt; old(balance::value(&amp;treasury.balance));
        ensures balance::value(&amp;treasury.balance) == old(balance::value(&amp;treasury.balance)) - amount;
    }
}