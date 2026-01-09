/// Module: vuln::kiosk_abuse
/// Description: 
/// EN: VULNERABILITY - Kiosk doesn't check owner capability, allowing anyone to withdraw NFTs.
/// VI: LỖ HỔNG - Kiosk không kiểm tra owner capability, cho phép bất kỳ ai cũng có thể rút NFT.
/// ZH: 漏洞 - Kiosk 不检查所有者权限，允许任何人提取 NFT。

module vuln::kiosk_abuse {
    use sui::kiosk::{Self, Kiosk};

    public fun unsafe_withdraw(kiosk: &mut Kiosk, id: ID): MyNFT {
        // LỖ HỔNG/VULN: No cap required → attacker withdraws any NFT (越权提取)
        kiosk::withdraw(kiosk, id)
    }
}

// Risk: Critical – NFT theft
// Fix: 
// EN: Always require KioskOwnerCap: kiosk::withdraw(kiosk, cap, id)
// VI: Luôn yêu cầu KioskOwnerCap: kiosk::withdraw(kiosk, cap, id)
// ZH: 始终要求 KioskOwnerCap：kiosk::withdraw(kiosk, cap, id)