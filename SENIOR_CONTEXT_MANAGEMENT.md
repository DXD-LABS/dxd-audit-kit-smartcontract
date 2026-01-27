# Senior Context Management

## Overview

Context management is critical for senior autonomous agents performing smart contract audits. Proper context awareness enables agents to understand the broader implications of code patterns, maintain continuity across audit sessions, and make informed security assessments. This document outlines strategies and best practices for effective context management.

## Importance of Context Management

### Why Context Matters

1. **Holistic Analysis**: Understanding how components interact
2. **Pattern Recognition**: Identifying security issues across the codebase
3. **Risk Assessment**: Evaluating vulnerabilities within business context
4. **Efficient Auditing**: Avoiding redundant analysis
5. **Knowledge Retention**: Building upon previous findings

### Challenges Without Context

- Duplicate effort and wasted time
- Missed cross-contract vulnerabilities
- Incorrect severity assessments
- Failure to understand business logic
- Inconsistent findings across sessions

## Context Dimensions

### 1. Code Context

**Elements to Track:**
- Contract dependencies and inheritance
- Function call graphs
- State variable access patterns
- Event emission sequences
- Modifier usage and effects

**Storage Strategy:**
```markdown
## Contract: TokenVault
- Inherits: ERC20, Ownable, ReentrancyGuard
- Dependencies: SafeMath, PriceOracle
- State Variables: 12 (3 critical, 4 sensitive)
- External Calls: 5 functions
- Last Modified: 2025-01-20
```

### 2. Project Context

**Information to Maintain:**
- Project goals and requirements
- Target deployment environment
- Expected user roles and permissions
- Integration points with external systems
- Known limitations and constraints

**Documentation Template:**
```markdown
## Project Overview
- Name: DeFi Lending Protocol
- Platform: Ethereum/Polygon
- Purpose: Peer-to-peer lending with collateralization
- Users: Lenders, Borrowers, Liquidators
- External Integrations: Chainlink, Uniswap
- Timeline: Q1 2025 mainnet deployment
```

### 3. Security Context

**Key Aspects:**
- Previously identified vulnerabilities
- Remediation status
- Attack vectors specific to this project
- Risk areas requiring special attention
- Historical security incidents in similar projects

**Tracking Format:**
```markdown
## Security History
- Previous Audit: 2024-12-15 (8 findings, all resolved)
- Critical Areas: Flash loan protection, Oracle manipulation
- Known Risks: Centralization (admin keys), Upgrade risks
- Similar Exploits: XYZ Protocol ($2M loss, similar design)
```

### 4. Business Context

**Business Intelligence:**
- Economic model and incentive structure
- Revenue generation mechanisms
- Token economics and distribution
- Governance model
- Competitive landscape

**Analysis Framework:**
```markdown
## Business Model
- Revenue: Protocol fees (0.3% per trade)
- Value Capture: Governance token staking
- Risk Profile: Medium (collateralized lending)
- Market Position: Competing with Aave, Compound
- Unique Features: Cross-chain native, novel liquidation
```

### 5. Development Context

**Team and Process:**
- Development team expertise level
- Testing approach and coverage
- Deployment procedures
- Monitoring and maintenance plans
- Response capabilities

**Documentation:**
```markdown
## Development Profile
- Team Size: 5 developers
- Experience: 2-3 years in Web3
- Test Coverage: 85% (target 95%)
- CI/CD: GitHub Actions with automated tests
- Monitoring: Custom dashboard + Tenderly
```

## Context Storage and Retrieval

### Short-Term Context (Session-Based)

**In-Memory Storage:**
- Current analysis scope
- Working findings list
- Function call stack
- Variable tracking
- Temporary notes

**Implementation:**
```python
class AuditSession:
    def __init__(self):
        self.current_contract = None
        self.findings = []
        self.call_stack = []
        self.notes = {}
        self.visited_functions = set()
    
    def add_finding(self, finding):
        self.findings.append(finding)
        self.update_context(finding)
```

### Medium-Term Context (Audit-Based)

**Database Storage:**
- Complete contract analysis
- All identified issues
- Code annotations
- Relationship mappings
- Progress tracking

**Schema Example:**
```sql
CREATE TABLE audit_context (
    id UUID PRIMARY KEY,
    project_id UUID,
    contract_name VARCHAR(255),
    analysis_data JSONB,
    findings JSONB,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

### Long-Term Context (Knowledge Base)

**Persistent Knowledge:**
- Vulnerability patterns library
- Project history database
- Best practices repository
- Exploit case studies
- Team learning outcomes

**Organization:**
```
knowledge_base/
├── patterns/
│   ├── reentrancy/
│   ├── access_control/
│   └── oracle_manipulation/
├── projects/
│   ├── defi/
│   ├── nft/
│   └── dao/
└── exploits/
    ├── 2024/
    └── 2025/
