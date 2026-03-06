"""
cli/commands/prove.py — Move Prover Integration Command
Chạy `sui move prove` trên prover-examples hoặc bất kỳ Move project nào,
parse kết quả [PASS]/[FAIL]/error:, và optional link về vuln-db entries.
"""
import os
import sys
import json

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from cli.core.prover_runner import ProverRunner
from cli.core.vuln_linker import VulnLinker


def run_prove(args):
    module = getattr(args, "module", None)
    path = getattr(args, "path", "prover-examples")
    output_fmt = getattr(args, "output", "markdown")
    link_vulns = getattr(args, "link_vulns", False)

    if not os.path.isabs(path):
        path = os.path.join(ROOT, path)

    runner = ProverRunner(path)

    if module:
        print(f"🔍 Running Move Prover on module: {module}")
        result = runner.prove_module(module)
        results = [result]
    else:
        print(f"🔍 Running Move Prover on all specs in: {path}")
        results = runner.prove_all()

    if not results:
        print("❌ Không có prover spec nào được tìm thấy hoặc prover không chạy được.")
        print("   💡 Đảm bảo `sui` CLI đã được cài và prover-examples/ có Move.toml")
        return

    # Optional: link failures về vuln-db
    if link_vulns:
        linker = VulnLinker()
        for r in results:
            if r["status"] in ("FAIL", "ERROR"):
                linked = linker.link(r["module"])
                if linked:
                    r["vuln_db_link"] = linked

    if output_fmt == "json":
        print(json.dumps(results, indent=2))
        return

    # Markdown output
    print("\n# 🔬 DXD Labs — Move Prover Results\n")
    print("| Module | Status | Specs | Vuln-DB Link |")
    print("| :--- | :---: | :--- | :--- |")
    for r in results:
        status_icon = "✅ PASS" if r["status"] == "PASS" else "❌ FAIL" if r["status"] == "FAIL" else "⚠️ ERROR"
        specs_str = ", ".join(r.get("specs", [])) or "—"
        vuln_link = r.get("vuln_db_link", "—")
        print(f"| `{r['module']}` | {status_icon} | {specs_str[:60]} | {vuln_link} |")

    pass_count = sum(1 for r in results if r["status"] == "PASS")
    fail_count = sum(1 for r in results if r["status"] == "FAIL")
    err_count = sum(1 for r in results if r["status"] == "ERROR")
    print(f"\n**Summary**: ✅ {pass_count} PASS | ❌ {fail_count} FAIL | ⚠️ {err_count} ERROR")

    if fail_count or err_count:
        print("\n## 🔧 Failure Details\n")
        for r in results:
            if r["status"] in ("FAIL", "ERROR"):
                print(f"### `{r['module']}`")
                for hint in r.get("hints", []):
                    print(f"- {hint}")
                if r.get("vuln_db_link"):
                    print(f"- 📚 Vuln-DB: `{r['vuln_db_link']}`")
                print()
