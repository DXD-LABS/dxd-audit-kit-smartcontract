# Init Function Security & Best Practices | Init 函数安全与最佳实践

Hàm `init` trên mạng Sui là trái tim của việc khởi tạo cho bất kỳ gói (Package) nào. Nó chạy duy nhất MỘT LẦN khi Code được công bố (Publish). Do đó, lỗ hổng trong hàm này thường để lại hậu quả không thể đảo ngược trên mạng chính. | The `init` function on the Sui network is the heart of initialization for any Package. It runs ONLY ONCE when the Code is published. Therefore, vulnerabilities here often leave irreversible consequences on the mainnet. | Sui 网络上的 `init` 函数是任何包初始化的核心。当发布代码时它仅运行一次。因此，此处的漏洞通常会在主网上留下不可逆转的后果。

## 1. Khởi tạo Không Hoàn Chỉnh | Partial Initialization | 不完全初始化

Lỗi phổ biến nhất là tạo một Capability (`AdminCap`) nhưng vô tình chia sẻ (Share) nó, hoặc khóa cứng (Freeze) dẫn đến việc mất luôn quyền Admin. | The most common error is creating a Capability (`AdminCap`) but accidentally sharing or freezing it, leading to the loss of Admin rights. | 最常见的错误是创建一个权能（`AdminCap`）但不小心共享或冻结它，导致丧失管理员权限。

- [ ] **Kiểm Tra Điểm Cuối | Destination Check | 目标检查:** Tất cả các quyền năng (`AdminCap`, `TreasuryCap`, `UpgradeCap`) phải được gọi qua `transfer::transfer(obj, tx_context::sender(ctx))`. | All capabilities must be transferred via `transfer::transfer(obj, tx_context::sender(ctx))`. | 必须通过 `transfer::transfer(obj, tx_context::sender(ctx))` 转移所有权能。

## 2. Quá Tải Context và Storage | Overloading Context and Storage | 上下文与存储过载

Hàm `init` chạy trong PTB đặc biệt "Publish". Nếu `init` sinh ra trên 1000 object con tĩnh, nó có thể tiêu thụ quá hạn mức Gas gây thất bại Deploy. | The `init` function runs in a special "Publish" PTB. If `init` generates over 1000 child objects, it might exceed gas limits causing deployment failure. | `init` 函数在特殊的 "Publish" PTB 中运行。如果 `init` 生成超过 1000 个子对象，它可能会超出 gas 限制导致部署失败。

## 3. Lỗ hổng "Test_only" | "Test_only" Vulnerability | "Test_only" 漏洞

```move
#[test_only]
public fun init_for_testing(ctx: &mut TxContext) { init(ctx) }
```

Chú ý: **Bắt buộc** các hàm khởi tạo phụ phải bọc trong `#[test_only]`. Nếu không, kẻ tấn công sau này có thể kích hoạt lại chu kỳ `init`. | Note: Secondary init functions **must** be wrapped in `#[test_only]`. Otherwise, an attacker can reactivate the `init` cycle later. | 注意：辅助初始化函数**必须**包装在 `#[test_only]` 中。否则，攻击者稍后可以重新激活 `init` 循环。

## 4. Trạng Thái Nâng Cấp | Upgrade Lifecycle | 升级生命周期

- Hàm `init` **chỉ chạy khi PUBLISH lần đầu tiên.** Khi Upgrade lên V2, `init` TUYỆT ĐỐI không bao giờ chạy lại nữa. | The `init` function **only runs upon the first PUBLISH.** When upgrading to V2, `init` NEVER runs again. | `init` 函数**仅在首次 PUBLISH 时运行。** 升级到 V2 时，`init` 绝不再运行。
- Nếu Admin struct mới ở V2, bạn PHẢI tạo script upgrade riêng biệt (Data Migration). | If introducing a new Admin struct in V2, you MUST create a separate upgrade script (Data Migration). | 如果在 V2 中引入新的 Admin 结构体，则必定创建单独的升级脚本（数据迁移）。
