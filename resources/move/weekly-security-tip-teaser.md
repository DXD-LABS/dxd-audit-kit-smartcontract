# Weekly Security Tip Series (Move/Sui) – DxDLabs Audit Kit

Mỗi tuần mình sẽ post 1 tip ngắn về an toàn smart contract Move/Sui trên X (@Loki_Alcie) và repo này.

Tip được thiết kế ngắn gọn, dễ áp dụng ngay cho dev/auditor.

**Tip #1: Capability – Không public borrow**  
Luôn dùng ownership (AdminCap has key) hoặc &mut, không public borrow &AdminCap → tránh capability abuse.  
Xem: resources/move/safe/capability-safe.move

**Tip #2: Flash Loan – Destroy hot potato trong tx**  
Flash loan Sui dùng hot potato object – phải destroy trong cùng tx, không drop/transfer ra ngoài → tránh leak storage.  
Xem: resources/move/safe/flash-loan-hot-potato-safe.move

**Tip #3: Oracle – Check staleness**  
Luôn check timestamp + max_age cho price feed → tránh stale price manipulation.  
Xem: resources/move/safe/oracle-integration-safe.move

**Tip #4: Upgrade – Version guard bắt buộc**  
Package upgrade phải assert new_version > current_version → tránh downgrade attack.  
Xem: resources/move/safe/package-upgrade-safe.move

**Tip #5: Kiosk – Enforce OwnerCap**  
Listing/withdraw NFT phải dùng KioskOwnerCap → tránh unauthorized access.  
Xem: resources/move/safe/kiosk-pattern-safe.move

**Tip #6: BTCfi – Queue FIFO cho redeem**  
Redemption queue phải FIFO strict (no reordering) → tránh front-running attack.  
Xem: resources/move/checklists/move-btcfi-edge-cases.md

**Tip #7: Object – Delete khi không cần**  
Object không dùng nữa thì delete ngay → tránh storage bloat & DoS.  
Xem: resources/move/vulnerable/resource-leak.move (fix: object::delete)

**Tip #8: Shared Object – Version check**  
Shared object update phải check version tăng dần → tránh race condition.  
Xem: resources/move/safe/shared-object-safe.move

**Tip #9: Dynamic Field – Check exists trước**  
Khi add/borrow dynamic field, luôn check exists_ → tránh overwrite sai.  
Xem: resources/move/safe/dynamic-fields-safe.move

**Tip #10: Coin – Dùng built-in check**  
Tránh custom balance → dùng Coin<T> & Balance<T> để tránh overflow/underflow.  
Xem: resources/move/safe/coin-management-safe.move

**Tip #11: Cetus Overflow – Shift limit check**  
Shift u256 trong Sui chỉ tối đa 192 (thay vì 256) → check bound chặt chẽ tránh liquidity inflate.  
Xem: vuln-db/vulns/cetus_spoof_overflow.yaml

**Tip #12: Typus Oracle – Auth check update**  
Update hàm oracle phải assert(ctx.sender() == admin) → tránh auth bypass manip prices.  
Xem: vuln-db/vulns/typus_oracle_bypass.yaml

Theo dõi repo/X (@Loki_Alcie) để nhận tip hàng tuần!  
Anh em có tip hay thì PR hoặc tag mình nhé! 💡🔒

#Sui #Move #Web3Security #SmartContractAudit #SuiVN