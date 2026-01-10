# Move/Sui Smart Contract Audit Checklist | Move/Sui 智能合约审计清单

## Core Concepts | Core Concepts | 核心概念
- [ ] Object ownership rõ ràng? (key + store đúng cách) | Clear object ownership? (proper use of key + store) | 对象所有权是否清晰？（正确使用 key + store）
- [ ] Capability không bị leak/abuse? (không public borrow, không duplicate) | No capability leak/abuse? (no public borrow, no duplication) | Capability 是否存在泄漏/滥用？（无公开借用，无重复）
- [ ] Shared object access control chặt chẽ? (event emit, version check) | Strict shared object access control? (event emit, version check) | 共享对象访问控制是否严格？（事件发送，版本检查）

## Common Vulnerabilities | Common Vulnerabilities | 常见漏洞
- [ ] Resource leakage/duplication (object không delete đúng) | Resource leakage/duplication (objects not deleted properly) | 资源泄漏/重复（对象未正确删除）
- [ ] Friend module overexposure (friend quá rộng) | Friend module overexposure (friend scope too broad) | Friend 模块过度暴露（friend 范围过大）
- [ ] Missing reinitialization guard | Missing reinitialization guard | 缺失重新初始化保护
- [ ] DoS via expensive loops/events | DoS via expensive loops/events | 通过高耗能循环/事件导致的 DoS
- [ ] Incorrect coin balance (merge/split không check) | Incorrect coin balance (merge/split without checks) | 代币余额不正确（合并/拆分未检查）

## Best Practices | Best Practices | 最佳实践
- [ ] Use transfer::transfer cho ownership change | Use transfer::transfer for ownership changes | 使用 transfer::transfer 进行所有权变更
- [ ] Avoid public entry fun với &Cap nếu không cần | Avoid public entry fun with &Cap if not needed | 如果不需要，避免对 &Cap 使用 public entry fun
- [ ] Emit event cho mọi thay đổi trạng thái quan trọng | Emit events for all critical state changes | 为所有关键状态更改发送事件
- [ ] Test coverage >90% với Sui Move test | Test coverage >90% with Sui Move tests | Sui Move 测试覆盖率 >90%

Reference: SlowMist Sui Primer, Zellic reports