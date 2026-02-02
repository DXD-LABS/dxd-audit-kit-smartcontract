import json
import os

class BVSSCalculator:
    def __init__(self, config_path=None):
        if config_path is None:
            # Default path relative to this file
            config_path = os.path.join(os.path.dirname(__file__), '..', 'scorecard_config.json')
        
        with open(config_path, 'r', encoding='utf-8') as f:
            self.config = json.load(f)
        
        self.logic = self.config['scoring_logic']
        self.factors = self.config['blockchain_factors']

    def calculate(self, impact, likelihood, is_immutable=True, exploit_maturity='POC', privileged_access='Not Required'):
        # 1. Base Score calculation using weights
        impact_val = self.logic['impact_map'].get(impact, 1)
        likelihood_val = self.logic['likelihood_map'].get(likelihood, 1)
        
        # Weighted average
        base_score = (impact_val * self.logic['weights']['impact']) + (likelihood_val * self.logic['weights']['likelihood'])
        
        # 2. Apply Immutability Multiplier
        if is_immutable:
            base_score *= self.logic['multipliers']['immutability']
            
        # 3. Apply Blockchain Factors
        base_score *= self.factors['exploit_maturity'].get(exploit_maturity, 1.0)
        base_score *= self.factors['privileged_access'].get(privileged_access, 1.0)
        
        # 4. Scale to 0-10
        # Max theoretical: (4*0.6 + 3*0.4) * 1.5 * 1.2 * 1.1 = 3.6 * 1.5 * 1.32 = 7.128
        # We need to scale this to 10. Let's find the max possible.
        max_base = (4 * 0.6 + 3 * 0.4) # 3.6
        max_possible = max_base * 1.5 * 1.2 * 1.1 # 7.128
        
        scaled_score = (base_score / max_possible) * 10
        scaled_score = min(max(round(scaled_score, 1), 0), 10)
        
        # 5. Determine Severity
        severity = "Low"
        color = "🟢"
        for level in self.logic['severity_levels']:
            if scaled_score >= level['threshold']:
                severity = level['label']
                color = level['color']
                break
                
        return {
            "score": scaled_score,
            "severity": severity,
            "color": color
        }

if __name__ == "__main__":
    calc = BVSSCalculator()
    print(calc.calculate("Critical", "High", True, "Active", "Not Required"))
