/// Module: vuln::nft_listing_abuse
/// Description: LỖI – Listing NFT không policy → bypass royalty | ERROR – Listing NFT without policy → royalty bypass | 错误 – 列表 NFT 没有策略 → 绕过版权费

module vuln::nft_listing_abuse {
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};

    public entry fun unsafe_list(kiosk: &mut Kiosk, cap: &KioskOwnerCap, nft_id: ID, price: u64) {
        kiosk::list(kiosk, cap, nft_id, price); // LỖ HỔNG: Không enforce TransferPolicy → royalty bypass | VULNERABILITY: Not enforcing TransferPolicy → royalty bypass | 漏洞：未强制执行 TransferPolicy → 绕过版权费
    }
}

// Risk: High – Creator royalty lost | Risk: High – Creator royalty lost | 风险：高 – 作者版权费丢失
// Fix: Luôn require TransferPolicy<MyNFT>. | Fix: Always require TransferPolicy<MyNFT>. | 修复：始终需要 TransferPolicy<MyNFT>。