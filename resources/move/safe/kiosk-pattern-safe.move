/// Module: safe::kiosk_pattern
/// Description: 
/// EN: Secure pattern for Kiosk (NFT marketplace) in Sui.
/// VI: Pattern an toàn cho Kiosk (NFT marketplace) trong Sui.
/// ZH: Sui 中 Kiosk（NFT 市场）的安全模式。
/// EN: Kiosk is used to manage NFT ownership and prevent duplication.
/// VI: Kiosk được sử dụng để quản lý quyền sở hữu NFT và ngăn chặn việc trùng lặp.
/// ZH: Kiosk 用于管理 NFT 所有权并防止重复。

module safe::kiosk_pattern {
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct MyNFT has key, store { id: UID }

    /// EN: Securely create kiosk + owner cap.
    /// VI: Tạo kiosk + owner cap an toàn.
    /// ZH: 安全地创建 kiosk + owner cap。
    public fun create_kiosk(ctx: &mut TxContext): (Kiosk, KioskOwnerCap) {
        let (kiosk, cap) = kiosk::new(ctx);
        transfer::transfer(cap, tx_context::sender(ctx));
        (kiosk, cap)
    }

    /// EN: Securely place NFT into kiosk.
    /// VI: Place NFT vào kiosk an toàn.
    /// ZH: 安全地将 NFT 放入 kiosk。
    public entry fun place_nft(kiosk: &mut Kiosk, nft: MyNFT, cap: &KioskOwnerCap) {
        kiosk::place(kiosk, cap, nft);
    }

    /// EN: Only owner can withdraw NFT.
    /// VI: Withdraw NFT chỉ owner mới làm được.
    /// ZH: 只有所有者可以提取 NFT。
    public fun withdraw_nft(kiosk: &mut Kiosk, cap: &KioskOwnerCap, id: ID): MyNFT {
        kiosk::withdraw(kiosk, cap, id)
    }
}

// Best practice:
// EN: Always use KioskOwnerCap to restrict access and prevent NFT leaks.
// VI: Luôn dùng KioskOwnerCap để giới hạn truy cập, tránh NFT bị rò rỉ.
// ZH: 始终使用 KioskOwnerCap 来限制访问并防止 NFT 泄露。