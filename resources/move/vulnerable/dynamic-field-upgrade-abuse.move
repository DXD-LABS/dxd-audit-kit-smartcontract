/// Module: vuln::dynamic_field_abuse
/// Description: LỖI – Dynamic field overwrite không check version | ERROR – Dynamic field overwrite without version check | 错误 – 动态字段覆盖未检查版本

module vuln::dynamic_field_abuse {
    use sui::dynamic_field;

    public fun unsafe_add_field(config: &mut Config, key: vector<u8>, value: u64) {
        dynamic_field::add(&mut config.id, key, value); // LỖ HỔNG: Overwrite field cũ mà không check version | VULNERABILITY: Overwriting old field without version check | 漏洞：覆盖旧字段且未检查版本
    }
}

// Risk: Medium – Data corruption khi upgrade | Risk: Medium – Data corruption during upgrade | 风险：中 – 升级期间数据损坏
// Fix: Check version hoặc dùng bag/table cho upgrade-safe storage. | Fix: Check version or use bag/table for upgrade-safe storage. | 修复：检查版本或对升级安全存储使用 bag/table。