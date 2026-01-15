# Quick Audit Template cho Move/Sui | Quick Audit Template for Move/Sui | Move/Sui 快速审计模板

1. Ownership & Capability | Ownership & Capability | 所有权与权限
   - [ ] Object có key + store đúng? Không public borrow cap? | Object has key + store? No public borrow cap? | 对象是否具有正确的 key + store？是否存在公共借用权限 (public borrow cap)？
   - [ ] AdminCap transfer an toàn? | Safe AdminCap transfer? | AdminCap 的转移是否安全？

2. Storage & Gas | Storage & Gas | 存储与 Gas
   - [ ] Object delete khi không cần? (avoid leak/bloat) | Object deleted when not needed? (avoid leak/bloat) | 不再需要的对象是否已删除？（避免存储泄漏/膨胀）
   - [ ] Entry function loop lớn? (DoS risk) | Large loop in entry function? (DoS risk) | 入口函数 (entry function) 是否存在大循环？（拒绝服务 DoS 风险）

3. DeFi/NFT Hot Checks | DeFi/NFT Hot Checks | DeFi/NFT 重点检查
   - [ ] Flash loan repay trong tx? (hot potato destroy) | Flash loan repaid in the same tx? (hot potato destroy) | 闪电贷是否在同一次交易中偿还？（hot potato 是否被销毁）
   - [ ] Oracle staleness + fallback? | Oracle staleness + fallback? | 预言机 (Oracle) 是否检查了数据时效性 (staleness) 并有回退机制？
   - [ ] KioskOwnerCap restrict listing/withdraw? | KioskOwnerCap restricts listing/withdraw? | KioskOwnerCap 是否限制了上架 (listing) 和提取 (withdraw)？

4. Tools Run | Tools Run | 工具运行
   - [ ] Sui move test coverage >90%? | Sui move test coverage >90%? | Sui Move 测试覆盖率是否 >90%？
   - [ ] Move analyzer/Prover cho critical logic? | Move analyzer/Prover for critical logic? | 关键逻辑是否使用了 Move analyzer/Prover？

Notes: Bắt đầu từ entry functions → trace capability flow. Dùng snippets trong repo này để so sánh. | Notes: Start from entry functions → trace capability flow. Use snippets in this repo for comparison. | 备注：从入口函数开始 → 追踪权限流。使用此代码库中的片段进行对比。
