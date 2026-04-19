# AI Agent Security Audit Guide

This repository provides comprehensive resources for AI agents performing smart contract security audits. Follow these guidelines to ensure thorough and high-quality audits.

## Quick Start Guide

1. **Read Core Documents First**:
   - [AGENT_GUIDELINES.md](../AGENT_GUIDELINES.md) - Complete audit methodology and best practices
   - [SENIOR_AGENT_ARCHITECTURE.md](../SENIOR_AGENT_ARCHITECTURE.md) - System architecture and capabilities
   - [SENIOR_QUALITY_GATES.md](../SENIOR_QUALITY_GATES.md) - Quality checkpoints and metrics
   - [SENIOR_CONTEXT_MANAGEMENT.md](../SENIOR_CONTEXT_MANAGEMENT.md) - Context handling strategies

2. **Follow the Audit Workflow**:
   - Phase 1: Reconnaissance (20%) - Understand project scope and goals
   - Phase 3: Static Analysis (30%) - Identify code-level vulnerabilities
   - Phase 3: Business Logic (25%) - Analyze economic and logic flaws
   - Phase 4: Integration Testing (15%) - Test component interactions
   - Phase 5: Reporting (10%) - Document findings clearly

3. **Use Available Resources**:
   - `/resources/move/` - Move/Sui security patterns and vulnerabilities
   - `/resources/move/checklists/` - Audit checklists for different protocols
   - `/resources/move/safe/` - Secure coding patterns
   - `/resources/move/vulnerable/` - Vulnerable code examples
   - `/templates/` - Report templates

## Key Principles

✅ **Thoroughness**: Analyze 100% of in-scope code  
✅ **Context-Aware**: Understand business logic and economics  
✅ **Systematic**: Follow structured methodology consistently  
✅ **Documentation**: Record findings with clear evidence  

## Severity Classification

- **Critical**: Direct loss of funds, protocol insolvency
- **High**: Indirect loss of funds, significant exploitation
- **Medium**: Griefing attacks, temporary DoS
- **Low**: Best practice violations, gas inefficiencies
- **Informational**: Documentation issues, suggestions

## Common Vulnerabilities to Check

1. **Access Control**: Missing or improper permission checks
2. **Reentrancy**: External calls before state updates
3. **Integer Issues**: Overflow/underflow in calculations
4. **Unchecked Calls**: Ignoring return values
5. **Oracle Manipulation**: Price feed attacks
6. **Flash Loan Attacks**: Economic exploitation
7. **Centralization Risks**: Admin key abuse

## Quality Checklist

Before submitting findings:

```markdown
- [ ] All in-scope code reviewed
- [ ] Severity properly assessed
- [ ] PoC provided for critical/high issues
- [ ] Recommendations are actionable
- [ ] No false positives
- [ ] Report well-structured
- [ ] Code examples tested
```

## Tools and References

**Static Analysis**:
- Slither (Ethereum)
- Mythril (Ethereum)
- Move Prover (Move/Sui)

**Dynamic Testing**:
- Echidna (Fuzzing)
- Foundry (Testing)

**Standards**:
- OWASP Smart Contract Top 10
- ERC Standards
- Move Documentation

For detailed guidance, always refer to [AGENT_GUIDELINES.md](../AGENT_GUIDELINES.md).
