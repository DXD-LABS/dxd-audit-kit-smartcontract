// BVSS Calculator for Web - Mirrors Python logic in core/calculator.py
class BVSSCalculator {
    constructor(config) {
        this.config = config;
        this.logic = config.scoring_logic;
        this.factors = config.blockchain_factors;
    }

    calculate(impact, likelihood, isImmutable = true, exploitMaturity = 'POC', privilegedAccess = 'Not Required') {
        // 1. Base Score calculation using weights
        const impactVal = this.logic.impact_map[impact] || 1;
        const likelihoodVal = this.logic.likelihood_map[likelihood] || 1;
        
        // Weighted average
        let baseScore = (impactVal * this.logic.weights.impact) + (likelihoodVal * this.logic.weights.likelihood);
        
        // 2. Apply Immutability Multiplier
        if (isImmutable) {
            baseScore *= this.logic.multipliers.immutability;
        }
            
        // 3. Apply Blockchain Factors
        baseScore *= this.factors.exploit_maturity[exploitMaturity] || 1.0;
        baseScore *= this.factors.privileged_access[privilegedAccess] || 1.0;
        
        // 4. Scale to 0-10
        const maxBase = (4 * 0.6 + 3 * 0.4); // 3.6
        const maxPossible = maxBase * 1.5 * 1.2 * 1.1; // 7.128
        
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
