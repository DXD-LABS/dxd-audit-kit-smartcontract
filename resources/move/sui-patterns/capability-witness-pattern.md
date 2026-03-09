# Sui Pattern: Capability & One-Time Witness (OTW) | Sui 设计模式：权能与一次性见证 (OTW)

Đây là hai mẫu thiết kế được sử dụng để kiểm soát quyền khởi tạo và quyền thực thi (Admin/Manager Access) trên Sui. | These are two design patterns used to control initialization and execution rights (Admin/Manager Access) on Sui. | 这是两种用于在 Sui 上控制初始化和执行权限（管理员/经理访问）的设计模式。

## 1. Capability Pattern (Mẫu Năng Lực) | Capability Pattern | 权能模式

Thay vì kiểm tra địa chỉ người gửi (`address`) như EVM hay kiểm tra Module Signer như Aptos, Sui quản lý quyền bằng Object Ownership. Capability (hay "Cap") là một Object tượng trưng cho quyền năng. | Instead of checking the sender's address like EVM or testing the Module Signer like Aptos, Sui manages permissions via Object Ownership. A Capability (or "Cap") is an Object that represents power. | Sui 不像 EVM 那样检查发送者的地址，也不像 Aptos 那样测试模块签名者，而是通过对象所有权管理权限。权能（或“Cap”）是代表权力的对象。

### Cơ Chế Hoạt Động | How It Works | 运作机制

- Khởi tạo Struct này bên trong hàm `init` (chỉ chạy 1 lần). | Initialize this Struct inside the `init` function (runs only once). | 在 `init` 函数内部初始化此结构体（仅运行一次）。
- Gửi Capability Object này đến địa chỉ người tạo (Deployer) bằng `transfer`. | Send this Capability Object to the creator's address (Deployer) using `transfer`. | 使用 `transfer` 将此权能对象发送到创建者的地址 (Deployer)。
- Các hàm quản trị yêu cầu truyền Cap này vào như tham số (thường là `&AdminCap`). | Administrative functions require this Cap as a parameter (usually `&AdminCap`). | 管理函数需要此 Cap 作为参数（通常是 `&AdminCap`）。

## 2. One-Time Witness (OTW) | One-Time Witness (OTW) | 一次性见证

OTW là một Struct đảm bảo một mã (logic/object) **chỉ được khởi tạo một lần duy nhất** trên toàn mạng lưới. | OTW is a Struct ensuring that an entity (logic/object) **is initialized exclusively once** across the entire network. | OTW 是一种结构体，可确保实体（逻辑/对象）在整个网络上**仅被独家初始化一次**。

### Định Nghĩa OTW | OTW Definition | OTW 定义

1. **Tên Struct | Struct Name | 结构体名称:** Viết IN HOA TOÀN BỘ. | WRITTEN IN ALL CAPS. | 全部大写。
2. **Abilities | Abilities | 能力:** Phải có duy nhất ability `drop`. | Must exclusively possess the `drop` ability. | 必须仅具有 `drop` 能力。
3. **Vị trí | Position | 位置:** Phải là struct độc lập và không chứa field nào. | Must be an independent struct without any fields. | 必须是没有字段的独立结构体。

### Ứng Dụng Chính: Khởi Tạo Sui Coin / Sui Token | Main Application: Init Coin/Token | 主要应用：初始化 Coin/Token

Hàm `coin::create_currency` bắt buộc phải nhận OTW. Vì hàm `init` chỉ sinh OTW một lần, bạn không bao giờ có thể in thêm một loại `Coin` y hệt như thế nữa. | `coin::create_currency` mandates an OTW. Since `init` generates the OTW only once, you can never mint identical `Coin`s again. | `coin::create_currency` 强制要求 OTW。因为 `init` 仅生成 OTW 一次，所以您再也无法铸造出完全相同的 `Coin`。
