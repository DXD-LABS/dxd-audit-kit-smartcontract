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
    parser.add_argument('--export-web', action='store_true', help='Export vuln-db to JSON for Web tool')
    parser.add_argument('--output', choices=['markdown', 'html', 'json'], default='markdown', help='Output format')
    
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
            
        # Overrides
        if args.impact: impact = args.impact
        if args.likelihood: likelihood = args.likelihood
            
        result = calc.calculate(impact, likelihood, exploit_maturity=args.maturity)
        print(f"\n# Results for {args.vuln_id}")
        print(f"- Impact: {impact}")
        print(f"- Likelihood: {likelihood}")
        print(f"- Score: {result['score']}/10")
        print(f"- Severity: {result['color']} {result['severity']}")
        return

    # 3. Handle Checklist Parsing (Simple version)
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
                        res = calc.calculate('Medium', 'Medium') 
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
