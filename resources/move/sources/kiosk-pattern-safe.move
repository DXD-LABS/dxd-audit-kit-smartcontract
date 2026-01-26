/// VI: Mau an toan cho Kiosk quan ly NFT.
/// EN: Safe pattern for Kiosk-based NFT custody.
/// ZH: Kiosk guan li NFT de an toan mau hinh.
module safe::kiosk_pattern {
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    /// VI: NFT mau dung cho test.
    /// EN: Sample NFT for tests.
    /// ZH: Yong yu ce shi de NFT.
    struct MyNFT has key, store { id: UID }

    /// VI: Tao kiosk + owner cap.
    /// EN: Create kiosk + owner cap.
    /// ZH: Chuang jian kiosk + owner cap.
    public fun create_kiosk(ctx: &mut TxContext): (Kiosk, KioskOwnerCap) {
        kiosk::new(ctx)
    }

    /// VI: Chuyen owner cap.
    /// EN: Transfer owner cap.
    /// ZH: Zhuan yi owner cap.
    public entry fun transfer_owner_cap(cap: KioskOwnerCap, recipient: address) {
        transfer::transfer(cap, recipient);
    }

    /// VI: Mint NFT.
    /// EN: Mint an NFT.
    /// ZH: Mint NFT.
    public fun mint_nft(ctx: &mut TxContext): MyNFT {
        MyNFT { id: object::new(ctx) }
    }

    /// VI: Dua NFT vao kiosk.
    /// EN: Place NFT into kiosk.
    /// ZH: Jiang NFT fang ru kiosk.
    public entry fun place_nft(kiosk: &mut Kiosk, nft: MyNFT, cap: &KioskOwnerCap) {
        kiosk::place(kiosk, cap, nft);
    }

    /// VI: Rut NFT (can owner cap).
    /// EN: Withdraw NFT (requires owner cap).
    /// ZH: Ti qu NFT (xu yao owner cap).
    public fun withdraw_nft(kiosk: &mut Kiosk, cap: &KioskOwnerCap, id: ID): MyNFT {
        kiosk::withdraw(kiosk, cap, id)
    }
}