```

## Context Management Strategies

### 1. Hierarchical Context

Organize information in layers:

```
Project Level (Global)
├── Contract Level
│   ├── Function Level
│   │   ├── Statement Level
│   │   └── Expression Level
│   └── State Level
└── Integration Level
```

### 2. Tagging and Categorization

Label context elements for quick retrieval:

```markdown
Tags: #critical #access-control #admin-function
Category: Authorization
Priority: High
Review Status: Pending
```

### 3. Context Linking

Create relationships between related elements:

```
Finding ID: F-001 (Reentrancy in withdraw())
├── Related Code: contracts/Vault.sol:45-67
├── Depends On: F-002 (Missing ReentrancyGuard)
├── Affects: User funds, Protocol solvency
└── Similar To: F-015 (In StakingPool contract)
```

### 4. Context Versioning

Track changes over time:

```markdown
## Version History
v1.0 (2025-01-10): Initial analysis
v1.1 (2025-01-15): Updated after client feedback
v1.2 (2025-01-20): Post-remediation review
```

### 5. Context Sharing

Facilitate team collaboration:

```markdown
## Shared Context
- Lead Auditor: John Doe
- Assigned Reviewers: Jane Smith, Bob Wilson
- Last Update: 2025-01-20 14:30
- Status: In Progress
- Notes: Focus on flash loan attack vectors
```

## Context Retrieval Patterns

### Query-Based Retrieval

```python
def get_context(query_params):
    """
    Retrieve relevant context based on query parameters.
    
    Args:
        query_params: Dict with contract, function, vulnerability_type
    
    Returns:
        ContextObject with relevant information
    """
    context = ContextObject()
    context.code = get_code_context(**query_params)
    context.security = get_security_context(**query_params)
    context.business = get_business_context(**query_params)
    return context
```

### Semantic Search

Find related context through similarity:

```python
def find_similar_contexts(current_finding):
    """
    Find similar past findings using embedding similarity.
    """
    embedding = generate_embedding(current_finding)
    similar = vector_db.search(embedding, top_k=5)
    return [enrich_with_context(item) for item in similar]
```

### Graph-Based Navigation

Traverse relationships:

```python
def explore_related_context(node_id, depth=2):
    """
    Explore context graph from a starting node.
    """
    graph = build_context_graph()
    related = graph.traverse_from(node_id, max_depth=depth)
    return related
```

## Context Update and Maintenance

### Automatic Updates

**Triggers:**
- New code analysis completed
- Finding added or modified
- Remediation applied
- Client feedback received
- External information discovered

**Process:**
```python
class ContextManager:
    def on_finding_added(self, finding):
        # Update related contexts
        self.update_contract_context(finding.contract)
        self.update_security_history(finding)
        self.check_pattern_library(finding)
        self.notify_related_auditors(finding)
```

### Manual Curation

**Regular Reviews:**
- Weekly context cleanup
- Monthly knowledge base updates
- Quarterly pattern library refresh
- Annual historical analysis

**Quality Checks:**
- Verify accuracy of information
- Remove outdated context
- Consolidate duplicate entries
- Enhance documentation

## Context-Aware Analysis

### Utilizing Context in Decision Making

**Risk Assessment:**
```python
def assess_risk(vulnerability, context):
    base_severity = calculate_base_severity(vulnerability)
    
    # Adjust based on context
    if context.business.high_value_locked:
        base_severity = increase_severity(base_severity)
    
    if context.security.similar_exploits_exist:
        base_severity = increase_severity(base_severity)
    
    if context.development.experienced_team:
        # Team can handle complex fixes
        remediation_complexity = "manageable"
    
    return SeverityScore(base_severity, remediation_complexity)
```

**Priority Setting:**
```python
def prioritize_findings(findings, context):
    priorities = []
    for finding in findings:
        score = 0
        score += finding.severity_score * 10
        score += context.business_impact(finding) * 5
        score += context.exploit_likelihood(finding) * 3
        priorities.append((finding, score))
    
    return sorted(priorities, key=lambda x: x[1], reverse=True)
```

## Best Practices

### For Auditors

1. **Document Continuously**: Record context as you discover it
2. **Be Specific**: Avoid vague or ambiguous context notes
3. **Link Liberally**: Connect related context elements
4. **Update Promptly**: Keep context current
5. **Review Regularly**: Verify context accuracy

### For Teams

1. **Standardize Format**: Use consistent context templates
2. **Share Proactively**: Don't hoard context information
3. **Review Together**: Regular context synchronization meetings
4. **Version Control**: Track context changes
5. **Knowledge Transfer**: Document lessons learned

### For Systems

1. **Automate Capture**: Automatic context extraction where possible
2. **Enable Search**: Robust search and retrieval capabilities
3. **Support Linking**: Easy relationship management
4. **Provide History**: Full audit trail of changes
5. **Ensure Backup**: Regular context data backups

## Common Pitfalls

### Context Overload

**Problem**: Too much information becomes noise
**Solution**: Prioritize and filter context by relevance

### Stale Context

**Problem**: Outdated information leads to wrong conclusions
**Solution**: Regular context refresh and validation

### Missing Context

**Problem**: Insufficient information for proper assessment
**Solution**: Proactive context gathering checklists

### Siloed Context

**Problem**: Information not shared across team
**Solution**: Centralized context management system

### Inconsistent Context

**Problem**: Conflicting information from different sources
**Solution**: Single source of truth with clear ownership

## Metrics and Measurement

### Context Quality Metrics

- **Completeness**: Percentage of required context captured
- **Accuracy**: Validation pass rate
- **Timeliness**: Average age of context information
- **Utilization**: How often context is accessed and used
- **Impact**: Correlation between context quality and audit quality

### Measurement Approach

```python
def measure_context_quality(context):
    metrics = {
        'completeness': count_filled_fields() / total_fields,
        'accuracy': validation_pass_count / total_validations,
        'timeliness': calculate_freshness_score(context),
        'utilization': access_count / total_audits,
        'impact': correlation(context_quality, audit_quality)
    }
    return metrics
```

## Conclusion

Effective context management is fundamental to senior autonomous agent capabilities in smart contract auditing. By maintaining comprehensive, accurate, and accessible context across multiple dimensions, agents can perform more thorough analyses, make better-informed decisions, and deliver higher quality audit results. Regular refinement of context management practices ensures continuous improvement in audit effectiveness and efficiency.
