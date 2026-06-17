import { ScanFinding } from './types';

export const scanTemplates = {
  oracle: `module dxdlabs::oracle_freshness {
    use sui::clock::{Self, Clock};
    
    struct OraclePrice has key, store {
        id: UID,
        value: u64,
        last_updated: u64
    }

    // VULNERABLE: No price staleness freshness check. Accepts stale price!
    public fun get_price_unsafe(oracle: &OraclePrice): u64 {
        oracle.value
    }

    // SECURE: Enforces strict price freshness and staleness duration check
    public fun get_price_secure(oracle: &OraclePrice, clock: &Clock): u64 {
        let now = clock::timestamp_ms(clock);
        // Staleness guard check: price must not be older than 3600 seconds
        assert!(now - oracle.last_updated <= 3600000, 1001); 
        oracle.value
    }
}`,
  shift: `module dxdlabs::math_shift {
    const OVERFLOW: u64 = 4001;

    // VULNERABLE: Incorrect shift range check bounds (> 256)
    public fun checked_shlw_unsafe(x: u256, shift: u8): u256 {
        if (shift > 256) abort OVERFLOW;  // Flawed limit threshold!
        x << shift
    }

    // SECURE: Strict shift range checks (< 192 appropriate for Sui math)
    public fun checked_shlw_secure(x: u256, shift: u8): u256 {
        if (shift > 192) abort OVERFLOW;  // Valid threshold bound constraint
        x << shift
    }
}`,
  upgrade: `module dxdlabs::package_upgrade {
    struct State has key {
        id: UID,
        version: u64,
        admin: address
    }

    // VULNERABLE: Missing upgrade package state migration check logic
    public fun migrate_state_unsafe(state: &mut State, ctx: &TxContext) {
        // Overwrite variables without checking sender or capability matching!
        state.version = state.version + 1;
    }

    // SECURE: Strict version upgrades and sender assert policies
    public fun migrate_state_secure(state: &mut State, ctx: &TxContext) {
        assert!(tx_context::sender(ctx) == state.admin, 1001); // Auth check
        // Strict version migration validation checks
        assert!(state.version < 5, 1002);
        state.version = state.version + 1;
    }
}`,
  flashloan: `module dxdlabs::flash_loan {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};

    struct Receipt has key, store, drop {
        amount: u64,
        fee: u64
    }

    struct Pool<phantom T> has key {
        id: UID,
        balance: Balance<T>
    }

    // VULNERABLE: Returning receipt instead of standard "hot potato" (which has no drop/store/key)
    // If flash loan Receipt has drop/store/key capabilities, it can be dropped manually bypass repayments!
    // Receipt should NOT have drop, store, or key, enforcing direct destruction check in repayment module.
    public fun flash_loan_unsafe<T>(pool: &mut Pool<T>, amount: u64, ctx: &mut TxContext): (Coin<T>, Receipt) {
        let coin = coin::from_balance(balance::split(&mut pool.balance, amount), ctx);
        (coin, Receipt { amount, fee: 10 })
    }
}`
};

export function runCodeScanner(code: string): ScanFinding[] {
  const findings: ScanFinding[] = [];
  if (!code || !code.trim()) {
    return findings;
  }

  // Rule 1: Shift overflow check bounds
  if (code.includes('checked_shlw') || code.includes('<<')) {
    if (code.includes('shift > 256') || code.includes('shift >= 256')) {
      findings.push({
        title: "Arithmetic Shift Out-Of-Bounds (Bitwise Overflow Risk)",
        severity: "Critical",
        desc: "Detected custom math shifting logic that checks if 'shift > 256'. Inside Sui Move, shifting u256 values by amounts exceeding 192 yields overflows that corrupt liquidity mathematics (This identical flaw was exploited in the Cetus Protocol hack, leaking $223M in TVL).",
        remedy: "if (shift > 192) abort E_SHIFT_OUT_OF_BOUNDS;",
        type: "critical"
      });
    }
  }

  // Rule 2: Oracle price staleness check
  if (code.includes('get_price') || code.includes('price')) {
    if (!code.includes('clock::timestamp_ms') && !code.includes('now - last_updated') && !code.includes('MAX_STALE_SECS')) {
      findings.push({
        title: "Missing Oracle Price Staleness Verification (Flash Loan Oracle Attack)",
        severity: "High",
        desc: "Hàm get_price retrieves oracle feeds without verifying price age using Clock timestamp updates. Exploitable via network congestion to borrow heavily on stale rates.",
        remedy: "assert!(clock::timestamp_ms(clock) - oracle.last_updated <= MAX_STALE_TIME, E_STALE_PRICE);",
        type: "high"
      });
    }
  }

  // Rule 3: Upgrade version downgrade vulnerability
  if (code.includes('migrate') || code.includes('upgrade')) {
    if (!code.includes('assert!') && !code.includes('version')) {
      findings.push({
        title: "Missing Version Constraints in Upgrades (Downgrade Exploits)",
        severity: "Medium",
        desc: "Contract upgrade package migrations lack progressive validation checking. Allows rogue downgrading or hijacking of Shared Objects.",
        remedy: "assert!(state.version == CURRENT_VERSION, E_INVALID_VERSION);",
        type: "warning"
      });
    }
  }

  // Rule 4: Flash Loan Hot Potato leakage
  if (code.includes('flash_loan') || code.includes('Receipt')) {
    if (code.includes('Receipt has key, store, drop') || code.includes('drop')) {
      findings.push({
        title: "Receipt Bypass in Flash Loan (Capital Leakage)",
        severity: "Critical",
        desc: "The transaction Receipt carries drop abilities, allowing borrowers to silently garbage collect loan structures bypassing repayment loops completely.",
        remedy: "struct Receipt { amount: u64, fee: u64 } // Eliminate drop capability",
        type: "critical"
      });
    }
  }

  return findings;
}
