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

    def calculate(self, impact, likelihood, exploitability='Network', scope='Unchanged', economic_loss='Millions', is_immutable=True, exploit_maturity='POC', privileged_access='Not Required'):
        # 1. BVSS Base Score: Average of core metrics (Impact, Likelihood, Exploitability, Economic Loss)
        impact_val = self.logic['impact_map'].get(impact, 1)
        likelihood_val = self.logic['likelihood_map'].get(likelihood, 1)
        expl_val = self.logic['bvss_metrics']['exploitability_map'].get(exploitability, 1.0)
        econ_val = self.logic['bvss_metrics']['economic_loss_map'].get(economic_loss, 1)
        scope_mult = self.logic['bvss_metrics']['scope_map'].get(scope, 1.0)
        
        base_score = (impact_val * 0.25 + likelihood_val * 0.25 + expl_val * 0.25 + econ_val * 0.25) * scope_mult
        
        # 2. Apply Immutability Multiplier
        if is_immutable:
            base_score *= self.logic['multipliers']['immutability']
            
        # 3. Apply Blockchain Factors
        base_score *= self.factors['exploit_maturity'].get(exploit_maturity, 1.0)
        base_score *= self.factors['privileged_access'].get(privileged_access, 1.0)
        
        # 4. Dynamic Scale to 0-10 (BVSS max possible)
        max_impact = 4
        max_lik = 3
        max_expl = max(self.logic['bvss_metrics']['exploitability_map'].values())
        max_econ = max(self.logic['bvss_metrics']['economic_loss_map'].values())
        max_base = (max_impact + max_lik + max_expl + max_econ) / 4.0
        max_scope = max(self.logic['bvss_metrics']['scope_map'].values())
        max_imm = self.logic['multipliers']['immutability']
        max_mat = max(self.factors['exploit_maturity'].values())
        max_priv = max(self.factors['privileged_access'].values())
        max_possible = max_base * max_scope * max_imm * max_mat * max_priv
        
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
