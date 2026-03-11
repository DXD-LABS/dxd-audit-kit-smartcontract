module examples::circuit_breaker_safe {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    /// VI: ContractState chứa flag paused để tạm dừng hoạt động.
    /// EN: ContractState contains a paused flag to halt operations.
    struct ContractState has key { id: UID, paused: bool }
    struct AdminCap has key { id: UID }

    public fun pause(state: &mut ContractState, _cap: &AdminCap) {
        state.paused = true;
    }

    public fun resume(state: &mut ContractState, _cap: &AdminCap) {
        state.paused = false;
    }

    public fun perform_action(state: &ContractState) {
        assert!(!state.paused, 1001); // E_PAUSED
        // Logic thực thi ở đây
    }

    spec perform_action {
        aborts_if state.paused;
    }
}
