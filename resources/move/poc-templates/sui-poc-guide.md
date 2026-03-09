# Sui Proof of Concept (PoC) Guide | Sui 概念验证 (PoC) 指南

Để cung cấp một báo cáo mã nguồn mở (Audit Report) đạt tiêu chuẩn thương mại cao, Auditor cần chứng minh rủi ro bảo mật thông qua Proof of Concept (PoC) chạy được. | To provide a commercial-grade open-source Audit Report, Auditors must demonstrate security risks through executable Proofs of Concept (PoC). | 为了提供商业级开源审计报告，审计员必须通过可执行的概念验证 (PoC) 证明安全风险。

Tài liệu này hướng dẫn cách viết PoC khai thác trên Sui dùng `sui::test_scenario` và TypeScript SDK. | This document guides how to write exploit PoCs on Sui using `sui::test_scenario` and TypeScript SDK. | 本文档指导如何使用 `sui::test_scenario` 和 TypeScript SDK 在 Sui 上编写漏洞利用 PoC。

## Phương Pháp 1: Viết PoC bằng Sui Move `test_scenario` | Method 1: Writing PoC with Sui Move `test_scenario` | 方法 1：使用 Sui Move `test_scenario` 编写 PoC

Đây là cách phổ biến và hiệu quả nhất để tái tạo các tương tác nội bộ trên mạng lưới Sui, với lợi thế giả định các user (sender) thay đổi ở từng Block/Transaction. | This is the most popular and effective way to reproduce internal interactions on the Sui network, with the advantage of simulating sender changes across blocks/transactions. | 这是在 Sui 网络上重现内部交互最流行和最有效的方法，其优势在于跨区块/交易模拟发送者更改。

### Template Cơ bản | Basic Template | 基本模板

```move
#[test_only]
module project::exploit_poc {
    use sui::test_scenario::{Self, Scenario};
    use project::target_module::{Self, TargetObject};
    
    // Addresses
    const ADMIN: address = @0xAD;
    const VICTIM: address = @0x11;
    const ATTACKER: address = @0x666;

    #[test]
    fun test_exploit_logic() {
        let mut scenario_val = test_scenario::begin(ADMIN);
        let scenario = &mut scenario_val;
        
        // 1. Setup Phase: Admin khởi tạo protocol
        test_scenario::next_tx(scenario, ADMIN);
        {
            target_module::init_for_testing(test_scenario::ctx(scenario));
        };
        
        // 2. Victim Phase: Nạn nhân gửi tiền/tương tác
        test_scenario::next_tx(scenario, VICTIM);
        {
            // Lấy object từ storage mô phỏng
            let mut shared_obj = test_scenario::take_shared<TargetObject>(scenario);
            target_module::deposit(&mut shared_obj, 1000, test_scenario::ctx(scenario));
            test_scenario::return_shared(shared_obj);
        };
        
        // 3. Attack Phase: Kẻ tấn công khai thác lỗ hổng
        test_scenario::next_tx(scenario, ATTACKER);
        {
            let mut shared_obj = test_scenario::take_shared<TargetObject>(scenario);
            // Kẻ tấn công lợi dụng lỗ hổng không kiểm tra sender (Ví dụ)
            target_module::withdraw_all(&mut shared_obj, test_scenario::ctx(scenario));
            test_scenario::return_shared(shared_obj);
        };
        
        // 4. Assert Phase: Xác nhận tấn công thành công
        test_scenario::next_tx(scenario, ATTACKER);
        {
            // Kiểm tra Attacker có lấy được tiền không
            // Dùng assert!(...)
        };
        
        test_scenario::end(scenario_val);
    }
}
```

## Phương Pháp 2: Viết PoC bằng Sui TypeScript SDK (PTB Attack) | Method 2: Writing PoC with Sui TypeScript SDK | 方法 2：使用 Sui TypeScript SDK 编写 PoC

Đôi khi, lỗi logic xuất phát từ việc thiết kế Programmable Transaction Blocks. Cần viết PoC bằng TS SDK. | Sometimes logic errors stem from PTB design. PoCs need to be written with the TS SDK. | 有时逻辑错误源于 PTB 的设计。PoC 需要使用 TS SDK 编写。

### Template Khai thác bằng PTB | PTB Exploit Template | PTB 利用模板

```typescript
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { Ed25519Keypair } from '@mysten/sui.js/keypairs/ed25519';
// Import Sui Client...

async function runPTBExploit() {
    const attackerKeypair = Ed25519Keypair.deriveKeypair("VÍ_CỦA_ATTACKER_PKEY");
    const txb = new TransactionBlock();
    
    // ... setup and PTB logic here
}
```

**Mẹo cho Auditor | Auditor Tip | 审计员建议:** Khi viết báo cáo, hãy nhúng cả file PoC `.move` hoặc `.ts` này vào Appendix kèm theo lệnh chạy (ví dụ `sui move test -f test_exploit_logic`). Người đọc có thể tự copy và chạy, làm tăng độ uy tín của Audit. | When writing reports, embed the PoC file with the run command. Readers can copy and run it themselves, boosting Audit credibility. | 撰写报告时，请将 PoC 运行命令嵌入附录。读者可以自行复制并运行它，提高审计的信誉度。
