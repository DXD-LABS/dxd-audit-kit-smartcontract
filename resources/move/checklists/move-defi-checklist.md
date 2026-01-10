## DeFi-Specific Checklist (Flash Loan, Lending, DEX trên Sui) | DeFi-Specific Checklist (Flash Loan, Lending, DEX on Sui) | DeFi 专用清单（Sui 上的闪电贷、借贷、DEX）

- [ ] Flash Loan (Hot Potato):
    - Loan object có key, không store? (phải destroy trong tx) | Loan object has key, no store? (must be destroyed in tx) | 贷款对象是否有 key，无 store？（必须在交易中销毁）
    - Repay function bắt buộc gọi trong cùng tx? (không drop/transfer loan) | Repay function must be called in the same tx? (no drop/transfer loan) | 还款函数是否必须在同一交易中调用？（不可丢弃/转让贷款）
    - Pool balance check trước/sau borrow/repay? (avoid negative balance) | Pool balance check before/after borrow/repay? (avoid negative balance) | 借入/还款前后的池余额检查？（避免负余额）

- [ ] Lending/Borrowing (NAVI/Scallop style):
    - Collateral factor & liquidation threshold check chặt chẽ? | Strict collateral factor & liquidation threshold checks? | 严格的抵押因子和清算阈值检查？
    - Interest rate model (variable/stable) update an toàn, không overflow? | Safe interest rate model (variable/stable) updates, no overflow? | 安全的利率模型（浮动/稳定）更新，无溢出？
    - Isolation mode: Borrow asset có bị restrict đúng? (no cross-pool borrow) | Isolation mode: Borrow assets restricted correctly? (no cross-pool borrow) | 隔离模式：借入资产是否受到正确限制？（无跨池借款）

- [ ] DEX/AMM (Cetus CLMM):
    - Tick math an toàn? (no overflow in tick spacing/liquidity calc) | Safe tick math? (no overflow in tick spacing/liquidity calc) | 安全的 Tick 计算？（Tick 间距/流动性计算无溢出）
    - Position NFT ownership transfer check? | Position NFT ownership transfer check? | 头寸 NFT 所有权转移检查？
    - Fee collection: Protocol fee + LP fee split đúng, không leak? | Fee collection: Protocol fee + LP fee split correctly, no leak? | 费用收取：协议费 + LP 费分成是否正确，无泄漏？

- [ ] Oracle Integration:
    - Price feed staleness check (timestamp + max_age)? | Price feed staleness check (timestamp + max_age)? | 价格推送陈旧性检查（时间戳 + 最大年龄）？
    - Multiple oracle sources (fallback mechanism)? | Multiple oracle sources (fallback mechanism)? | 多个预言机源（回退机制）？
    - Price deviation threshold (circuit breaker nếu >X%)? | Price deviation threshold (circuit breaker if >X%)? | 价格偏差阈值（如果 >X% 则触发熔断）？

- [ ] BTCfi/LBTC/sBTC:
    - Mint/redeem logic: BTC collateral check on-chain/off-chain? | Mint/redeem logic: BTC collateral check on-chain/off-chain? | 铸造/赎回逻辑：链上/链下 BTC 抵押检查？
    - Redemption queue: FIFO an toàn, no reordering attack? | Redemption queue: Safe FIFO, no reordering attack? | 赎回队列：安全的 FIFO，无重排序攻击？
    - Liquidation oracle: Health factor calculation đúng, avoid manip? | Liquidation oracle: Health factor calculation correct, avoid manipulation? | 清算预言机：健康因子计算正确，避免操纵？

## NFT/Kiosk-Specific Checklist | NFT/Kiosk-Specific Checklist | NFT/Kiosk 专用清单

- [ ] Kiosk Ownership:
    - KioskOwnerCap transfer an toàn? (không public borrow) | Safe KioskOwnerCap transfer? (no public borrow) | 安全的 KioskOwnerCap 转让？（无公开借用）
    - NFT place/list/withdraw chỉ owner cap mới làm? | NFT place/list/withdraw only by owner cap? | NFT 放置/列出/提取仅限 owner cap 执行？

- [ ] Transfer Policy:
    - Royalty enforced qua TransferPolicy<MyNFT>? | Royalty enforced via TransferPolicy<MyNFT>? | 是否通过 TransferPolicy<MyNFT> 强制执行版权费？
    - Listing price + royalty fee tính đúng? | Listing price + royalty fee calculated correctly? | 挂牌价格 + 版权费计算是否正确？

- [ ] Collection & Display:
    - Collection object shared an toàn? (no unauthorized update) | Collection object shared safely? (no unauthorized update) | 集合对象是否安全共享？（无未授权更新）
    - Display metadata update restrict (chỉ creator)? | Display metadata update restricted (creator only)? | 显示元数据更新限制（仅限创建者）？

## Upgrade & Governance Checklist | Upgrade & Governance Checklist | 升级与治理清单

- [ ] Package Upgrade:
    - UpgradeCap chỉ admin hold? (transfer an toàn) | UpgradeCap held only by admin? (safe transfer) | UpgradeCap 是否仅由管理员持有？（安全转让）
    - Version check tăng dần, no downgrade? | Increasing version check, no downgrade? | 版本检查递增，无降级？
    - New package compatible với old storage? | New package compatible with old storage? | 新包是否与旧存储兼容？

- [ ] Shared Object Governance:
    - Shared object update require version check? | Shared object updates require version check? | 共享对象更新是否需要版本检查？
    - Admin capability cho shared object không leak? | Admin capability for shared object not leaked? | 共享对象的管理员 capability 未泄漏？
    - Event emit cho mọi governance action? | Event emitted for every governance action? | 每次治理操作是否都发送事件？

## General Security & Gas Optimization | General Security & Gas Optimization | 通用安全与 Gas 优化

- [ ] Gas: Entry functions không loop lớn (avoid DoS)? | Gas: Entry functions without large loops (avoid DoS)? | Gas：Entry 函数无大循环（避免 DoS）？
- [ ] Storage: Object delete khi không cần (avoid storage bloat)? | Storage: Objects deleted when not needed (avoid storage bloat)? | 存储：不需要时删除对象（避免存储膨胀）？
- [ ] Access Control: Public entry functions restrict bằng capability? | Access Control: Public entry functions restricted by capability? | 访问控制：Public entry 函数是否受 capability 限制？
- [ ] Testing: Coverage >90%? (unit test + integration test)? | Testing: Coverage >90%? (unit test + integration test)? | 测试：覆盖率 >90%？（单元测试 + 集成测试）？