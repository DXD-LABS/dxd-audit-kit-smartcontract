# Chiến Lược Nâng Cấp Package (Sui Upgrade Strategy) | Sui Package Upgrade Strategy | Sui 包升级策略

Trên Sui, mã nguồn (Smart Contract/Packages) là **bất biến (immutable)** nhưng có thể **nâng cấp được (upgradable)** thông qua việc phát hành một Package ID hoàn toàn mới nối tiếp phiên bản cũ. Quyền trượng thực thi việc này là `UpgradeCap`. | On Sui, source code (Smart Contracts/Packages) is **immutable** but **upgradable** by releasing a completely new Package ID following the old version. The execution authority for this is `UpgradeCap`. | 在 Sui 上，源代码（智能合约/包）是**不可变（immutable）**的，但可以通过发布一个全新且继承旧版本的 Package ID 来**升级（upgradable）**。执行此操作的权限是 `UpgradeCap`。

## 1. Giấu UpgradeCap: Đừng để lộ điểm yếu | Hide UpgradeCap: Don't Expose Weakness | 隐藏 UpgradeCap：不要暴露弱点

Khi chạy lệnh Publish cơ bản của Sui CLI, `UpgradeCap` mặc định sẽ bay mọc vào địa chỉ ví cá nhân (Sender). | When running the basic Sui CLI Publish command, `UpgradeCap` defaults to the personal wallet address (Sender). | 运行基本的 Sui CLI Publish 命令时，`UpgradeCap` 默认归属于个人钱包地址 (Sender)。

**Best Practice:** Ngay từ lúc viết Code, giấu `UpgradeCap` vào trong một Object Quản trị dùng Multisig, hoặc khóa cứng vĩnh viễn nếu Project đã ổn định (`make_immutable`). | **Best Practice:** Hide `UpgradeCap` in a Multisig Management Object right from the start, or make it permanently immutable once the project is stable (`make_immutable`). | **最佳实践：** 从开始编写代码时，就将 `UpgradeCap` 隐藏在多重签名管理对象中，或者在项目稳定后将其永久冻结（`make_immutable`）。

## 2. Lỗ Hồng Gọi Phiên Bản Cũ Của Người Dùng | Version Calling Attack | 版本调用攻击

TRÊN SUI, CẢ V1 VÀ V2 CÙNG TỒN TẠI VÀ CÙNG HOẠT ĐỘNG. Hacker hoàn toàn tự do tạo PTB trực tiếp gọi hàm bị lỗi ở Package ID V1. | ON SUI, BOTH V1 AND V2 COEXIST AND OPERATE. Hackers are free to create PTBs directly calling the faulty function in Package ID V1. | 在 SUI 上，V1 和 V2 共存且都在运行。黑客可以自由创建直接调用 Package ID V1 中错误函数的 PTB。

### Giải Pháp: Version Control Object | Solution: Version Control Object (VCO) | 解决方案：版本控制对象 (VCO)

Bạn phải mã hóa cơ chế kiểm tra Phiên bản trực tiếp vào trong cấu trúc cốt lõi của App. | You must encode the Version checking mechanism directly into the App's core structure. | 您必须将版本检查机制直接编码到应用程序的核心结构中。

```move
module my_app::core {
    struct AppState has key { id: UID, version: u64 }
    const V_CURRENT: u64 = 1;

    public fun check_version(state: &AppState) {
        assert!(state.version == V_CURRENT, 1337);
    }
}
```

*Quy trình chống lỗi gọi ngược | Process to prevent Downgrade Attacks | 防止降级攻击的流程:*

1. Phát hành V2. | Release V2. | 发布 V2。
2. Quản trị viên gọi hàm `upgrade_version`. Version của `AppState` chuyển thành 2. | Admin calls `upgrade_version`. `AppState` version changes to 2. | 管理员调用 `upgrade_version`。`AppState` 版本更改为 2。
3. Kẻ tấn công gọi lại package V1. Hàm check của V1 thấy `state.version == 2` nhưng `V_CURRENT` là 1. Abort. -> Hàm V1 bị khóa mồm mãi mãi. | Attacker recalls package V1. V1's check function sees `state.version == 2` but `V_CURRENT` is 1. Aborts. -> V1 functions are permanently locked. | 攻击者重新调用包 V1。V1 的检查函数看到 `state.version == 2` 但 `V_CURRENT` 为 1。中断。-> V1 函数被永久锁定。

## 3. Quản Lý Migration Data | Data Migration Management | 数据迁移管理

Nếu như một Module mới thêm một thuộc tính mới vào Struct, người chơi cũ cấu trúc struct (vẫn nằm ở V1 Format) phải được cập nhật tuần tự. Khai báo thêm `dynamic_field` thay vì field chuẩn. | If a new Module adds a new attribute to a Struct, old users with the old struct structure must be updated sequentially. Declare additional `dynamic_field`s instead of standard fields. | 如果新模块向结构体添加新属性，则必须按顺序更新具有旧结构的用户。声明额外的 `dynamic_field` 而不是标准字段。
