/// VI: Tests cho cac mau an toan (capability, flash loan, kiosk).
/// EN: Tests for safe snippets (capability, flash loan, kiosk).
/// ZH: An toan snippet ce shi (capability, flash loan, kiosk).
module safe::safe_snippets_tests {
    use safe::capability;
    use safe::flash_loan;
    use safe::kiosk_pattern;
    use sui::object;
    use sui::tx_context;

    #[test]
    fun test_capability_admin_flow() {
        // VI/EN/ZH: Tao cap va goi hanh dong nhay cam.
        let mut ctx = tx_context::dummy();
        let cap = capability::create_admin_cap(&mut ctx);
        capability::restricted_action(&cap);
    }

    #[test]
    fun test_capability_transfer() {
        // VI/EN/ZH: Kiem tra chuyen cap.
        let mut ctx = tx_context::dummy();
        let cap = capability::create_admin_cap(&mut ctx);
        capability::transfer_cap(cap, @0x1);
    }

    #[test]
    fun test_flash_loan_borrow_repay() {
        // VI/EN/ZH: Muon va tra no trong cung tx.
        let mut ctx = tx_context::dummy();
        let mut pool = flash_loan::new_pool(1_000);
        let loan = flash_loan::borrow_flash_loan(&mut pool, 100, &mut ctx);
        flash_loan::repay_flash_loan(loan, &mut pool);
        assert!(flash_loan::pool_balance(&pool) == 1_000, 0);
    }

    #[test]
    fun test_flash_loan_balance_changes() {
        // VI/EN/ZH: Kiem tra so du giam/tang.
        let mut ctx = tx_context::dummy();
        let mut pool = flash_loan::new_pool(500);
        let loan = flash_loan::borrow_flash_loan(&mut pool, 200, &mut ctx);
        assert!(flash_loan::pool_balance(&pool) == 300, 0);
        flash_loan::repay_flash_loan(loan, &mut pool);
        assert!(flash_loan::pool_balance(&pool) == 500, 1);
    }

    #[test]
    fun test_kiosk_place_withdraw() {
        // VI/EN/ZH: Dat va rut NFT khoi kiosk.
        let mut ctx = tx_context::dummy();
        let (mut kiosk, cap) = kiosk_pattern::create_kiosk(&mut ctx);
        let nft = kiosk_pattern::mint_nft(&mut ctx);
        let nft_id = object::id(&nft);
        kiosk_pattern::place_nft(&mut kiosk, nft, &cap);
        let withdrawn = kiosk_pattern::withdraw_nft(&mut kiosk, &cap, nft_id);
        assert!(object::id(&withdrawn) == nft_id, 0);
    }
}
