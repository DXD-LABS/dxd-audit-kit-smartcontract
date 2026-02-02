// BVSS Calculator for Web - Mirrors Python logic in core/calculator.py
class BVSSCalculator {
    constructor(config) {
        this.config = config;
        this.logic = config.scoring_logic;
        this.factors = config.blockchain_factors;
    }

    calculate(impact, likelihood, exploitability = 'Network', scope = 'Unchanged', economicLoss = 'Millions', isImmutable = true, exploitMaturity = 'POC', privilegedAccess = 'Not Required') {
        // 1. BVSS Base Score: Average of core metrics
        const impactVal = this.logic.impact_map[impact] || 1;
        const likelihoodVal = this.logic.likelihood_map[likelihood] || 1;
        const explVal = this.logic.bvss_metrics.exploitability_map[exploitability] || 1.0;
        const econVal = this.logic.bvss_metrics.economic_loss_map[economicLoss] || 1;
        const scopeMult = this.logic.bvss_metrics.scope_map[scope] || 1.0;
        
        let baseScore = (impactVal * 0.25 + likelihoodVal * 0.25 + explVal * 0.25 + econVal * 0.25) * scopeMult;
        
        // 2. Apply Immutability Multiplier
        if (isImmutable) {
            baseScore *= this.logic.multipliers.immutability;
        }
            
        // 3. Apply Blockchain Factors
        baseScore *= this.factors.exploit_maturity[exploitMaturity] || 1.0;
        baseScore *= this.factors.privileged_access[privilegedAccess] || 1.0;
        
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
        const maxPossible = maxBaseCalc * maxScope * maxImm * maxMat * maxPriv;
        
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
            color: color
        };
    }
}
