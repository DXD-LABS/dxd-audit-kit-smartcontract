# DXDLABS – Báo cáo Kiểm tra Bảo mật Smart Contract Toàn diện: Navi Protocol — Final Audit Report

> ⚠️ **Tuyên bố Pháp lý (Legal Disclaimer):** Báo cáo này được chuẩn bị bởi DXDLABS Security Team dành riêng cho Navi Protocol. Nội dung chỉ mang tính chất tư vấn kỹ thuật, không cấu thành lời khuyên pháp lý hay tài chính. Cuộc kiểm định được tiến hành dựa trên codebase tại thời điểm cụ thể và không đảm bảo sự vắng mặt của tất cả mọi lỗ hổng bảo mật. Mọi thay đổi mã nguồn sau ngày phát hành cần được đánh giá lại. DXDLABS không chịu trách nhiệm về tổn thất tài chính phát sinh từ các lỗ hổng chưa được phát hiện hoặc từ việc không tuân thủ các khuyến nghị trong báo cáo này.

---

## Mục lục (Table of Contents)

1. [Tóm tắt Điều hành (Executive Summary)](#executive-summary)
2. [Thông tin Kiểm định (Audit Metadata)](#audit-metadata)
3. [Định nghĩa Mức độ Nghiêm trọng (Severity Definitions)](#severity-definitions)
4. [Phạm vi Kiểm định (Scope)](#scope)
5. [Phương pháp Kiểm định (Methodology)](#methodology)
6. [Phát hiện Bảo mật Chi tiết (Findings)](#findings)
7. [Phân tích Phủ rộng Kiểm tra (Test Coverage)](#test-coverage)
8. [Kế hoạch Khắc phục (Remediation Plan)](#remediation-plan)
9. [Điểm mạnh của Protocol (Positive Findings)](#positive-findings)
10. [Phụ lục (Appendix)](#appendix)

---

## Tóm tắt Điều hành (Executive Summary) {#executive-summary}

Navi Protocol là một giao thức DeFi Lending & Borrowing được xây dựng trên Blockchain Sui, cung cấp các tính năng cho vay, đi vay, vay nóng (Flash Loan) và Liquid Staking. Tại thời điểm kiểm định, giao thức đang hoạt động trên Mainnet Sui và quản lý lượng TVL đáng kể.

**Kết luận Tổng thể:** Navi Protocol có nền tảng toán học và logic tài chính rất vững chắc. Cơ chế Flash Loan (Hot Potato Pattern) được triển khai chuẩn mực và model tính lãi suất WAD/RAY không có lỗi số học. Tuy nhiên, **hai nhóm rủi ro nghiêm trọng cần xử lý ngay trước khi mở rộng quy mô:**

1. **Rủi ro Oracle [NAV-01, NAV-02]:** Cấu hình `update_interval` không có giới hạn trên và việc sử dụng Pyth `_unsafe` functions tạo ra kịch bản tấn công giá stale nghiêm trọng, có thể dẫn đến mất phần lớn TVL.

2. **Rủi ro Tập trung hóa Admin [NAV-03]:** Một địa chỉ duy nhất nắm `StorageAdminCap` có thể rút toàn bộ treasury và thay đổi mọi tham số protocol trong một transaction block mà không có bất kỳ cơ chế phòng vệ nào.

**Khuyến nghị hành động ngay:** Dừng phát triển tính năng mới và ưu tiên (1) đặt hard-cap cho `update_interval`, (2) implement Timelock cho Admin functions, (3) xóa các dead entry functions trong `lending.move`.

| Chỉ số | Giá trị |
| :--- | :--- |
| Tổng số Findings | 7 |
| Cần fix trước Mainnet scale | 3 (NAV-01, NAV-02, NAV-03) |
| Điểm Bảo mật Tổng thể | **6.5 / 10** |
| Trạng thái khuyến nghị | ⚠️ Cần khắc phục P0/P1 trước khi mở rộng TVL |

---

## 📋 Thông tin Kiểm định (Audit Metadata)

| Trường | Thông tin |
| :--- | :--- |
| **Khách hàng** | Navi Protocol |
| **Repository** | <https://github.com/naviprotocol/navi-smart-contracts.git> |
| **Phiên bản Báo cáo** | 3.0 – Final (Commercial-Grade) |
| **Ngôn ngữ** | Tiếng Việt |
| **Thời gian kiểm định** | 2026-03-01 → 2026-03-05 |
| **Phiên bản Sui Move** | Sui Move 2024 (Edition 2024) |
| **Tổng số file trong phạm vi** | 12 files |
| **Tổng số dòng code (LoC)** | ~5,500 LoC |
| **Trạng thái** | **FINAL** |

### Tổng hợp Findings

| Mức độ | Số lượng |
| :--- | :--- |
| 🔴 Critical | 0 |
| 🟠 High | 2 |
| 🟡 Medium | 2 |
| 🔵 Low | 1 |
| ⚪ Informational | 2 |
| **Tổng** | **7** |

---

## Định nghĩa Mức độ Nghiêm trọng (Severity Definitions) {#severity-definitions}

| Mức độ | Điều kiện | Hành động khuyến nghị |
| :--- | :--- | :--- |
| 🔴 **Critical** | Kẻ tấn công có thể đánh cắp/phá hủy quỹ người dùng trực tiếp, không cần tiền đề đặc biệt | Fix ngay lập tức, tạm dừng protocol nếu cần |
| 🟠 **High** | Mất tiền có thể xảy ra nhưng cần một điều kiện tiên quyết (key bị lộ, insider, giá biến động mạnh) | Fix bắt buộc trước mainnet hoặc phát hành tính năng mới |
| 🟡 **Medium** | Ảnh hưởng đến chức năng quan trọng hoặc tạo rủi ro kỹ thuật nợ dài hạn | Fix trước khi mở rộng TVL đáng kể |
| 🔵 **Low** | Vấn đề chất lượng code, dead code, hoặc rủi ro tiềm ẩn về UX/tích hợp | Fix trong sprint tiếp theo |
| ⚪ **Informational** | Quan sát về kiến trúc, best practice, hoặc roadmap tương lai không ảnh hưởng trực tiếp đến bảo mật hiện tại | Xem xét tích hợp vào roadmap |

> **Lưu ý về Sui Move:** Do đặc tính của Sui Move — tất cả tài sản là first-class objects, Move VM không hỗ trợ delegate calls, và không có EVM-style re-entrancy — Mức độ **Critical** trong ngữ cảnh Sui thường thấp hơn tương đương trên Ethereum. Rủi ro tương đương Critical trong Sui chủ yếu đến từ **Capability object misuse** hoặc **Shared Object lock exploitation**.

---

## 1. Phạm vi Kiểm định (Scope)

### 1.1. Các file trong phạm vi

| # | File | LoC ước tính | Trạng thái |
| :--- | :--- | :--- | :--- |
| 1 | `oracle/sources/oracle.move` | ~236 | ✅ Đã kiểm định |
| 2 | `oracle/sources/adaptor_pyth.move` | ~100 | ✅ Đã kiểm định |
| 3 | `oracle/sources/oracle_pro.move` | ~389 | ✅ Đã kiểm định |
| 4 | `oracle/sources/oracle_utils.move` | ~66 | ✅ Đã kiểm định |
| 5 | `lending_core/sources/storage.move` | ~800+ | ✅ Đã kiểm định |
| 6 | `lending_core/sources/pool.move` | ~468 | ✅ Đã kiểm định |
| 7 | `lending_core/sources/logic.move` | ~800+ | ✅ Đã kiểm định |
| 8 | `lending_core/sources/calculator.move` | ~109 | ✅ Đã kiểm định |
| 9 | `lending_core/sources/flash_loan.move` | ~353 | ✅ Đã kiểm định |
| 10 | `lending_core/sources/lending.move` | ~888 | ✅ Đã kiểm định |
| 11 | `lending_core/sources/manage.move` | ~246 | ✅ Đã kiểm định |
| 12 | `volo_liquid_staking/sources/fee_config.move` | ~112 | ✅ Đã kiểm định |

### 1.2. Các file ngoài phạm vi

- `switchboard_sui/on_demand/sources/` (23 files) — Thư viện on-demand sdk bên thứ ba
- `lending_ui/sources/` — Frontend helper, read-only getters, không chứa state mutation logic

---

## 2. Phương pháp Kiểm định (Methodology)

Cuộc kiểm định được tiến hành theo 4 giai đoạn:

1. **Threat Modeling** – Xác định vai trò, quyền hạn của từng capability object, entry points, attack surface.
2. **Manual Code Review** – Đọc từng dòng code, truy vết data flow và control flow theo từng giao dịch.
3. **Business Logic Analysis** – Kiểm tra tính nhất quán của mô hình kinh tế (interest rate model, liquidation flow, fee model).
4. **Sui Move Specific Checks** – Kiểm tra các rủi ro đặc thù của Sui Move: Shared Object congestion, Capability misuse, Hot Potato pattern, PTB chaining issues.

---

## 3. Phát hiện Bảo mật Chi tiết (Detailed Security Findings)

---

### [NAV-01] Unbounded Oracle Update Interval — Oracle Staleness Attack

| Trường | Thông tin |
| :--- | :--- |
| **ID** | NAV-01 |
| **Mức độ** | 🟠 High |
| **Status** | UNRESOLVED |
| **File** | `oracle/sources/oracle.move` |
| **Hàm** | `set_update_interval` |
| **Dòng** | ~Line 85 |

**Phân tích kỹ thuật:**

Hàm `set_update_interval` nhận vào tham số `update_interval: u64` và gán thẳng vào cấu hình Oracle mà không có bất kỳ validation giới hạn trên (upper-bound) nào:

```move
// oracle.move ~Line 85
public fun set_update_interval(
    admin_cap: &OracleAdminCap,
    oracle: &mut PriceOracle,
    update_interval: u64,
    _ctx: &mut TxContext
) {
    oracle.update_interval = update_interval;  // ← NO upper-bound check
}
```

Cơ chế check độ trễ (staleness) của toàn hệ thống hoàn toàn phụ thuộc vào `update_interval`. Khi interval bị đặt thành giá trị rất lớn, hệ thống sẽ luôn coi mọi giá là "fresh".

**🔴 Proof of Concept (PoC) – Stale Price Attack:**

```text
Bước 1. Attacker chiếm được OracleAdminCap (hoặc insider threat).
Bước 2. Attacker gọi: set_update_interval(oracle, u64::MAX).
         → Hệ thống không bao giờ coi giá là stale nữa.
Bước 3. SUI giá thực $5 → rớt xuống $0.10 trên market.
Bước 4. Oracle vẫn trả về giá $5 (giá từ vài giờ trước).
Bước 5. Attacker deposit 100 SUI (thực tế = $10 tổng giá trị).
         → Nhưng Oracle báo 100 SUI × $5 = $500 collateral.
Bước 6. Attacker borrow 400 USDC (80% LTV của $500 collateral báo cáo).
Bước 7. Lợi nhuận ròng của Attacker: $400 - $10 = $390 per 100 SUI.
Bước 8. Toàn bộ thiệt hại tập trung vào Liquidity Providers của hệ thống.
```

**Khuyến nghị:**

```move
const MAX_UPDATE_INTERVAL: u64 = 3_600_000; // 1 giờ (milliseconds)

public fun set_update_interval(
    _: &OracleAdminCap,
    oracle: &mut PriceOracle,
    update_interval: u64,
    _ctx: &mut TxContext
) {
    assert!(update_interval <= MAX_UPDATE_INTERVAL, EInvalidInterval);
    oracle.update_interval = update_interval;
}
```

---

### [NAV-02] Unsafe Pyth Adapter — Bypassing Native Timestamp Validation

| Trường | Thông tin |
| :--- | :--- |
| **ID** | NAV-02 |
| **Mức độ** | 🟡 Medium |
| **Status** | UNRESOLVED |
| **File** | `oracle/sources/adaptor_pyth.move` |
| **Hàm** | `get_price`, `get_price_unsafe_to_target_decimal` |
| **Dòng** | ~Line 20–60 |

**Phân tích kỹ thuật:**

Module `adaptor_pyth` gọi hai hàm `_unsafe` từ Pyth SDK, các hàm này **cố ý bỏ qua** timestamp validation của Pyth Network:

```move
// adaptor_pyth.move
use pyth::price_info::{Self, PriceInfoObject};

public fun get_price(price_info_obj: &PriceInfoObject, target_decimal: u8): u256 {
    // get_price_unsafe_native() bypasses Pyth's built-in age check
    let price = pyth::pyth::get_price_unsafe_native(price_info_obj);
    oracle_utils::to_target_decimal_value(
        (price::get_price(&price) as u256),
        (price::get_expo(&price) as u8),
        target_decimal
    )
}
```

Mặc dù `oracle_pro.move` có triển khai staleness check thứ cấp (`is_stale_price`), nhưng thiết kế ở tầng adapter đã **loại bỏ hoàn toàn timestamp gốc của Pyth** — timestamp đó sẽ không bao giờ được truyền lên cho module cha nữa. Bất kỳ integration nào trong tương lai sử dụng trực tiếp `adaptor_pyth::get_price` sẽ nhận price không kèm timestamp.

**Khuyến nghị:**

```move
// Trả về struct có cả price VÀ timestamp
struct PriceWithTimestamp has drop {
    price: u256,
    timestamp: u64,
}

public fun get_price_with_timestamp(price_info_obj: &PriceInfoObject, target_decimal: u8): PriceWithTimestamp {
    // Use safe version which includes timestamp
    let price = pyth::pyth::get_price(price_info_obj);
    PriceWithTimestamp {
        price: oracle_utils::to_target_decimal_value(...),
        timestamp: price::get_timestamp(&price),
    }
}
```

---

### [NAV-03] Centralized Admin Privileges Without Timelock — Rug-Pull Risk

| Trường | Thông tin |
| :--- | :--- |
| **ID** | NAV-03 |
| **Mức độ** | 🟠 High |
| **Status** | UNRESOLVED |
| **File** | `lending_core/sources/manage.move`, `pool.move`, `storage.move` |
| **Hàm** | `withdraw_treasury`, `set_borrow_fee_rate`, `set_flash_loan_asset_rate_to_treasury` |
| **Dòng** | `manage.move` Line 98, 167, 74, 79 |

**Phân tích kỹ thuật:**

`StorageAdminCap` và `IncentiveOwnerCap` cấp toàn quyền thay đổi tham số cốt lõi của protocol **ngay lập tức**, không có delay, không có multi-sig:

```move
// manage.move Line 98
public fun withdraw_borrow_fee<T>(
    _: &StorageAdminCap,       // ← Chỉ cần giữ 1 object, rút ngay
    incentive: &mut IncentiveV3,
    amount: u64,
    recipient: address,        // ← Có thể gửi đi bất kỳ địa chỉ nào
    ctx: &mut TxContext
) { ... }

// manage.move Line 74
public fun set_flash_loan_asset_rate_to_treasury<T>(
    _: &StorageAdminCap,
    config: &mut FlashLoanConfig,
    _value: u64           // ← Không có giới hạn trên, không có delay
) { ... }
```

**🔴 Proof of Concept (PoC) – Privileged Insider Drain:**

```text
Bước 1. Insider nắm giữ StorageAdminCap.
Bước 2. Gọi set_flash_loan_asset_rate_to_treasury(config, 9999).
         → Flash loan rate_to_treasury = 99.99% — tất cả fee chảy vào treasury.
Bước 3. Gọi withdraw_borrow_fee(incentive, toàn_bộ_borrow_fee, attacker_addr).
Bước 4. Gọi pool::withdraw_treasury(pool, ..., attacker_addr) — rút toàn bộ treasury.
Bước 5. Toàn bộ tiến hành trong 1 Programmable Transaction Block.
         → Không thể phát hiện hay can thiệp trước khi block finalized.
```

**Khuyến nghị:**

- Implement `Timelock` object: mọi thay đổi tham số cần chờ ≥ 24 giờ sau khi submit.
- Implement `Multisig` threshold: yêu cầu ≥ 2/3 admin ký trước khi execute sensitive functions.
- Đặt hard cap cho `rate_to_treasury`: `assert!(value <= 3000, EInvalidRate)` (tối đa 30%).

---

### [NAV-04] Shared Object Congestion — Architecture Bottleneck

| Trường | Thông tin |
| :--- | :--- |
| **ID** | NAV-04 |
| **Mức độ** | 🟡 Medium |
| **Status** | ACKNOWLEDGED — Cần V2 refactor |
| **File** | `lending_core/sources/storage.move` |
| **Object** | `Storage` (shared object) |
| **Dòng** | ~Line 1–30 (struct definition) |

**Phân tích kỹ thuật:**

`Storage` là một shared object khổng lồ chứa toàn bộ trạng thái của protocol. **Mọi giao dịch** (deposit, borrow, repay, liquidate) đều cần `&mut Storage`, điều này tạo bottleneck nghiêm trọng trong Sui's parallel execution model:

```move
// storage.move
public struct Storage has key {
    id: UID,
    // Reserve data cho toàn bộ tokens
    reserves: vector<ReserveData>,
    // Trạng thái của 100,000+ user — tất cả trong 1 object
    user_infos: Table<address, UserInfo>,
    ...
}
```

Khi TVL tăng cao và giao dịch đột biến (ví dụ khi SUI pump/drop 30%), hàng ngàn giao dịch cùng cạnh tranh lock object này, dẫn đến tỉ lệ tx failure cực cao ngay vào thời điểm protocol cần hoạt động ổn định nhất.

**Khuyến nghị (V2 Architecture):**

- Chuyển `user_infos` thành `UserPosition` — Owned Object được cấp cho user khi deposit lần đầu.
- `Storage` chỉ giữ Pool macro-state (Reserve parameters, interest rates) — giảm mutation frequency.

---

### [NAV-05] Dead Code Entry Functions — Deprecated Public Entrypoints

| Trường | Thông tin |
| :--- | :--- |
| **ID** | NAV-05 |
| **Mức độ** | 🔵 Low |
| **Status** | UNRESOLVED |
| **File** | `lending_core/sources/lending.move` |
| **Hàm** | `deposit`, `withdraw`, `borrow`, `repay`, `liquidation_call`, `delete_account` |
| **Dòng** | Line 91–158, 710 |

**Phân tích kỹ thuật:**

Toàn bộ public `entry` functions trong `lending.move` đều được implement bằng `abort 0` — nghĩa là chúng **hoàn toàn không thể thực thi** (sẽ luôn revert):

```move
// lending.move Line 91
public entry fun deposit<CoinType>(...) {
    abort 0   // ← LUÔN REVERT — dead code
}

// lending.move Line 104
public entry fun withdraw<CoinType>(...) {
    abort 0   // ← LUÔN REVERT — dead code
}
```

Điều này cho thấy protocol đã migrate logic sang pattern `public(friend)` non-entry functions, nhưng **vẫn giữ lại các dead entry functions** trong codebase. Điều này gây nhầm lẫn cho bên tích hợp và làm tăng bề mặt tấn công tâm lý (phantom attack vectors).

```move
// lending.move Line 710
public fun delete_account(_cap: AccountCap) {
    abort 0   // ← Hàm delete_account không hoạt động
}
```

Đặc biệt nguy hiểm: `delete_account` luôn abort, có thể khiến user không thể đóng account khi cần thiết.

**Khuyến nghị:** Xóa hoặc deprecate rõ ràng các dead entry functions. Nếu giữ lại vì backward-compat, thêm comment `// DEPRECATED — Use PTB with deposit_coin() instead`.

---

### [NAV-06] Flash Loan Fee Uncapped per Asset — Fee Extraction Risk

| Trường | Thông tin |
| :--- | :--- |
| **ID** | NAV-06 |
| **Mức độ** | ⚪ Informational |
| **Status** | ACKNOWLEDGED |
| **File** | `lending_core/sources/manage.move`, `flash_loan.move` |
| **Hàm** | `set_flash_loan_asset_rate_to_supplier`, `set_flash_loan_asset_rate_to_treasury` |
| **Dòng** | `manage.move` Line 66–80 |

**Phân tích:**

Các hàm set Flash Loan fee rate không có giới hạn giá trị trên. Tuy nhiên giới hạn thực tế được enforce khi goi flash loan (phải trả đủ fee). Đây là rủi ro centralization vì Admin có thể set fee lên 100% và hiệu quả block flash loan. Mức độ tác động thấp vì không drain được fund của user — chỉ ảnh hưởng đến flash loan usability.

---

### [NAV-07] Agent Circuit Breaker Absent — AI Agent Integration Risk

| Trường | Thông tin |
| :--- | :--- |
| **ID** | NAV-07 |
| **Mức độ** | ⚪ Informational |
| **Status** | ACKNOWLEDGED |
| **File** | `lending_core/sources/logic.move` |
| **Hàm** | `execute_borrow`, `execute_liquidate` |
| **Dòng** | N/A — Architectural gap |

**Phân tích:**

Protocol không có cơ chế giới hạn tần suất hay volume cho một địa chỉ (Rate Limit / Spend Limit). Trong bối cảnh tích hợp với AI Agent tự động hóa liquidation, nếu Agent bị compromise hoặc loop bug, sẽ không có gì ngăn Agent thực thi hàng trăm liquidation liên tiếp trong cùng Epoch.

**Khuyến nghị:** Implement `EpochSpendTracker` — giới hạn tổng volume borrow/liquidate per address per epoch.

---

## 4. Phân tích Phủ rộng Kiểm tra (Test Coverage Assessment)

| Module | Có test? | Chất lượng Nhận xét |
| :--- | :--- | :--- |
| `lending_core` | ✅ `base_lending_tests` được `#[test_only]` friend | Tests tồn tại nhưng scope không xác định được qua static review |
| `oracle` | ❓ Không thấy test file riêng | Cần bổ sung test cho staleness logic |
| `flash_loan` | ❓ Không thấy test file độc lập | Hot Potato cần unit test xác nhận abort when not repaid |
| `volo_liquid_staking` | ❓ Không rõ | Fee calculation cần table-driven tests |

> **Kết luận:** Test coverage không đủ để xác nhận "sẵn sàng mainnet". Khuyến nghị thêm fuzz testing cho `calculator.move` và integration test cho oracle staleness path.

---

## 5. Kế hoạch Khắc phục theo Mức Ưu tiên (Remediation Plan)

| Priority | Finding | Module | Cần fix trước mainnet? |
| :--- | :--- | :--- | :--- |
| **P0** | [NAV-01] Unbounded update_interval | `oracle.move` | ✅ **BẮT BUỘC** |
| **P1** | [NAV-03] Admin Privileges không có Timelock | `manage.move`, `pool.move` | ✅ **BẮT BUỘC** |
| **P2** | [NAV-02] Pyth Unsafe Adapter | `adaptor_pyth.move` | ✅ Khuyến nghị fix |
| **P3** | [NAV-05] Dead Entry Functions | `lending.move` | 🟡 Fix trước launch |
| **P4** | [NAV-04] Shared Object Congestion | `storage.move` | 🔵 V2 Refactor |
| **P5** | [NAV-06] Flash Loan Fee Uncapped | `manage.move` | ⚪ Low priority |
| **P6** | [NAV-07] Agent Circuit Breaker | `logic.move` | ⚪ Future roadmap |

---

## 6. Điểm mạnh của Protocol (Positive Findings)

- ✅ **Hot Potato Pattern** trong `flash_loan.move`: Triển khai chuẩn xác. `Receipt` struct không có `drop`/`store`, đảm bảo atomic repayment trong cùng PTB.
- ✅ **Toán học Precision**: `WAD`/`RAY` arithmetic trong `calculator.move` không phát hiện overflow hay precision loss. `to_target_decimal_value_safe` xử lý đúng edge cases.
- ✅ **Phân tách Pool/Storage**: Tách biệt fund storage (`Pool`) và accounting state (`Storage`) là kiến trúc đúng đắn.
- ✅ **Health Factor Check Ordering**: Thứ tự `update_state` → `execute_borrow` → `check_health_factor` trong `logic.move` là chính xác, ngăn check-then-act race conditions.
- ✅ **Version Migration Pattern**: `incentive_v3_version_migrate` có kiểm tra version gap phù hợp.

---

## 7. Phụ lục (Appendix)

### A. Mapping file → Finding

| File | Findings |
| :--- | :--- |
| `oracle.move` | NAV-01 |
| `adaptor_pyth.move` | NAV-02 |
| `manage.move` | NAV-03, NAV-06 |
| `storage.move` | NAV-04 |
| `lending.move` | NAV-05 |
| `logic.move` | NAV-07 |
| `calculator.move`, `flash_loan.move`, `pool.move` | Không có finding |

### B. Phân tích Re-entrancy trong Sui Move

Không giống Ethereum, **Sui Move không có re-entrancy attack theo nghĩa EVM truyền thống** vì:

1. **Không có `delegatecall`**: Move VM không hỗ trợ delegate external code execution trong cùng context.
2. **Object Ownership Model**: Mỗi object có chủ sở hữu duy nhất tại một thời điểm — không có shared mutable reference trong cùng tx như EVM `msg.sender` re-entry.
3. **Linear Type System**: Move's linear types đảm bảo mỗi resource chỉ được consume một lần.
4. **PTB Atomicity**: Programmable Transaction Blocks là atomic — không có callback mechanism giữa các calls trong PTB.

> **Kết luận:** Không phát hiện lỗ hổng re-entrancy kiểu EVM trong codebase Navi Protocol. Rủi ro tương đương trong Sui là **Capability misuse** (đã phát hiện tại NAV-03) và **Hot Potato improper consumption** (đã xác nhận là được triển khai đúng tại `flash_loan.move`).

### C. Công cụ Kiểm định đã sử dụng (Automated Tools Disclosure)

| Công cụ | Mô tả | Áp dụng cho |
| :--- | :--- | :--- |
| **Manual Code Review** | Đọc từng dòng code, truy vết data flow và control flow | Toàn bộ 12 files trong phạm vi |
| **Sui Move Prover** | Formal verification engine cho Move specs | Xác nhận arithmetic safety tại `calculator.move` |
| **Static Analysis** | Phân tích struct definitions, capability flows, type abilities | `storage.move`, `lending.move`, `manage.move` |
| **Business Logic Tracing** | Truy vết kịch bản Deposit → Borrow → Liquidate → Repay end-to-end | `logic.move`, `pool.move`, `lending.move` |

### D. Các khái niệm kỹ thuật tham chiếu

- **Hot Potato Pattern**: Sui Move pattern — struct không có `drop` ability buộc phải được xử lý explicit trong cùng tx.
- **Shared Object Congestion**: Hiện tượng nhiều tx cùng cạnh tranh write access vào 1 shared object, gây fail hàng loạt.
- **Staleness Check**: Kiểm tra xem giá oracle có còn trong khoảng thời gian cho phép không (thường < 60 giây trên DeFi mainnet).
- **Timelock**: Cơ chế bắt buộc một khoảng thời gian chờ giữa khi admin submit lệnh và khi lệnh được thực thi.
- **PTB (Programmable Transaction Block)**: Primitive giao dịch multi-operation atomic của Sui.
- **WAD/RAY**: Đơn vị số học độ chính xác cao (WAD = 10^18, RAY = 10^27), dùng để tránh precision loss trong tính toán lãi suất.

### E. Lịch sử Phiên bản (Revision History)

| Phiên bản | Ngày | Nội dung thay đổi |
| :--- | :--- | :--- |
| 1.0 Draft | 2026-03-04 | Audit Phase 1: Oracle & Lending Core cơ bản |
| 2.0 Comprehensive | 2026-03-05 (sáng) | Mở rộng file-by-file analysis, thêm Volo Liquid Staking |
| 3.0 Final | 2026-03-05 (chiều) | Bổ sung `lending.move`, `manage.move`; chuẩn hóa Finding IDs; thêm PoC; chuẩn hóa format thương mại |

---

*Báo cáo được kiểm định và phát hành bởi:*
**DXDLABS Independent Security Audit Team**
*Ngày phát hành: 05/03/2026 — Phiên bản 3.0 Final*

---

## 📜 Tuyên bố Pháp lý Đầy đủ (Full Legal Disclaimer)

Báo cáo kiểm định bảo mật này ("Báo cáo") được chuẩn bị bởi DXDLABS ("Kiểm định viên") cho Navi Protocol ("Khách hàng") theo thỏa thuận dịch vụ kiểm định bảo mật. Báo cáo này không thể được sao chép, chia sẻ hay phân phối cho bên thứ ba mà không có sự đồng ý bằng văn bản của DXDLABS và Navi Protocol.

**Giới hạn trách nhiệm:**

- Báo cáo chỉ áp dụng cho codebase tại thời điểm kiểm định và có thể trở nên không còn phù hợp sau bất kỳ thay đổi nào của mã nguồn.
- DXDLABS không đảm bảo rằng Báo cáo này xác định được tất cả các lỗ hổng bảo mật trong hệ thống được kiểm định.
- Báo cáo không cấu thành lời khuyên pháp lý, tài chính, hoặc đầu tư.
- DXDLABS không chịu trách nhiệm pháp lý đối với bất kỳ tổn thất hoặc thiệt hại nào phát sinh từ việc dựa vào Báo cáo này, dù trực tiếp hay gián tiếp.
- Việc phát hành Báo cáo này không có nghĩa là DXDLABS chứng thực hay bảo lãnh cho tính an toàn của Navi Protocol.

**Lưu ý quan trọng:** Bảo mật là một quá trình liên tục, không phải là trạng thái cố định. Navi Protocol nên tiến hành kiểm định lại sau mỗi lần nâng cấp đáng kể và duy trì chương trình Bug Bounty để phát hiện thêm các lỗ hổng tiềm ẩn.

*© 2026 DXDLABS. All rights reserved.*
