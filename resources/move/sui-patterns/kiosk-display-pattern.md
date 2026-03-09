# Sui Pattern: Kiosk & Display Standard | Kiosk 与 Display 标准

Giao dịch tài sản số (NFT, Vật phẩm ingame) trên Sui cần tuân thủ các tiêu chuẩn chung để có thể hiển thị đúng trên các Ví (Wallet) và chợ (Marketplaces), đồng thời bảo vệ lợi ích (Royalties/Tiền bản quyền) cho Creator. | Trading digital assets (NFTs, in-game items) on Sui must comply with common standards to display correctly on Wallets and Marketplaces, while protecting Creators' interests (Royalties). | 在 Sui 上交易数字资产（NFT，游戏内物品）必须遵守通用标准，以便在钱包和市场上正确显示，同时保护创作者的利益（版税）。

## 1. Kiosk Standard (`sui::kiosk`) | Kiosk 标准

Kiosk là một hệ thống thương mại phi tập trung. Bất kể bạn bán, mua hay chuyển nhượng NFT, giao dịch đó phải đi qua Kiosk. | Kiosk is a decentralized commerce system. Whether you sell, buy, or transfer an NFT, the transaction must go through the Kiosk. | Kiosk 是一个去中心化的商业系统。无论您出售、购买还是转让 NFT，交易都必须经过 Kiosk。

### Điểm Cốt Lõi | Core Points | 核心要点

* **Không gửi thẳng | Do not send directly | 不要直接发送:** Thay vì `transfer::public_transfer(nft, buyer)`, bán NFT an toàn qua chợ cần dùng Kiosk. | Instead of `transfer::public_transfer(nft, buyer)`, safe NFT selling requires Kiosk. | 不是 `transfer::public_transfer(nft, buyer)`，安全的 NFT 销售需要 Kiosk。
* **Transfer Policy | 转移政策:** Creator tạo ra một object chính sách. | Creators create a policy object. | 创作者创建一个政策对象。
* **Quy trình mua bán an toàn | Safe Trading Process | 安全交易流程:**
    1. Seller khóa (place) NFT vào Kiosk và niêm yết giá (list). | Seller locks (places) the NFT into their Kiosk and lists the price. | 卖家将 NFT 锁定（放置）到他们的 Kiosk 中并列出价格。
    2. Buyer gửi tiền vào hàm mua. Kiosk trả lại NFT và xuất ra chứng từ mua bán (PurchaseReceipt). | Buyer sends money to the buy function. Kiosk returns the NFT and issues a PurchaseReceipt. | 买家向购买函数发送资金。Kiosk 返回 NFT 并发出 PurchaseReceipt。
    3. Buyer phải mang cái PurchaseReceipt đó tới `TransferPolicy` để xác nhận thanh toán phí bản quyền. Nếu không, giao dịch sẽ bị hỏng (abort, vì Receipt là một Hot Potato). | The buyer must take that PurchaseReceipt to the `TransferPolicy` to confirm royalty payment. Otherwise, the transaction will abort (since Receipt is a Hot Potato). | 买家必须将该 PurchaseReceipt 带到 `TransferPolicy` 确认支付版税。否则，交易将中止（因为 Receipt 是个热土豆）。

## 2. Display Standard (`sui::display`) | Display 标准

Sui tách rời logic khỏi dữ liệu hiển thị (Metadata) thông qua `sui::display`. Việc này giúp object nhẹ và cho phép dApp tự render data dễ dàng. | Sui decouples logic from display data (Metadata) via `sui::display`. This keeps objects lightweight and allows dApps to render data easily. | Sui 通过 `sui::display` 将逻辑与显示数据（元数据）解耦。这使对象保持轻量，并允许 dApp 轻松呈现数据。

### Lợi ích | Benefits | 好处

1. **Dễ bảo trì | Easy to maintain | 易于维护:** Developer cầm PublisherCap có thể cập nhật `display` cho CHUNG toàn bộ hàng triệu NFT. | A developer holding the PublisherCap can update the `display` for ALL millions of NFTs simultaneously. | 拥有 PublisherCap 的开发人员可以同时为数百万个 NFT 更新 `display`。
2. **Tiêu chuẩn hóa | Standardization | 标准化:** Các Ví như Sui Wallet tự động nhận diện struct này là một NFT sưu tầm và hiển thị hình ảnh tự động. | Wallets like Sui Wallet automatically recognize this struct as a collectible NFT and display the image automatically. | 像 Sui 钱包这样的钱包会自动将此结构识别为可收藏的 NFT 并自动显示图像。
