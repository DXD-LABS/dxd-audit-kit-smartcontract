/// Module: safe::oracle_safe
/// Description: 
/// EN: Secure pattern for oracle integration (e.g., Pyth or Switchboard).
/// VI: Pattern an toàn tích hợp oracle (ví dụ Pyth hoặc Switchboard).
/// ZH: 预言机集成的安全模式（例如 Pyth 或 Switchboard）。

module safe::oracle_safe {
    use sui::clock::Clock;

    struct PriceData has key {
        id: UID,
        price: u64,
        timestamp: u64,
        max_age: u64,  // Max stale time
    }

    public fun update_price(price_data: &mut PriceData, new_price: u64, clock: &Clock) {
        let current = clock::timestamp_ms(clock);
        assert!(current - price_data.timestamp <= price_data.max_age, 0); // Not stale
        price_data.price = new_price;
        price_data.timestamp = current;
    }
}

// Best practice:
// EN: Always check staleness and max_age to prevent price manipulation.
// VI: Luôn kiểm tra tính cập nhật (staleness) và max_age để tránh thao túng giá.
// ZH: 务必检查陈旧度和 max_age 以防止价格操纵。