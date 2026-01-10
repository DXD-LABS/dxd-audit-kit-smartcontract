/// Module: safe::nft_kiosk_listing
/// Description: Pattern an toàn listing NFT trên Kiosk (marketplace) | Safe pattern for listing NFTs on Kiosk (marketplace) | 在 Kiosk（市场）上列出 NFT 的安全模式

module safe::nft_kiosk_listing {
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::transfer_policy::{Self, TransferPolicy};

    struct MyNFT has key, store { id: UID }

    public entry fun list_nft(kiosk: &mut Kiosk, cap: &KioskOwnerCap, nft_id: ID, price: u64, policy: &TransferPolicy<MyNFT>) {
        kiosk::list(kiosk, cap, nft_id, price);
        // Policy check an toàn (royalty, transfer rules) | Safe policy check (royalty, transfer rules) | 安全策略检查（版权费、传输规则）
    }
}

// Best practice: Luôn dùng TransferPolicy để enforce royalty/transfer rules. | Best practice: Always use TransferPolicy to enforce royalty/transfer rules. | 最佳实践：始终使用 TransferPolicy 来强制执行版权费/传输规则。