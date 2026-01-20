# Security Scorecard Template cho Move/Sui Contracts

**Project**: [Tên]  
**Auditor**: DxDLabs  
**Date**: [Ngày]  

**Score Breakdown** (tổng 100 points)

- Ownership & Capability: 20/20  
- Storage & Gas Optimization: 18/20  
- DeFi/Flash Loan Safety: 15/20  
- Oracle & Price Feed: 12/20  
- Upgrade & Governance: 10/20  
- NFT/Kiosk Security: 8/20  
- BTCfi Edge Cases: 7/20  
- Testing & Coverage: 5/20  

**Total Score**: 95/100  
**Risk Level**: Low (fix 2 Medium findings)  

**Quick Recommendations**  
- Fix oracle staleness check (xem oracle-integration-safe.move).  
- Add version guard cho upgrade (xem package-upgrade-safe.move).

Use this scorecard to summarize audit findings – dễ share với client.
