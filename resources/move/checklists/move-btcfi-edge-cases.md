# BTCfi Edge Cases Checklist (LBTC/sBTC on Sui) | BTCfi 边缘案例清单

- [ ] **Mint**: Collateral BTC verify on-chain (bridge proof) + off-chain oracle? | 铸造：链上 BTC 抵押验证（桥接证明）+ 链下预言机？
- [ ] **Redeem**: Queue FIFO strict? (no reordering/front-running attack)? | 赎回：严格的 FIFO 队列？（无重排序/抢跑攻击）？
- [ ] **Liquidation**: Health factor calc an toàn? (oracle manip resistant)? | 清算：健康因子计算安全？（抗预言机操纵）？
- [ ] **Unwrap LBTC**: No double-spend? (balance check + event emit)? | 解包 LBTC：无双重支出？（余额检查 + 事件发送）？
- [ ] **Admin cap**: Restrict mint/redeem/liquidation? (capability guard) | 管理员权能：限制铸造/赎回/清算？（权能保护）
- [ ] **Edge case**: Zero collateral redeem? (prevent infinite loop) | 边缘案例：零抵押赎回？（防止无限循环）
- [ ] **Gas**: Large queue processing → DoS risk? (pagination) | Gas：大队列处理 → DoS 风险？（分页）

Reference: BTCfi audit reports (Bucket Protocol, NAVI BTCfi 2025-2026)
