"""
cli/commands/tee.py — Nautilus TEE Attestation Audit Workflow
Document & score Trusted Execution Environment risks trên Sui / Nautilus.
"""
import os
import sys
import json

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from scorecard.core.calculator import BVSSCalculator

# ── TEE Attack Vectors Database ─────────────────────────────────────────────
TEE_VECTORS = [
    {
        "id": "TEE-001",
        "name": "Fabricated Attestation Quote",
        "description": "Attacker forges TEE attestation quote, bypassing on-chain verification gate.",
        "impact": "Critical",
        "likelihood": "Medium",
        "maturity": "Theoretical",
        "vuln_db": "nautilus_tee_bypass",
        "spec": "nautilus_tee_attest.move",
        "fix": "Verify MRENCLAVE + MRSIGNER + report_data against committed values on-chain.",
    },
    {
        "id": "TEE-002",
        "name": "Stale Attestation Replay",
        "description": "Old attestation quote replayed. TEE may have been patched since quote was issued.",
        "impact": "High",
        "likelihood": "Medium",
        "maturity": "POC",
        "vuln_db": "nautilus_tee_bypass",
        "spec": "nautilus_tee_attest.move",
        "fix": "Enforce attestation timestamp freshness window (max 1 epoch).",
    },
    {
        "id": "TEE-003",
        "name": "Computation Output Tampering",
        "description": "TEE computation result tampered after execution but before on-chain submission.",
        "impact": "Critical",
        "likelihood": "Low",
        "maturity": "Theoretical",
        "vuln_db": "nautilus_tee_bypass",
        "spec": "nautilus_computation_integrity.move",
        "fix": "Hash computation output inside TEE, include in attestation report_data field.",
    },
    {
        "id": "TEE-004",
        "name": "Side-Channel via Shared Memory",
        "description": "Memory side-channel leaks sensitive data between concurrent TEE sessions.",
        "impact": "High",
        "likelihood": "Low",
        "maturity": "Theoretical",
        "vuln_db": None,
        "spec": None,
        "fix": "Use dedicated TEE instance per session, zero shared memory buffers.",
    },
    {
        "id": "TEE-005",
        "name": "Missing On-Chain Attestation Gate",
        "description": "Smart contract accepts computation result without verifying TEE attestation at all.",
        "impact": "Critical",
        "likelihood": "High",
        "maturity": "Active",
        "vuln_db": "nautilus_tee_bypass",
        "spec": "nautilus_tee_attest.move",
        "fix": "Add `assert!(verify_attestation(report_hash, committed_hash), E_ATTESTATION_FAIL)`.",
    },
]

TEE_SPECS = {
    "nautilus_tee_attest.move": (
        "prover-examples/sources/nautilus_tee_attest.move"
    ),
    "nautilus_computation_integrity.move": (
        "prover-examples/sources/nautilus_computation_integrity.move"
    ),
}


def _score_vectors() -> list:
    calc = BVSSCalculator(os.path.join(ROOT, "scorecard", "scorecard_config.json"))
    scored = []
    for v in TEE_VECTORS:
        exploitability = "Network" if v["impact"] in ["Critical", "High"] else "Adjacent"
        scope = "Changed" if v["impact"] == "Critical" else "Unchanged"
        economic_loss = "Billions" if v["impact"] == "Critical" else "Millions" if v["impact"] == "High" else "Thousands"
        r = calc.calculate(
            v["impact"], v["likelihood"], exploitability, scope,
            economic_loss, True, v["maturity"], "Not Required"
        )
        scored.append({**v, "score": r["score"], "color": r["color"], "severity": r["severity"]})
    scored.sort(key=lambda x: x["score"], reverse=True)
    return scored


def run_tee(args):
    action = args.tee_action

    if action == "attest":
        module = getattr(args, "module", None)
        output_fmt = getattr(args, "output", "markdown")
        scored = _score_vectors()

        if output_fmt == "json":
            out = {
                "tee_audit": {
                    "module": module or "all",
                    "vectors": scored,
                    "specs": list(TEE_SPECS.keys()),
                }
            }
            print(json.dumps(out, indent=2))
            return

        print("# 🔐 Nautilus TEE Attestation Audit\n")
        if module:
            print(f"**Target Module**: `{module}`\n")
        print("## TEE Risk Vectors\n")
        print("| ID | Vector | Severity | Score | Fix |")
        print("| :--- | :--- | :---: | :---: | :--- |")
        for v in scored:
            print(f"| `{v['id']}` | {v['name']} | {v['color']} {v['severity']} | **{v['score']}** | {v['fix'][:60]}... |")
        print()
        crit = sum(1 for v in scored if v["severity"] == "Critical")
        high = sum(1 for v in scored if v["severity"] == "High")
        print(f"**Critical**: {crit} | **High**: {high}")
        print("\n## 🔬 Formal Specs\n")
        for spec, path in TEE_SPECS.items():
            full_path = os.path.join(ROOT, path)
            exists = "✅" if os.path.exists(full_path) else "❌"
            print(f"- {exists} `{spec}` → `{path}`")
        print("\n## 💡 Recommended Action\n")
        print("```bash")
        print("# Run Move Prover trên TEE specs")
        print("python -m cli prove --module nautilus_tee_attest --link-vulns")
        print("python -m cli prove --module nautilus_computation_integrity --link-vulns")
        print("```")

    elif action == "vectors":
        scored = _score_vectors()
        print("# 🔐 TEE Attack Vectors\n")
        for v in scored:
            print(f"## {v['id']}: {v['name']}")
            print(f"- **Severity**: {v['color']} {v['severity']} ({v['score']}/10)")
            print(f"- **Impact**: {v['impact']} | **Maturity**: {v['maturity']}")
            print(f"- **Description**: {v['description']}")
            print(f"- **Fix**: {v['fix']}")
            if v.get("vuln_db"):
                print(f"- **Vuln-DB**: `{v['vuln_db']}`")
            if v.get("spec"):
                print(f"- **Prover Spec**: `{v['spec']}`")
            print()

    elif action == "specs":
        print("# 🔬 TEE Move Prover Specs\n")
        for spec, path in TEE_SPECS.items():
            full_path = os.path.join(ROOT, path)
            print(f"## `{spec}`")
            print(f"- **Path**: `{path}`")
            if os.path.exists(full_path):
                with open(full_path, "r", encoding="utf-8") as f:
                    content = f.read()
                print(f"```move\n{content}\n```")
            else:
                print("❌ File chưa tồn tại")
            print()
