/// Module: vuln::dos_loop
/// VI: Ví dụ LỖI – DoS qua loop đắt trong entry function
/// EN: VULNERABILITY Example – DoS via expensive loop in entry function
/// ZH: 漏洞示例 – entry 函数中由于昂贵循环导致的 DoS

module vuln::dos_loop {
    use sui::vec_map::{Self, VecMap};

    struct Leaderboard has key {
        id: UID,
        scores: VecMap<address, u64>,
    }

    /// VI: LỖ HỔNG: Loop qua toàn bộ map → gas explosion nếu map lớn
    /// EN: VULNERABILITY: Loop through the entire map → gas explosion if map is large
    /// ZH: 漏洞：遍历整个 map → 如果 map 很大，会导致 gas 爆炸
    public entry fun get_top_players(board: &Leaderboard, n: u64): vector<address> {
        let mut top = vector::empty<address>();
        let keys = vec_map::keys(&board.scores);
        let len = vector::length(&keys);
        let mut i = 0;
        while (i < len && i < n) {
        let key = *vector::borrow(&keys, i);
        vector::push_back(&mut top, key);
        i = i + 1;
        }
        top
    }
}

// VI: Risk: Medium-High – Attacker spam add entry → function get_top đắt, DoS
// EN: Risk: Medium-High – Attacker spam add entry → get_top function becomes expensive, DoS
// ZH: 风险：中高 – 攻击者恶意添加条目 → get_top 函数变得昂贵，导致 DoS

// VI: Fix:
// EN: Fix:
// ZH: 修复：
// - VI: Giới hạn size map.
// - EN: Limit map size.
// - ZH: 限制 map 大小。
// - VI: Dùng off-chain indexer cho leaderboard.
// - EN: Use off-chain indexer for leaderboard.
// - ZH: 为排行榜使用链下索引器。
// - VI: Hoặc pagination thay loop full.
// - EN: Or use pagination instead of full loop.
// - ZH: 或使用分页代替完整循环。