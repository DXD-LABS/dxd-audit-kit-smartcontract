module examples::time_incentive_safe {
    use sui::clock::{Self, Clock};
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    /// VI: Stake record lưu trữ thời gian bắt đầu để tính toán phần thưởng.
    /// EN: Stake record stores start time for reward calculation.
    struct Stake has key { id: UID, start_time: u64, amount: u64 }

    public fun calculate_reward(stake: &Stake, clock: &Clock): u64 {
        let current_time = clock::timestamp_ms(clock);
        assert!(current_time >= stake.start_time, 1002); // E_INVALID_TIME
        let duration = current_time - stake.start_time;
        stake.amount * (duration / 86400000) // Reward per day (approx)
    }

    spec calculate_reward {
        aborts_if clock.timestamp_ms < stake.start_time;
        ensures result >= 0;
    }
}
