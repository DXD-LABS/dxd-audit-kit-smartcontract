/// Module: safe::kiosk_pattern
/// Description: 
/// EN: Secure pattern for Kiosk (NFT marketplace) in Sui.
/// VI: Pattern an toÃ n cho Kiosk (NFT marketplace) trong Sui.
/// ZH: Sui ä¸­ Kioskï¼ˆNFT å¸‚åœºï¼‰çš„å®‰å…¨æ¨¡å¼ã€‚
/// EN: Kiosk is used to manage NFT ownership and prevent duplication.
/// VI: Kiosk Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ quáº£n lÃ½ quyá»n sá»Ÿ há»¯u NFT vÃ  ngÄƒn cháº·n viá»‡c trÃ¹ng láº·p.
/// ZH: Kiosk ç”¨äºŽç®¡ç† NFT æ‰€æœ‰æƒå¹¶é˜²æ­¢é‡å¤ã€‚

module safe::kiosk_pattern {
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct MyNFT has key, store { id: UID }

    /// EN: Create kiosk + owner cap.
    /// VI: Táº¡o kiosk + owner cap an toÃ n.
    /// ZH: å®‰å…¨åœ°åˆ›å»º kiosk + owner capã€‚
    public fun create_kiosk(ctx: &mut TxContext): (Kiosk, KioskOwnerCap) {
        kiosk::new(ctx)
    }

    /// EN: Transfer owner cap to a new address.
    /// VI: Chuyá»ƒn owner cap cho address má»›i.
    /// ZH: å°† owner cap è½¬ç§»åˆ°æ–°åœ°å€ã€‚
    public entry fun transfer_owner_cap(cap: KioskOwnerCap, recipient: address) {
        transfer::transfer(cap, recipient);
    }

    /// EN: Mint a test NFT.
    /// VI: Táº¡o NFT dÃ¹ng trong test.
    /// ZH: ç”¨äºŽæµ‹è¯•çš„ NFTã€‚
    public fun mint_nft(ctx: &mut TxContext): MyNFT {
        MyNFT { id: object::new(ctx) }
    }

    /// EN: Securely place NFT into kiosk.
    /// VI: Place NFT vÃ o kiosk an toÃ n.
    /// ZH: å®‰å…¨åœ°å°† NFT æ”¾å…¥ kioskã€‚
    public entry fun place_nft(kiosk: &mut Kiosk, nft: MyNFT, cap: &KioskOwnerCap) {
        kiosk::place(kiosk, cap, nft);
    }

    /// EN: Only owner can withdraw NFT.
    /// VI: Withdraw NFT chá»‰ owner má»›i lÃ m Ä‘Æ°á»£c.
    /// ZH: åªæœ‰æ‰€æœ‰è€…å¯ä»¥æå– NFTã€‚
    public fun withdraw_nft(kiosk: &mut Kiosk, cap: &KioskOwnerCap, id: ID): MyNFT {
        kiosk::withdraw(kiosk, cap, id)
    }
}

// Best practice:
// EN: Always use KioskOwnerCap to restrict access and prevent NFT leaks.
// VI: LuÃ´n dÃ¹ng KioskOwnerCap Ä‘á»ƒ giá»›i háº¡n truy cáº­p, trÃ¡nh NFT bá»‹ rÃ² rá»‰.
// ZH: å§‹ç»ˆä½¿ç”¨ KioskOwnerCap æ¥é™åˆ¶è®¿é—®å¹¶é˜²æ­¢ NFT æ³„éœ²ã€‚
