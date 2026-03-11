module examples::archival_event_safe {
    use sui::event;
    use sui::object::{Self, UID};

    /// VI: Event dùng để lưu trữ dữ liệu có thể chứng thực off-chain.
    /// EN: Event used for off-chain verifiable data storage.
    struct ArchiveEvent has copy, drop { data: vector<u8>, timestamp: u64 }

    public fun archive_data(data: vector<u8>, clock: &sui::clock::Clock) {
        event::emit(ArchiveEvent { 
            data, 
            timestamp: sui::clock::timestamp_ms(clock) 
        });
    }

    spec archive_data {
        // ensures data_emitted; // Conceptual
    }
}
