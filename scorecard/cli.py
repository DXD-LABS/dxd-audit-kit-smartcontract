import argparse
import os
import sys
import json
from core.calculator import BVSSCalculator
from parsers.yaml_parser import VulnDBParser
try:
    from jinja2 import Environment, FileSystemLoader
    HAS_JINJA = True
except ImportError:
    HAS_JINJA = False

def main():
    parser = argparse.ArgumentParser(description='DXD Labs Security Scorecard Tool')
    parser.add_argument('--checklist', help='Path to checklist MD file')
    parser.add_argument('--vuln-id', help='Single vulnerability ID to calculate')
    parser.add_argument('--impact', choices=['Critical', 'High', 'Medium', 'Low'], help='Override impact')
    parser.add_argument('--likelihood', choices=['High', 'Medium', 'Low'], help='Override likelihood')
    parser.add_argument('--maturity', choices=['Active', 'POC', 'Theoretical'], default='POC', help='Exploit maturity')
    parser.add_argument('--exploitability', choices=['Network', 'Adjacent', 'Local'], default='Network', help='Exploitability')
    parser.add_argument('--scope', choices=['Unchanged', 'Changed'], default='Unchanged', help='Scope')
    parser.add_argument('--economic-loss', choices=['Negligible', 'Thousands', 'Millions', 'Billions'], default='Millions', help='Economic loss')
    parser.add_argument('--export-web', action='store_true', help='Export vuln-db to JSON for Web tool')
    parser.add_argument('--output', choices=['markdown', 'html', 'json'], default='markdown', help='Output format')
    parser.add_argument('--lint-output', help='Path to static-analysis JSON output')
    
    args = parser.parse_args()
    
    calc = BVSSCalculator()
    db_parser = VulnDBParser()
    
    # 1. Handle Web Export
    if args.export_web:
        output_file = 'scorecard/web/vulns_exported.json'
        if db_parser.export_all_to_json(output_file):
            print(f"✅ Exported vuln-db to {output_file}")
        else:
            print("❌ Failed to export vuln-db")
        return

    # 2. Handle Single Vuln Calculation
    if args.vuln_id:
        vuln_data = db_parser.get_vuln_data(args.vuln_id)
        if not vuln_data:
            print(f"❌ Vulnerability {args.vuln_id} not found in DB")
            # Fallback to manual input or default
            impact, likelihood = 'Medium', 'Medium'
        else:
            # Try to get simplified severity/impact
            impact = vuln_data.get('severity', vuln_data.get('impact', 'Medium'))
            # If it's a long string, try to find the keyword
            for key in ['Critical', 'High', 'Medium', 'Low']:
                if key in str(impact):
                    impact = key
                    break
            likelihood = vuln_data.get('likelihood', 'Medium')
            
            # BVSS defaults based on impact
            exploitability = 'Network' if impact in ['Critical', 'High'] else 'Adjacent' if impact == 'Medium' else 'Local'
            scope = 'Changed' if impact == 'Critical' else 'Unchanged'
            economic_loss = 'Billions' if impact == 'Critical' else 'Millions' if impact == 'High' else 'Thousands' if impact == 'Medium' else 'Negligible'
            
        # Overrides
        if args.impact: impact = args.impact
        if args.likelihood: likelihood = args.likelihood
        if args.exploitability: exploitability = args.exploitability
        if args.scope: scope = args.scope
        if args.economic_loss: economic_loss = args.economic_loss
            
        result = calc.calculate(impact, likelihood, exploitability, scope, economic_loss, True, args.maturity, 'Not Required')
        print(f"\n# Results for {args.vuln_id}")
        print(f"- Impact: {impact}")
        print(f"- Likelihood: {likelihood}")
        print(f"- Exploitability: {exploitability}")
        print(f"- Scope: {scope}")
        print(f"- Economic Loss: {economic_loss}")
        print(f"- Maturity: {args.maturity}")
        print(f"- Privileged Access: Not Required")
        print(f"- Score: {result['score']}/10")
        print(f"- Severity: {result['color']} {result['severity']}")
        return

    # 3. Handle Lint Output
    if args.lint_output:
        if not os.path.exists(args.lint_output):
            print(f"❌ Lint output {args.lint_output} not found")
            return
        
        lint_findings = []
        try:
            with open(args.lint_output, 'r', encoding='utf-8') as f:
                lint_findings = json.load(f)
        except (json.JSONDecodeError, FileNotFoundError, UnicodeDecodeError):
            pass
        
        results = []
        sev_to_impact = {'critical':'Critical', 'high':'High', 'medium':'Medium', 'low':'Low', 'info':'Low'}
        for finding in lint_findings:
            sev_lower = finding['severity']
            impact = sev_to_impact.get(sev_lower, 'Low')
            res = calc.calculate(impact, 'Medium', 'Network', 'Unchanged', 'Thousands', True, 'POC', 'Not Required')
            results.append({
                'finding': f"{finding['name']} in {finding['file']}",
                'score': res['score'],
                'severity': res['severity'],
                'color': res['color']
            })
        
        if args.output == 'markdown':
            print("# Security Scorecard from Static Analysis\n")
            print("| Finding | Score | Severity |")
            print("| :--- | :---: | :--- |")
            for res in results:
                print(f"| {res['finding'][:100]} | {res['score']} | {res['color']} {res['severity']} |")
        elif args.output == 'html':
            if not HAS_JINJA:
                print("❌ HTML output requires jinja2. Please install it: pip install jinja2")
                return
            env = Environment(loader=FileSystemLoader('scorecard/templates'))
            template = env.get_template('report.html.jinja')
            html_output = template.render(results=results, project_name="Static Analysis Scorecard")
            with open('scorecard_report.html', 'w', encoding='utf-8') as f:
                f.write(html_output)
            print("✅ Report generated: scorecard_report.html")
        elif args.output == 'json':
            print(json.dumps(results, indent=2))
        return
    
    # 4. Handle Checklist Parsing (Simple version)
    if args.checklist:
        if not os.path.exists(args.checklist):
            print(f"❌ Checklist {args.checklist} not found")
            return
            
        results = []
        with open(args.checklist, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line.startswith('- [ ]') or line.startswith('- [x]'):
                    # Basic extraction of finding name
                    finding = line[5:].strip()
                    if finding:
                        # For now, we simulate or try to find in DB
                        # In a real scenario, we might have mapping or manual tagging
                        res = calc.calculate('Medium', 'Medium', 'Adjacent', 'Unchanged', 'Thousands', True, 'POC', 'Not Required') 
                        results.append({
                            'finding': finding,
                            'score': res['score'],
                            'severity': res['severity'],
                            'color': res['color']
                        })
        
        if args.output == 'markdown':
            print("# Security Scorecard\n")
            print("| Finding | Score | Severity |")
            print("| :--- | :---: | :--- |")
            for res in results:
                print(f"| {res['finding']} | {res['score']} | {res['color']} {res['severity']} |")
        
        elif args.output == 'html':
            if not HAS_JINJA:
                print("❌ HTML output requires jinja2. Please install it: pip install jinja2")
                return
            env = Environment(loader=FileSystemLoader('scorecard/templates'))
            template = env.get_template('report.html.jinja')
            html_output = template.render(results=results, project_name="Audit Scorecard")
            with open('scorecard_report.html', 'w', encoding='utf-8') as f:
                f.write(html_output)
            print("✅ Report generated: scorecard_report.html")

if __name__ == "__main__":
    main()
