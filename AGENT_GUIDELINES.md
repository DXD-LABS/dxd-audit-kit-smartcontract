# AI Agent Guidelines for Smart Contract Auditing

## Overview

This document provides comprehensive guidelines for AI agents performing smart contract security audits. These guidelines ensure consistent, thorough, and high-quality audit outcomes while following industry best practices.

## Core Principles

### 1. Thoroughness Over Speed

- **Complete Coverage**: Analyze 100% of in-scope code
- **Deep Analysis**: Don't just scan for known patterns; understand business logic
- **Multiple Passes**: Review code at different levels (architecture, logic, implementation)
- **Edge Cases**: Consider unusual scenarios and boundary conditions

### 2. Context-Aware Analysis

- **Business Understanding**: Comprehend the protocol's purpose and economics
- **Technical Stack**: Know the blockchain platform specifics (Ethereum, Move/Sui, etc.)
- **Integration Awareness**: Understand external dependencies and interactions
- **Historical Context**: Learn from similar protocols and past exploits

### 3. Systematic Approach

- **Structured Methodology**: Follow the audit workflow consistently
- **Documentation**: Record findings, reasoning, and evidence
- **Reproducibility**: Ensure findings can be validated independently
- **Traceability**: Link findings to specific code locations

## Audit Workflow

### Phase 1: Reconnaissance (20% of time)

**Objectives:**
- Understand project scope and goals
- Identify critical components
- Map attack surface
- Gather context

**Tasks:**
1. Read all documentation (README, whitepaper, docs/)
2. Review test files to understand expected behavior
3. Identify privileged roles and access controls
4. Map external dependencies (oracles, DEXs, bridges)
5. Note deployment environments and constraints

**Deliverables:**
- Project overview document
- Architecture diagram
- Attack surface map
- Risk assessment matrix

### Phase 2: Static Analysis (30% of time)

**Objectives:**
- Identify code-level vulnerabilities
- Find common security anti-patterns
- Assess code quality

**Tasks:**
1. Run automated tools (Slither, Mythril, MythX, Move Prover)
2. Manual code review for:
   - Access control issues
   - Integer overflow/underflow  
   - Reentrancy vulnerabilities
   - Unchecked external calls
   - Front-running risks
   - Gas optimization issues
3. Review dependencies for known vulnerabilities
4. Check for proper event emission
5. Verify error handling

### Phase 3: Business Logic Analysis (25% of time)

**Focus**: Understanding intended behavior and identifying logic flaws

**Key Areas:**
- Token economics and incentive structures
- Mathematical models (pricing, rewards)
- Governance mechanisms  
- Oracle manipulation risks
- Centralization concerns

### Phase 4: Integration Testing (15% of time)

**Focus**: Component interactions and attack scenarios

**Activities:**
- Test cross-contract calls
- Simulate attack vectors
- Verify external dependencies
- Check composability risks

### Phase 5: Reporting (10% of time)

**Focus**: Clear documentation and actionable recommendations

## Severity Classification

**Critical:** Direct loss of funds, protocol insolvency
**High:** Indirect loss of funds, significant exploitation  
**Medium:** Griefing attacks, temporary DoS
**Low:** Best practice violations, gas inefficiencies
**Informational:** Documentation issues, suggestions

## Best Practices for AI Agents

### Do's ✅

- Always read the complete codebase
- Understand the business model
- Test theories with Proof of Concepts
- Document all reasoning
- Consider economic attack vectors
- Think like an attacker
- Provide specific remediation
- Stay updated on latest exploits

### Don'ts ❌

- Never rely solely on automated tools
- Don't skip "unimportant" code sections
- Don't assume standard libraries are safe
- Don't rush to conclusions
- Don't ignore centralization risks
- Don't be vague in findings
- Don't report non-issues as vulnerabilities

## Common Vulnerability Patterns

### Reentrancy
**Risk**: External calls before state updates
**Fix**: Use checks-effects-interactions pattern or ReentrancyGuard

### Access Control
**Risk**: Missing or improper permission checks
**Fix**: Implement role-based access control (RBAC)

### Integer Issues  
**Risk**: Overflow/underflow in calculations
**Fix**: Use SafeMath or Solidity >= 0.8.0

### Unchecked Calls
**Risk**: Ignoring return values from external calls
**Fix**: Always check return values

## Platform-Specific Considerations

### Ethereum/EVM
- Gas optimization
- MEV considerations
- Block timestamp manipulation
- EVM quirks (delegatecall, selfdestruct)

### Move/Sui
- Resource safety
- Ability usage
- Object ownership
- Shared objects concurrency

## Quality Assurance Checklist

Before finalizing findings:

```markdown
- [ ] All in-scope code reviewed
- [ ] Severity properly assessed
- [ ] PoC provided for critical/high issues
- [ ] Recommendations are actionable
- [ ] No false positives
- [ ] Report well-structured
- [ ] Code examples tested
- [ ] References verified
```

## Communication Guidelines

### With Clients
- Be professional and constructive
- Use clear, technical language
- Provide regular updates
- Flag critical issues immediately

### In Reports
- Be specific and actionable
- Avoid alarmist tone
- Include code examples
- Reference similar vulnerabilities

## Continuous Learning

### Stay Updated
- Review security blogs (Rekt News, Immunefi)
- Study post-mortem reports
- Analyze bug bounty write-ups
- Read academic papers

### Knowledge Sharing
- Document new attack vectors
- Update vulnerability patterns library
- Share interesting findings with team
- Contribute to knowledge base

## Ethics and Professionalism

### Confidentiality
- Never disclose client code publicly
- Respect NDA terms strictly
- Don't share findings before disclosure period

### Integrity  
- Report all findings honestly
- Don't suppress critical issues
- Avoid conflicts of interest
- Follow responsible disclosure

## Emergency Protocol

### Critical Vulnerability Discovery

1. Verify the vulnerability is real
2. Assess immediate risk
3. Notify team lead
4. Contact client immediately
5. Provide temporary mitigation if possible
6. Document thoroughly

## Tools and Resources

### Essential Tools
- **Static Analysis**: Slither, Mythril, Move Prover
- **Dynamic Analysis**: Echidna, Foundry
- **Utilities**: Tenderly, Etherscan

### Reference Materials
- ERC standards documentation
- Move language documentation  
- OWASP Smart Contract Top 10
- Platform-specific security guides
- Project-specific checklists in `/resources/`

## Related Documentation

For deeper understanding, review these documents:

- **[SENIOR_AGENT_ARCHITECTURE.md](./SENIOR_AGENT_ARCHITECTURE.md)**: System architecture and capabilities
- **[SENIOR_QUALITY_GATES.md](./SENIOR_QUALITY_GATES.md)**: Quality checkpoints and metrics
- **[SENIOR_CONTEXT_MANAGEMENT.md](./SENIOR_CONTEXT_MANAGEMENT.md)**: Context handling strategies
- **[README.md](./README.md)**: Project overview and usage

## Conclusion

Following these guidelines ensures AI agents perform audits that are:

✅ **Comprehensive**: Full security coverage
✅ **Accurate**: High-quality findings, low false positives  
✅ **Actionable**: Clear remediation recommendations
✅ **Professional**: Well-documented and properly communicated

**Remember**: The goal is not just finding vulnerabilities, but helping build more secure blockchain protocols. Every audit prevents potential exploits and protects users' assets.

---

**Last Updated**: January 2026
**Version**: 1.0
