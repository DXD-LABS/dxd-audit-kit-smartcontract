#!/usr/bin/env python3
"""
generate-report-template.py - Auto-fill audit report template from findings
Usage:
  python generate-report-template.py --template templates/report-template.en.md --output report-output.md
"""

import argparse
import json
import os
from datetime import datetime

def load_template(template_path):
    if not os.path.exists(template_path):
        raise FileNotFoundError(f"Template not found: {template_path}")
    with open(template_path, 'r', encoding='utf-8') as f:
        return f.read()

def get_findings():
    """Interactive input findings (có thể mở rộng thành đọc JSON sau)"""
    findings = []
    print("Nhập findings (nhấn Enter 2 lần để kết thúc):")
    while True:
        issue_id = input("Issue ID (ví dụ: HIGH-01, để trống để dừng): ").strip()
        if not issue_id:
            break
        severity = input("Severity (High/Medium/Low/Informational): ").strip()
        location = input("Location (File:line): ").strip()
        description = input("Description: ").strip()
        impact = input("Impact: ").strip()
        recommendation = input("Recommendation: ").strip()
        reference = input("Reference (snippet link): ").strip()
        status = input("Status (Open/Fixed): ").strip() or "Open"

        findings.append({
            "id": issue_id,
            "severity": severity,
            "location": location,
            "description": description,
            "impact": impact,
            "recommendation": recommendation,
            "reference": reference,
            "status": status
        })

    return findings

def count_severity(findings):
    counts = {"High": 0, "Medium": 0, "Low": 0, "Informational": 0}
    for f in findings:
        counts[f["severity"]] += 1
    return counts

def generate_report(template, findings, project_name="MiniLend", date=None):
    if date is None:
        date = datetime.now().strftime("%d/%m/%Y")

    # Thống kê severity
    counts = count_severity(findings)
    summary = f"- High: {counts['High']}\n- Medium: {counts['Medium']}\n- Low: {counts['Low']}\n- Informational: {counts['Informational']}"

    # Executive Summary (tự động)
    total_findings = len(findings)
    exec_summary = f"Tổng {total_findings} findings: {counts['High']} High, {counts['Medium']} Medium. Protocol an toàn nếu fix High."

    # Detailed Findings
    detailed = ""
    for f in findings:
        detailed += f"""
**Issue ID**: {f['id']}  
**Severity**: {f['severity']}  
**Location**: {f['location']}  
**Description**: {f['description']}  
**Impact**: {f['impact']}  
**Recommendation**: {f['recommendation']}  
**Reference**: {f['reference']}  
**Status**: {f['status']}

"""

    # Thay thế placeholders trong template
    report = template.replace("[Project Name]", project_name)
    report = report.replace("[Date]", date)
    report = report.replace("[Executive Summary]", exec_summary)
    report = report.replace("[Findings Summary]", summary)
    report = report.replace("[Detailed Findings]", detailed)

    return report

def main():
    parser = argparse.ArgumentParser(description="Auto-fill audit report template from findings")
    parser.add_argument("--template", required=True, help="Path to template file")
    parser.add_argument("--output", default="audit-report-output.md", help="Output report file")
    parser.add_argument("--project", default="MiniLend", help="Project name")
    args = parser.parse_args()

    try:
        template = load_template(args.template)
        findings = get_findings()  # Interactive input
        report_content = generate_report(template, findings, args.project)

        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(report_content)

        print(f"Report generated successfully: {args.output}")
        print(f"Total findings: {len(findings)}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
