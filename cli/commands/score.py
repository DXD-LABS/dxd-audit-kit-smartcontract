"""
cli/commands/score.py — BVSS Scoring Command
Wraps BVSSCalculator + VulnDBParser, hỗ trợ single vuln, all vulns, và lint output.
"""
import os
import sys
import json

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from scorecard.core.calculator import BVSSCalculator
from scorecard.parsers.yaml_parser import VulnDBParser


def _score_vuln(calc: BVSSCalculator, vuln_data: dict, overrides: dict) -> dict:
    """Compute BVSS score từ một vuln dict + optional overrides."""
    impact = str(vuln_data.get("severity", vuln_data.get("impact", "Medium")))
    for key in ["Critical", "High", "Medium", "Low"]:
        if key in impact:
            impact = key
            break
    likelihood = vuln_data.get("likelihood", "Medium")
    exploitability = "Network" if impact in ["Critical", "High"] else "Adjacent" if impact == "Medium" else "Local"
    scope = "Changed" if impact == "Critical" else "Unchanged"
    economic_loss = (
        "Billions" if impact == "Critical"
        else "Millions" if impact == "High"
        else "Thousands" if impact == "Medium"
        else "Negligible"
    )
    if overrides.get("impact"):
        impact = overrides["impact"]
    if overrides.get("likelihood"):
        likelihood = overrides["likelihood"]
    maturity = overrides.get("maturity", "POC")
    result = calc.calculate(impact, likelihood, exploitability, scope, economic_loss, True, maturity, "Not Required")
    return {
        "impact": impact,
        "likelihood": likelihood,
        "exploitability": exploitability,
        "scope": scope,
        "economic_loss": economic_loss,
        "maturity": maturity,
        "score": result["score"],
        "severity": result["severity"],
        "color": result["color"],
    }


def _render_markdown_table(rows: list) -> str:
    lines = ["# 🔒 DXD Labs — BVSS Security Scorecard\n"]
    lines.append("| Vuln ID | Name | Impact | Score | Severity |")
    lines.append("| :--- | :--- | :---: | :---: | :--- |")
    for row in rows:
        lines.append(
            f"| `{row['id']}` | {row['name']} | {row['impact']} | **{row['score']}** | {row['color']} {row['severity']} |"
        )
    total = len(rows)
    crit = sum(1 for r in rows if r["severity"] == "Critical")
    high = sum(1 for r in rows if r["severity"] == "High")
    avg = round(sum(r["score"] for r in rows) / total, 1) if total else 0
    lines.append(f"\n**Total**: {total} findings | **Critical**: {crit} | **High**: {high} | **Avg Score**: {avg}/10")
    return "\n".join(lines)


def run_score(args):
    calc = BVSSCalculator(os.path.join(ROOT, "scorecard", "scorecard_config.json"))
    db_parser = VulnDBParser(os.path.join(ROOT, "vuln-db", "vulns"))
    overrides = {k: getattr(args, k, None) for k in ["impact", "likelihood", "maturity"]}

    # ── Single vuln ────────────────────────────────────────────────────
    if getattr(args, "vuln_id", None):
        vuln_data = db_parser.get_vuln_data(args.vuln_id)
        if not vuln_data:
            print(f"❌ Không tìm thấy vulnerability '{args.vuln_id}' trong vuln-db")
            sys.exit(1)
        r = _score_vuln(calc, vuln_data, overrides)
        name = vuln_data.get("name", args.vuln_id)
        if getattr(args, "output", "markdown") == "json":
            print(json.dumps({"id": args.vuln_id, "name": name, **r}, indent=2))
        else:
            print(f"\n## {name} (`{args.vuln_id}`)")
            print(f"- Impact    : {r['impact']}")
            print(f"- Likelihood: {r['likelihood']}")
            print(f"- Maturity  : {r['maturity']}")
            print(f"- Score     : **{r['score']}/10**")
            print(f"- Severity  : {r['color']} {r['severity']}")
        return

    # ── All vulns ──────────────────────────────────────────────────────
    if getattr(args, "all_vulns", False):
        vuln_dir = os.path.join(ROOT, "vuln-db", "vulns")
        rows = []
        for fname in sorted(os.listdir(vuln_dir)):
            if not fname.endswith(".yaml"):
                continue
            vuln_id = fname[:-5]
            vuln_data = db_parser.get_vuln_data(vuln_id)
            if not vuln_data:
                continue
            r = _score_vuln(calc, vuln_data, overrides)
            rows.append({"id": vuln_id, "name": vuln_data.get("name", vuln_id), **r})
        rows.sort(key=lambda x: x["score"], reverse=True)
        if getattr(args, "output", "markdown") == "json":
            print(json.dumps(rows, indent=2))
        elif getattr(args, "output", "markdown") == "markdown":
            print(_render_markdown_table(rows))
        return

    # ── Lint output ────────────────────────────────────────────────────
    if getattr(args, "lint_output", None):
        if not os.path.exists(args.lint_output):
            print(f"❌ File không tồn tại: {args.lint_output}")
            sys.exit(1)
        with open(args.lint_output, "r", encoding="utf-8") as f:
            findings = json.load(f)
        sev_map = {"critical": "Critical", "high": "High", "medium": "Medium", "low": "Low", "info": "Low"}
        rows = []
        for finding in findings:
            impact = sev_map.get(finding.get("severity", "low").lower(), "Low")
            r = calc.calculate(impact, "Medium", "Network", "Unchanged", "Thousands", True, "POC", "Not Required")
            rows.append({
                "id": finding.get("name", "unknown"),
                "name": f"{finding.get('name', '')} in {finding.get('file', '')}",
                "impact": impact,
                **r,
            })
        if getattr(args, "output", "markdown") == "json":
            print(json.dumps(rows, indent=2))
        else:
            print(_render_markdown_table(rows))
        return

    print("❌ Cần ít nhất một trong: --vuln-id, --all, --lint-output")
    sys.exit(1)
