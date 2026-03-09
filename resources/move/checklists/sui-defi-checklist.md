# Sui DeFi Security Checklist | Sui DeFi 安全检查清单

DeFi trên Sui có nhiều khác biệt so với EVM hay Aptos do mô hình Object-centric và sự vắng mặt của global state truyền thống. | DeFi on Sui differs significantly from EVM or Aptos due to its Object-centric model and the absence of a traditional global state. | 由于其以对象为中心的模型和缺乏传统的全局状态，Sui 上的 DeFi 与 EVM 或 Aptos 存在显著差异。

## 1. Coin vs. Token Standard | Coin 与 Token 标准

- [ ] **Nhầm lẫn chuẩn tài sản | Asset Standard Confusion | 资产标准混淆:** Smart contract hỗ trợ `sui::coin` có vô tình cho phép nạp `sui::token` không? | Does the smart contract supporting `sui::coin` unintentionally allow depositing `sui::token`? | 支持 `sui::coin` 的智能合约是否无意中允许存入 `sui::token`？
- [ ] **Zero Coin (Coin vô giá trị) | Zero Coin | 零价值代币:** Đã kiểm tra trường hợp người dùng truyền vào `Coin` có giá trị `0` chưa? | Have scenarios where users pass a `Coin` with value `0` been checked? | 是否已检查用户传递值为 `0` 的 `Coin` 的情况？
- [ ] **Gỡ bỏ bụi Coin | Dust Collection | 粉尘收集:** Các mảnh Coin nhỏ (dust) được thu thập và dọn dẹp thường xuyên không? | Are small Coin fragments (dust) collected and cleaned up regularly? | 是否定期收集和清理小代币碎片（粉尘）？

## 2. Shared Object Contentions & DoS | 共享对象争用与 DoS

- [ ] **Sử dụng `&mut` không cần thiết | Unnecessary `&mut` usage | 不必要的 `&mut` 使用:** Hàm có yêu cầu `&mut SharedObject` trong khi chỉ cần đọc `&SharedObject` không? | Does the function require `&mut SharedObject` when it only needs to read `&SharedObject`? | 函数是否在只需要读取 `&SharedObject` 时要求 `&mut SharedObject`？
- [ ] **Dynamic Field Object DoS | 动态字段对象 DoS:** Việc thêm/xóa Dynamic Fields có bị lạm dụng để gây DoS không? | Could adding/removing Dynamic Fields be abused to cause a DoS? | 添加/删除动态字段是否会被滥用来引起 DoS？
- [ ] **Freeze Shared Object | 冻结共享对象:** Contract có vô tình gọi `sui::transfer::freeze_object` lên một Shared Object không? | Did the contract unintentionally call `sui::transfer::freeze_object` on a Shared Object? | 合约是否无意中对共享对象调用了 `sui::transfer::freeze_object`？

## 3. AMM/Liquidity Pools (DEX) | 自动做市商/流动性池 (DEX)

- [ ] **Định tuyến Flashloan/PTB | Flashloan/PTB Routing | 闪电贷/PTB 路由:** Giá của pool có bị thao túng trước khi thực hiện giao dịch chính không? | Could the pool price be manipulated before the main transaction? | 池价格是否可能在主交易之前被操纵？
- [ ] **Quản lý LP Token | LP Token Management | LP 代币管理:** LP Token sinh ra có được sử dụng `sui::balance` hay `sui::coin` không? | Are generated LP Tokens using `sui::balance` or `sui::coin`? | 生成的 LP 代币使用 `sui::balance` 还是 `sui::coin`？
- [ ] **Tính toán trượt giá | Slippage Calculation | 滑点计算:** Đã kiểm tra tính toán slippage dựa trên `min_out` trong PTB chưa? | Has slippage calculation based on `min_out` in PTB been checked? | 是否已检查基于 PTB 中 `min_out` 的滑点计算？

## 4. Kiosk & NFT Finance | Kiosk 与 NFT 金融

- [ ] **Tuân thủ Kiosk | Kiosk Compliance | 遵守 Kiosk:** DApp có tương tác đúng với API của `sui::kiosk` để không vi phạm chính sách của creator không? | Does the DApp interact correctly with the `sui::kiosk` API to avoid violating creator policies? | DApp 是否正确且符合 `sui::kiosk` API 的交互要求以避免违反创作者政策？
- [ ] **Khóa NFT | NFT Locking | NFT 锁定:** Việc lock NFT vào vault có thay đổi quyền sở hữu dẫn đến việc Creator không nhận được royalties không? | Does locking an NFT into a vault change ownership, preventing Creators from receiving royalties? | 将 NFT 锁定到金库是否会改变所有权，从而导致创作者无法收取版税？
