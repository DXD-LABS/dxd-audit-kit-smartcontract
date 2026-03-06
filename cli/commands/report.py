"""
cli/commands/report.py — Auto-Report Generation Command
Full pipeline: vuln-db → BVSS score → prover hints → Markdown/HTML render
"""
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from cli.core.report_engine import generate_report_data, render_markdown, render_html


def run_report(args):
    project = args.project
    output_fmt = getattr(args, "output", "both")
    vuln_dir = getattr(args, "vuln_db", "vuln-db/vulns")
    prover_path = getattr(args, "prover_path", "prover-examples")
    no_prover = getattr(args, "no_prover", False)
    client_dir = getattr(args, "client_dir", None)

    # Resolve relative paths from project root
    if not os.path.isabs(vuln_dir):
        vuln_dir = os.path.join(ROOT, vuln_dir)
    if not os.path.isabs(prover_path):
        prover_path = os.path.join(ROOT, prover_path)

    # Template paths
    md_template = os.path.join(ROOT, "scorecard", "templates", "audit_report.md.jinja")
    html_template = os.path.join(ROOT, "scorecard", "templates", "audit_report.html.jinja")

    print(f"⚙️  Generating report for: {project}")
    print(f"   📁 Vuln-DB : {vuln_dir}")
    print(f"   🔬 Prover  : {'disabled' if no_prover else prover_path}")
    print()

    # 1. Generate report data
    data = generate_report_data(
        project_name=project,
        vuln_dir=vuln_dir,
        prover_path=prover_path,
        run_prover=not no_prover,
    )

    print(f"✅ Loaded {data['total']} findings")
    print(f"   🔴 Critical: {data['critical_count']}")
    print(f"   🟠 High    : {data['high_count']}")
    print(f"   🟡 Medium  : {data['medium_count']}")
    print(f"   🟢 Low/Info: {data['low_count']}")
    print(f"   📊 Avg BVSS: {data['avg_score']}/10")
    print()

    # 2. Determine output directory
    out_dir = ROOT
    if client_dir:
        if not os.path.isabs(client_dir):
            client_dir = os.path.join(ROOT, client_dir)
        out_dir = client_dir

    # 3. Render and write Markdown
    if output_fmt in ("markdown", "both"):
        md_content = render_markdown(data, md_template if os.path.exists(md_template) else None)
        md_path = os.path.join(out_dir, f"{project}_audit_report.md")
        with open(md_path, "w", encoding="utf-8") as f:
            f.write(md_content)
        print(f"📄 Markdown report → {md_path}")

    # 4. Render and write HTML
    if output_fmt in ("html", "both"):
        html_content = render_html(data, html_template if os.path.exists(html_template) else None)
        html_path = os.path.join(out_dir, f"{project}_audit_report.html")
        with open(html_path, "w", encoding="utf-8") as f:
            f.write(html_content)
        print(f"🌐 HTML report    → {html_path}")

    print()
    print("✅ Report generation complete!")
    print()
    print("💡 Next steps:")
    print("   python -m cli prove --link-vulns     # Run prover on all specs")
    print("   python -m cli tee attest             # Audit TEE patterns")
    print("   python -m cli zk verify-intent       # Audit zk-intent patterns")
