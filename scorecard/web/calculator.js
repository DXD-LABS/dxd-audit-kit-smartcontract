// BVSS Calculator for Web - Mirrors Python logic in core/calculator.py
// Premium senior-grade implementation with object support, rich details, and robust fallbacks.
class BVSSCalculator {
    constructor(config) {
        this.config = config;
        this.logic = config.scoring_logic;
        this.factors = config.blockchain_factors;
    }

    calculate(paramsOrImpact, likelihood, exploitability = 'Network', scope = 'Unchanged', economicLoss = 'Millions', isImmutable = true, exploitMaturity = 'POC', privilegedAccess = 'Not Required', agentAutonomy = 'None') {
        let p = {};
        if (typeof paramsOrImpact === 'object' && paramsOrImpact !== null) {
            p = paramsOrImpact;
        } else {
            p = {
                impact: paramsOrImpact,
                likelihood: likelihood,
                exploitability: exploitability,
                scope: scope,
                economicLoss: economicLoss,
                isImmutable: isImmutable,
                exploitMaturity: exploitMaturity,
                privilegedAccess: privilegedAccess,
                agentAutonomy: agentAutonomy
            };
        }

        // Apply defaults for fields that might be missing
        const impact = p.impact || 'Medium';
        const lik = p.likelihood || 'Medium';
        const expl = p.exploitability || 'Network';
        const scopeVal = p.scope || 'Unchanged';
        const econ = p.economicLoss || 'Millions';
        const isImm = p.isImmutable !== undefined ? p.isImmutable : true;
        const maturity = p.exploitMaturity || 'POC';
        const priv = p.privilegedAccess || 'Not Required';
        const autonomy = p.agentAutonomy || 'None';

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
        const maxExpl = Math.max(...Object.values(this.logic.bvss_metrics.exploitability_map));
        const maxEcon = Math.max(...Object.values(this.logic.bvss_metrics.economic_loss_map));
        const maxBaseCalc = (maxImpact + maxLik + maxExpl + maxEcon) / 4;
        const maxScope = Math.max(...Object.values(this.logic.bvss_metrics.scope_map));
        const maxImm = this.logic.multipliers.immutability;
        const maxMat = Math.max(...Object.values(this.factors.exploit_maturity));
        const maxPriv = Math.max(...Object.values(this.factors.privileged_access));
        const maxAut = Math.max(...Object.values(this.factors.agent_autonomy));
        const maxPossible = maxBaseCalc * maxScope * maxImm * maxMat * maxPriv * maxAut;
        
        let scaledScore = (baseScore / maxPossible) * 10;
        scaledScore = Math.min(Math.max(Math.round(scaledScore * 10) / 10, 0), 10);
        
        // 5. Determine Severity
        let severity = "Low";
        let color = "🟢";
        for (const level of this.logic.severity_levels) {
            if (scaledScore >= level.threshold) {
                severity = level.label;
                color = level.color;
                break;
            }
        }
                
        return {
            score: scaledScore,
            severity: severity,
            color: color,
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
