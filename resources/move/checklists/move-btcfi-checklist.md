# BTCfi Security Checklist (LBTC/sBTC on Sui) | BTCfi Security Checklist (LBTC/sBTC on Sui) | BTCfi 安全清单（Sui 上的 LBTC/sBTC）

- [ ] **Mint**: Collateral BTC check on-chain/off-chain (bridge verification)? | **Mint**: Collateral BTC check on-chain/off-chain (bridge verification)? | **铸造**：链上/链下 BTC 抵押检查（桥接验证）？
- [ ] **Redeem**: Queue FIFO an toàn? (no reordering/front-running)? | **Redeem**: Safe FIFO queue? (no reordering/front-running)? | **赎回**：安全的 FIFO 队列？（无重排序/抢跑）？
- [ ] **Liquidation**: Health factor calc đúng? (oracle dependency)? | **Liquidation**: Correct health factor calculation? (oracle dependency)? | **清算**：健康因子计算正确？（预言机依赖）？
- [ ] **Wrapped BTC unwrap**: No double-spend or balance leak? | **Wrapped BTC unwrap**: No double-spend or balance leak? | **Wrapped BTC 解包**：无双重支出或余额泄漏？
- [ ] **Admin cap**: Restrict mint/redeem? (capability guard). | **Admin cap**: Restrict mint/redeem? (capability guard). | **管理员权能**：限制铸造/赎回？（权能保护）。
- [ ] **Events**: Event emit cho mọi mint/redeem/liquidation? | **Events**: Event emitted for every mint/redeem/liquidation? | **事件**：每次铸造/赎回/清算是否都发送事件？

Reference: Audit reports BTCfi protocols 2025-2026 (Bucket, NAVI BTCfi) | 参考：2025-2026 年 BTCfi 协议审计报告（Bucket, NAVI BTCfi）
