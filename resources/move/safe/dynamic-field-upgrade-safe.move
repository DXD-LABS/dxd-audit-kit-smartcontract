/// Module: safe::dynamic_field_upgrade
/// Description: Pattern an toàn dùng Dynamic Fields khi upgrade | Safe pattern using Dynamic Fields for upgrades | 升级时使用动态字段的安全模式

module safe::dynamic_field_upgrade {
    use sui::dynamic_field;
    use sui::object::{Self, UID};

    struct Config has key {
        id: UID,
        version: u64,
    }

    public fun add_field(config: &mut Config, key: vector<u8>, value: u64) {
        if (dynamic_field::exists_(&config.id, key)) {
            dynamic_field::borrow_mut(&mut config.id, key) = value;
        } else {
            dynamic_field::add(&mut config.id, key, value);
        }
    }
}

// Best practice: Check exists trước add/borrow_mut để tránh overwrite sai. | Best practice: Check exists before add/borrow_mut to avoid incorrect overwrites. | 最佳实践：在 add/borrow_mut 之前检查是否存在，以避免错误的覆盖。