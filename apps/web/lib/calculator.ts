import { BVSSParams, ScoreResult } from './types';

export class BVSSCalculator {
  private config: any;
  private logic: any;
  private factors: any;

  constructor(config: any) {
    this.config = config;
    this.logic = config.scoring_logic;
    this.factors = config.blockchain_factors;
  }

  public calculate(params: Partial<BVSSParams>): ScoreResult {
    // Apply defaults for fields that might be missing
    const impact = params.impact || 'Medium';
    const lik = params.likelihood || 'Medium';
    const expl = params.exploitability || 'Network';
    const scopeVal = params.scope || 'Unchanged';
    const econ = params.economicLoss || 'Millions';
    const isImm = params.isImmutable !== undefined ? params.isImmutable : true;
    const maturity = params.exploitMaturity || 'POC';
    const priv = params.privilegedAccess || 'Not Required';
    const autonomy = params.agentAutonomy || 'None';

    // 1. BVSS Base Score: Average of core metrics
    const impactVal = this.logic.impact_map[impact] || 1;
    const likelihoodVal = this.logic.likelihood_map[lik] || 1;
    const explVal = this.logic.bvss_metrics.exploitability_map[expl] || 1.0;
    const econVal = this.logic.bvss_metrics.economic_loss_map[econ] || 1;
    const scopeMult = this.logic.bvss_metrics.scope_map[scopeVal] || 1.0;
    
    let baseScore = (impactVal * 0.25 + likelihoodVal * 0.25 + explVal * 0.25 + econVal * 0.25) * scopeMult;
    
    // 2. Apply Immutability Multiplier
    if (isImm) {
      baseScore *= this.logic.multipliers.immutability;
    }
        
    // 3. Apply Blockchain Factors
    baseScore *= this.factors.exploit_maturity[maturity] || 1.0;
    baseScore *= this.factors.privileged_access[priv] || 1.0;
    baseScore *= this.factors.agent_autonomy[autonomy] || 1.0;
    
    // 4. Dynamic Scale to 0-10 (BVSS max possible)
    const maxImpact = 4;
    const maxLik = 3;
    const maxExpl = Math.max(...(Object.values(this.logic.bvss_metrics.exploitability_map) as number[]));
    const maxEcon = Math.max(...(Object.values(this.logic.bvss_metrics.economic_loss_map) as number[]));
    const maxBaseCalc = (maxImpact + maxLik + maxExpl + maxEcon) / 4;
    const maxScope = Math.max(...(Object.values(this.logic.bvss_metrics.scope_map) as number[]));
    const maxImm = this.logic.multipliers.immutability;
    const maxMat = Math.max(...(Object.values(this.factors.exploit_maturity) as number[]));
    const maxPriv = Math.max(...(Object.values(this.factors.privileged_access) as number[]));
    const maxAut = Math.max(...(Object.values(this.factors.agent_autonomy) as number[]));
    const maxPossible = maxBaseCalc * maxScope * maxImm * maxMat * maxPriv * maxAut;
    
    let scaledScore = (baseScore / maxPossible) * 10;
    scaledScore = Math.min(Math.max(Math.round(scaledScore * 10) / 10, 0), 10);
    
    // 5. Determine Severity
    let severity: 'Critical' | 'High' | 'Medium' | 'Low' = 'Low';
    let color = '🟢';
    for (const level of this.logic.severity_levels) {
      if (scaledScore >= level.threshold) {
        severity = level.label as 'Critical' | 'High' | 'Medium' | 'Low';
        color = level.color;
        break;
      }
    }
    
    // Set contextual remedy advice
    let remedy = '';
    if (scaledScore >= 9.0) {
      remedy = `⚠️ CRITICAL MITIGATION ADVICE: Vulnerability exhibits CRITICAL SEVERITY (Score: ${scaledScore.toFixed(1)}). Immutability multiplier is active, which guarantees permanent lock risk if contracts lack upgraded Proxy implementations. Cease active mint/redeem calls and apply emergency hot patches immediately.`;
    } else if (scaledScore >= 7.0) {
      remedy = `⚡ PRIORITY ACTION REQUIRED: Risk rating evaluated at HIGH SEVERITY (Score: ${scaledScore.toFixed(1)}). Remote exploitation over public networks requires no administrative privileges. Enforce robust formal verification checks using Move Prover immediately.`;
    } else if (scaledScore >= 4.0) {
      remedy = `📋 STANDARD MITIGATION RECOMMENDED: Overall risk rated at MEDIUM (Score: ${scaledScore.toFixed(1)}). Vulnerability commonly references dynamic field upgrades, clock manipulation, or oracle updates. Verify storage fund allocations.`;
    } else {
      remedy = `💡 AUDIT NOTE: Risk rating is LOW (Score: ${scaledScore.toFixed(1)}). Document in final audit reports and optimize code quality in upcoming upgrade sprints.`;
    }

    return {
      score: scaledScore,
      severity,
      color,
      remedy,
      breakdown: {
        impact: { label: impact, val: impactVal },
        likelihood: { label: lik, val: likelihoodVal },
        exploitability: { label: expl, val: explVal },
        economicLoss: { label: econ, val: econVal },
        scope: { label: scopeVal, mult: scopeMult },
        isImmutable: { active: isImm, mult: isImm ? this.logic.multipliers.immutability : 1.0 },
        exploitMaturity: { label: maturity, mult: this.factors.exploit_maturity[maturity] || 1.0 },
        privilegedAccess: { label: priv, mult: this.factors.privileged_access[priv] || 1.0 },
        agentAutonomy: { label: autonomy, mult: this.factors.agent_autonomy[autonomy] || 1.0 },
        baseScoreRaw: baseScore,
        maxPossible: maxPossible
      }
    };
  }
}

export function calculateBVSS(params: Partial<BVSSParams>, config: any): ScoreResult {
  const calculator = new BVSSCalculator(config);
  return calculator.calculate(params);
}
