module dxd_audit::time_incentivization {
    use sui::clock::{Self, Clock};
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    /// Error codes
    const E_TOO_EARLY: u64 = 0;

    /// Vesting schedule for rewards
    struct Vesting has key { 
        id: UID, 
        start: u64, 
        amount: u64,
        period: u64
    }

    /// Create a new vesting schedule
    public fun create_vesting(amount: u64, period: u64, clock: &Clock, ctx: &mut TxContext) {
        let vesting = Vesting {
            id: object::new(ctx),
            start: clock::timestamp_ms(clock),
            amount,
            period
        };
        transfer::transfer(vesting, tx_context::sender(ctx));
    }

    /// Release vested amount based on elapsed time
    public fun release(vesting: &mut Vesting, clock: &Clock): u64 {
        let current_time = clock::timestamp_ms(clock);
        let elapsed = current_time - vesting.start;
        
        let release_amount = if (elapsed >= vesting.period) {
            let amount = vesting.amount;
            vesting.amount = 0;
            amount
        } else {
            let release = (vesting.amount * elapsed) / vesting.period;
            vesting.amount = vesting.amount - release;
            release
        };
        
        release_amount
    }

    spec module {
        pragma verify = true;
    }

    spec release {
        let elapsed = clock.timestamp_ms - vesting.start;
        ensures elapsed >= vesting.period ==> result == old(vesting.amount);
        ensures elapsed < vesting.period ==> result == (old(vesting.amount) * elapsed) / vesting.period;
    }
}
