# Move/Sui Smart Contract Audit Checklist

## Core Concepts
- [ ] Object ownership rõ ràng? (key + store đúng cách)
- [ ] Capability không bị leak/abuse? (không public borrow, không duplicate)
- [ ] Shared object access control chặt chẽ? (event emit, version check)

## Common Vulnerabilities
- [ ] Resource leakage/duplication (object không delete đúng)
- [ ] Friend module overexposure (friend quá rộng)
- [ ] Missing reinitialization guard
- [ ] DoS via expensive loops/events
- [ ] Incorrect coin balance (merge/split không check)

## Best Practices
- [ ] Use transfer::transfer cho ownership change
- [ ] Avoid public entry fun với &Cap nếu không cần
- [ ] Emit event cho mọi thay đổi trạng thái quan trọng
- [ ] Test coverage >90% với Sui Move test

Reference: SlowMist Sui Primer, Zellic reports