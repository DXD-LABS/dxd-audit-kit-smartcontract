"""
cli/core/report_engine.py — Auto-Report Generation Pipeline
Load vulns → BVSS score → prover hints → Jinja2 render → MD/HTML
"""
import os
import json
from datetime import datetime
from typing import Optional

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))


def _load_vulns(vuln_dir: str) -> list:
    """Load all YAML files from vuln-db/vulns/."""
    try:
        import yaml
    except ImportError:
        raise RuntimeError("pyyaml required: pip install pyyaml")

    vulns = []
    if not os.path.isdir(vuln_dir):
        return vulns
    for fname in sorted(os.listdir(vuln_dir)):
        if not fname.endswith(".yaml"):
            continue
        vuln_id = fname[:-5]
        fpath = os.path.join(vuln_dir, fname)
        with open(fpath, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
        if isinstance(data, dict):
            data["id"] = vuln_id
            vulns.append(data)
    return vulns


def _score_vuln(calc, vuln_data: dict) -> dict:
    impact_raw = str(vuln_data.get("severity", vuln_data.get("impact", "Medium")))
    impact = "Medium"
    for key in ["Critical", "High", "Medium", "Low"]:
        if key in impact_raw:
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
    r = calc.calculate(impact, likelihood, exploitability, scope, economic_loss, True, "POC", "Not Required")
    return {
        "impact": impact,
        "likelihood": likelihood,
        "score": r["score"],
        "severity": r["severity"],
        "color": r["color"],
    }


def _get_prover_status(prover_path: str) -> dict:
    """Attempt to load prover results — graceful if sui not installed."""
    try:
        from cli.core.prover_runner import ProverRunner
        runner = ProverRunner(prover_path)
        results = runner.prove_all()
        return {r["module"]: r for r in results}
    except Exception:
        return {}


def generate_report_data(
    project_name: str,
    vuln_dir: str,
    prover_path: str,
    run_prover: bool = True,
) -> dict:
    """Build complete report data dictionary."""
    from scorecard.core.calculator import BVSSCalculator
    calc = BVSSCalculator(os.path.join(ROOT, "scorecard", "scorecard_config.json"))

    vulns = _load_vulns(vuln_dir)
    prover_results = _get_prover_status(prover_path) if run_prover else {}

    findings = []
    for vuln in vulns:
        scored = _score_vuln(calc, vuln)
        vuln_id = vuln.get("id", "unknown")
        prover_status = prover_results.get(vuln_id, {}).get("status", "NOT_RUN")
        prover_hints = prover_results.get(vuln_id, {}).get("hints", [])
        findings.append({
            "id": vuln_id,
            "name": vuln.get("name", vuln_id),
            "date": str(vuln.get("date", "N/A")),
            "loss": vuln.get("loss", "N/A"),
            "description": vuln.get("description", ""),
            "impact_text": vuln.get("impact", ""),
            "severity": scored["severity"],
            "score": scored["score"],
            "color": scored["color"],
            "code_vuln": vuln.get("code_vuln", ""),
            "code_fixed": vuln.get("code_fixed", ""),
            "references": vuln.get("references", []),
            "prover_status": prover_status,
            "prover_hints": prover_hints,
        })

    # Sort by score descending
    findings.sort(key=lambda x: x["score"], reverse=True)

    total = len(findings)
    critical = [f for f in findings if f["severity"] == "Critical"]
    high = [f for f in findings if f["severity"] == "High"]
    medium = [f for f in findings if f["severity"] == "Medium"]
    low = [f for f in findings if f["severity"] in ("Low", "Informational")]

    return {
        "project_name": project_name,
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M"),
        "total": total,
        "critical_count": len(critical),
        "high_count": len(high),
        "medium_count": len(medium),
        "low_count": len(low),
        "avg_score": round(sum(f["score"] for f in findings) / total, 1) if total else 0,
        "findings": findings,
    }


def render_markdown(data: dict, template_path: str = None) -> str:
    """Render report as Markdown. Falls back to built-in template if Jinja2 unavailable."""
    if template_path and os.path.exists(template_path):
        try:
            from jinja2 import Environment, FileSystemLoader
            env = Environment(
                loader=FileSystemLoader(os.path.dirname(template_path)),
                trim_blocks=True,
                lstrip_blocks=True,
            )
            tmpl = env.get_template(os.path.basename(template_path))
            return tmpl.render(**data)
        except ImportError:
            pass

    # Built-in fallback Markdown template
    lines = [
        f"# {data['project_name']} — Security Audit Report",
        f"> Generated by DXD Labs Audit Kit • {data['generated_at']}",
        "",
        "## Executive Summary",
        "",
        f"| Metric | Value |",
        f"| :--- | :--- |",
        f"| Total Findings | {data['total']} |",
        f"| 🔴 Critical | {data['critical_count']} |",
        f"| 🟠 High | {data['high_count']} |",
        f"| 🟡 Medium | {data['medium_count']} |",
        f"| 🟢 Low/Info | {data['low_count']} |",
        f"| Avg BVSS Score | {data['avg_score']}/10 |",
        "",
        "---",
        "",
        "## Scorecard",
        "",
        "| # | Finding | Severity | Score | Prover |",
        "| :--- | :--- | :---: | :---: | :---: |",
    ]
    for i, f in enumerate(data["findings"], 1):
        prover_icon = {"PASS": "✅", "FAIL": "❌", "ERROR": "⚠️", "UNAVAILABLE": "⏳", "NOT_RUN": "—"}.get(f["prover_status"], "—")
        lines.append(
            f"| {i} | [`{f['id']}`] {f['name']} | {f['color']} {f['severity']} | **{f['score']}** | {prover_icon} |"
        )
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## Finding Details")

    for f in data["findings"]:
        lines += [
            "",
            f"### [{f['id']}] {f['name']}",
            "",
            f"| Field | Value |",
            f"| :--- | :--- |",
            f"| **Severity** | {f['color']} {f['severity']} |",
            f"| **BVSS Score** | {f['score']}/10 |",
            f"| **Date** | {f['date']} |",
            f"| **Loss** | {f['loss']} |",
            f"| **Impact** | {f['impact_text']} |",
            "",
            f"**Description**: {f['description'].strip()}",
            "",
        ]
        if f["code_vuln"]:
            lines.append("**Vulnerable Code:**")
            lines.append(f"```move\n{f['code_vuln'].strip()}\n```")
            lines.append("")
        if f["code_fixed"]:
            lines.append("**Fixed Code:**")
            lines.append(f"```move\n{f['code_fixed'].strip()}\n```")
            lines.append("")
        if f["references"]:
            lines.append("**References:**")
            for ref in f["references"]:
                lines.append(f"- {ref}")
            lines.append("")
        if f["prover_status"] != "NOT_RUN":
            prover_icon = {"PASS": "✅", "FAIL": "❌", "ERROR": "⚠️", "UNAVAILABLE": "⏳"}.get(f["prover_status"], "—")
            lines.append(f"**Prover Status**: {prover_icon} {f['prover_status']}")
            for hint in f.get("prover_hints", []):
                lines.append(f"  - {hint}")
            lines.append("")
        lines.append("---")

    return "\n".join(lines)


def render_html(data: dict, template_path: str = None) -> str:
    """Render report as HTML using Jinja2 template."""
    if template_path and os.path.exists(template_path):
        try:
            from jinja2 import Environment, FileSystemLoader
            env = Environment(
                loader=FileSystemLoader(os.path.dirname(template_path)),
                trim_blocks=True,
                lstrip_blocks=True,
            )
            tmpl = env.get_template(os.path.basename(template_path))
            return tmpl.render(**data)
        except ImportError:
            pass

    # Built-in HTML fallback is below (inline for no-dependency mode)
    SEV_COLORS = {
        "Critical": "#ff4757",
        "High": "#ff6348",
        "Medium": "#ffa502",
        "Low": "#2ed573",
        "Informational": "#1e90ff",
    }
    prover_icons = {"PASS": "✅", "FAIL": "❌", "ERROR": "⚠️", "UNAVAILABLE": "⏳", "NOT_RUN": "—"}

    rows = ""
    for i, f in enumerate(data["findings"], 1):
        color = SEV_COLORS.get(f["severity"], "#ccc")
        pi = prover_icons.get(f["prover_status"], "—")
        rows += f"""
        <tr>
          <td>{i}</td>
          <td><code>{f['id']}</code><br><small>{f['name']}</small></td>
          <td><span class="badge" style="background:{color}">{f['severity']}</span></td>
          <td><strong>{f['score']}</strong>/10</td>
          <td>{f['date']}</td>
          <td>{f['loss']}</td>
          <td>{pi} {f['prover_status']}</td>
        </tr>"""

    details = ""
    for f in data["findings"]:
        color = SEV_COLORS.get(f["severity"], "#ccc")
        vuln_code = f"<pre><code class='move'>{f['code_vuln'].strip()}</code></pre>" if f["code_vuln"] else ""
        fixed_code = f"<pre><code class='move'>{f['code_fixed'].strip()}</code></pre>" if f["code_fixed"] else ""
        refs = "".join(f"<li><a href='{r}' target='_blank'>{r}</a></li>" for r in f.get("references", []))
        hints_html = "".join(f"<li>{h}</li>" for h in f.get("prover_hints", []))
        prover_html = f"<p><strong>Prover</strong>: {prover_icons.get(f['prover_status'], '—')} {f['prover_status']}</p><ul>{hints_html}</ul>" if f["prover_status"] != "NOT_RUN" else ""
        details += f"""
        <div class="finding" id="{f['id']}">
          <h3><span class="badge" style="background:{color}">{f['severity']}</span>
              [{f['id']}] {f['name']}
              <span class="score">{f['score']}/10</span></h3>
          <p><em>{f['description'].strip()}</em></p>
          {"<h4>Vulnerable Code</h4>" + vuln_code if vuln_code else ""}
          {"<h4>Fixed Code</h4>" + fixed_code if fixed_code else ""}
          {"<h4>References</h4><ul>" + refs + "</ul>" if refs else ""}
          {prover_html}
        </div>"""

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{data['project_name']} — Audit Report | DXD Labs</title>
  <style>
    :root {{--bg:#0d1117;--bg2:#161b22;--border:#30363d;--text:#e6edf3;--muted:#8b949e;--accent:#58a6ff;}}
    *{{box-sizing:border-box;margin:0;padding:0}}
    body{{font-family:'Segoe UI',system-ui,sans-serif;background:var(--bg);color:var(--text);padding:2rem;}}
    h1{{font-size:2rem;color:var(--accent);border-bottom:2px solid var(--border);padding-bottom:.5rem;margin-bottom:1.5rem}}
    h2{{color:var(--accent);margin:2rem 0 1rem;font-size:1.4rem;}}
    h3{{margin:1rem 0 .5rem;font-size:1.1rem;}}
    h4{{color:var(--muted);margin:.75rem 0 .25rem;font-size:.9rem;}}
    .meta{{color:var(--muted);font-size:.85rem;margin-bottom:2rem;}}
    .summary-grid{{display:grid;grid-template-columns:repeat(auto-fit,minmax(120px,1fr));gap:1rem;margin:1rem 0 2rem;}}
    .stat{{background:var(--bg2);border:1px solid var(--border);border-radius:8px;padding:1rem;text-align:center;}}
    .stat .num{{font-size:2rem;font-weight:700;color:var(--accent);}}
    .stat .label{{font-size:.75rem;color:var(--muted);margin-top:.25rem;}}
    table{{width:100%;border-collapse:collapse;margin:1rem 0;font-size:.9rem;}}
    th{{background:var(--bg2);color:var(--muted);padding:.6rem .8rem;text-align:left;border-bottom:1px solid var(--border);}}
    td{{padding:.6rem .8rem;border-bottom:1px solid var(--border);vertical-align:top;}}
    tr:hover td{{background:var(--bg2);}}
    .badge{{display:inline-block;padding:.2rem .5rem;border-radius:4px;color:#fff;font-size:.75rem;font-weight:700;}}
    .score{{float:right;font-size:.85rem;color:var(--muted);}}
    .finding{{background:var(--bg2);border:1px solid var(--border);border-radius:8px;padding:1.5rem;margin:1rem 0;}}
    pre{{background:#161b22;border:1px solid var(--border);border-radius:6px;padding:1rem;overflow-x:auto;margin:.5rem 0;}}
    code{{font-family:'Cascadia Code','Fira Code',monospace;font-size:.82rem;}}
    a{{color:var(--accent);}}
    .footer{{margin-top:3rem;padding-top:1rem;border-top:1px solid var(--border);color:var(--muted);font-size:.8rem;text-align:center;}}
  </style>
</head>
<body>
  <h1>🔒 {data['project_name']} — Security Audit Report</h1>
  <p class="meta">Generated by <strong>DXD Labs Audit Kit</strong> · {data['generated_at']}</p>

  <div class="summary-grid">
    <div class="stat"><div class="num">{data['total']}</div><div class="label">Total Findings</div></div>
    <div class="stat"><div class="num" style="color:#ff4757">{data['critical_count']}</div><div class="label">Critical</div></div>
    <div class="stat"><div class="num" style="color:#ff6348">{data['high_count']}</div><div class="label">High</div></div>
    <div class="stat"><div class="num" style="color:#ffa502">{data['medium_count']}</div><div class="label">Medium</div></div>
    <div class="stat"><div class="num" style="color:#2ed573">{data['low_count']}</div><div class="label">Low / Info</div></div>
    <div class="stat"><div class="num">{data['avg_score']}</div><div class="label">Avg BVSS /10</div></div>
  </div>

  <h2>📊 Scorecard</h2>
  <table>
    <thead><tr><th>#</th><th>Finding</th><th>Severity</th><th>Score</th><th>Date</th><th>Loss</th><th>Prover</th></tr></thead>
    <tbody>{rows}</tbody>
  </table>

  <h2>🔍 Finding Details</h2>
  {details}

  <div class="footer">DXD Labs Smart Contract Audit Kit · dxdlabs.io</div>
</body>
</html>"""
