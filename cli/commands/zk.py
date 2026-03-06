"""
cli/commands/zk.py — zk-Intent Verification Audit Workflow
Document & score zero-knowledge intent verification risks trên Sui.
"""
import os
import sys
import json

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from scorecard.core.calculator import BVSSCalculator

# ── zk-Intent Attack Vectors ─────────────────────────────────────────────────
ZK_VECTORS = [
    {
        "id": "ZK-001",
        "name": "Intent Replay Attack",
        "description": (
            "Nullifier không được check trên chain. "
            "Cùng một zk-intent proof được chấp nhận nhiều lần, "
            "dẫn đến double-execution của action."
        ),
        "impact": "High",
        "likelihood": "High",
        "maturity": "Active",
        "vuln_db": "zk_intent_replay",
        "spec": "zk_nullifier_uniqueness.move",
        "fix": (
            "Dùng nullifier registry (Table<vector<u8>, bool>) trên chain. "
            "assert!(!table::contains(&registry, nullifier), E_DOUBLE_SPEND)."
        ),
    },
    {
        "id": "ZK-002",
        "name": "Pre-image Leak via Intent Hash",
        "description": (
            "Intent hash được tính từ plaintext parameters mà không salted. "
            "Adversary có thể brute-force intent content từ on-chain hash."
        ),
        "impact": "Medium",
        "likelihood": "Medium",
        "maturity": "POC",
        "vuln_db": None,
        "spec": "zk_intent_verify.move",
        "fix": "Hash(intent_params || randomness) với randomness được chọn off-chain.",
    },
    {
        "id": "ZK-003",
        "name": "Missing Commitment Before Action",
        "description": (
            "Action được execute mà không verify rằng intent hash đã được commit trước. "
            "Attacker có thể inject intent sau deployment."
        ),
        "impact": "Critical",
        "likelihood": "Medium",
        "maturity": "POC",
        "vuln_db": "zk_intent_replay",
        "spec": "zk_intent_verify.move",
        "fix": (
            "Commit(intent_hash) phải xảy ra trong tx N. "
            "Execute chỉ valid trong tx N+1 trở đi. "
            "assert!(intent_committed, E_NOT_COMMITTED)."
        ),
    },
    {
        "id": "ZK-004",
        "name": "Proof Malleability",
        "description": (
            "zk-SNARK proof có thể bị mutate mà vẫn verify thành công. "
            "Adversary submit mutated proof cho cùng intent → bypass uniqueness check."
        ),
        "impact": "High",
        "likelihood": "Low",
        "maturity": "Theoretical",
        "vuln_db": None,
        "spec": None,
        "fix": "Dùng Groth16 với canonical serialization. Hash proof trước khi store trong nullifier.",
    },
    {
        "id": "ZK-005",
        "name": "Verifying Key Substitution",
        "description": (
            "On-chain verifying key có thể bị thay thế nếu upgrade authority không được lock. "
            "Attacker tạo malicious circuit, generate valid proof cho arbitrary intents."
        ),
        "impact": "Critical",
        "likelihood": "Low",
        "maturity": "Theoretical",
        "vuln_db": "zk_intent_replay",
        "spec": "zk_intent_verify.move",
        "fix": "Freeze verifying key object sau deploy. Hoặc dùng immutable shared object.",
    },
]

ZK_SPECS = {
    "zk_intent_verify.move": (
        "prover-examples/sources/zk_intent_verify.move"
    ),
    "zk_nullifier_uniqueness.move": (
        "prover-examples/sources/zk_nullifier_uniqueness.move"
    ),
}

# ── Python Circuit Commitment Stub ────────────────────────────────────────────
COMMITMENT_STUB = '''
# zk-Intent Commitment Interface (Python Stub)
# Đây là mô tả interface — không implement circuit thực tế.
# Implement thực tế dùng: circom + snarkjs hoặc Arkworks (Rust).

import hashlib
import secrets

def commit_intent(action: str, params: dict, randomness: bytes = None) -> dict:
    """
    Tạo intent commitment:
    - commitment = Hash(action || params_json || randomness)
    - randomness là 32-byte secret chọn off-chain
    """
    if randomness is None:
        randomness = secrets.token_bytes(32)
    import json as _json
    pre_image = f"{action}:{_json.dumps(params, sort_keys=True)}".encode() + randomness
    commitment_hash = hashlib.sha3_256(pre_image).hexdigest()
    # Nullifier = Hash(commitment_hash || "nullifier")
    nullifier = hashlib.sha3_256((commitment_hash + ":nullifier").encode()).hexdigest()
    return {
        "commitment_hash": commitment_hash,
        "nullifier": nullifier,
        "randomness": randomness.hex(),
        "pre_image_warning": "randomness MUST be kept secret off-chain",
    }

def verify_commitment(intent_hash: str, commitment_hash: str) -> bool:
    """Verify intent_hash khớp commitment. Trong thực tế = zk-proof verification."""
    return intent_hash == commitment_hash
'''


def _score_vectors() -> list:
    calc = BVSSCalculator(os.path.join(ROOT, "scorecard", "scorecard_config.json"))
    scored = []
    for v in ZK_VECTORS:
        exploitability = "Network" if v["impact"] in ["Critical", "High"] else "Adjacent"
        scope = "Changed" if v["impact"] == "Critical" else "Unchanged"
        economic_loss = (
            "Billions" if v["impact"] == "Critical"
            else "Millions" if v["impact"] == "High"
            else "Thousands"
        )
        r = calc.calculate(
            v["impact"], v["likelihood"], exploitability, scope,
            economic_loss, True, v["maturity"], "Not Required"
        )
        scored.append({**v, "score": r["score"], "color": r["color"], "severity": r["severity"]})
    scored.sort(key=lambda x: x["score"], reverse=True)
    return scored


def run_zk(args):
    action = args.zk_action

    if action == "verify-intent":
        module = getattr(args, "module", None)
        output_fmt = getattr(args, "output", "markdown")
        scored = _score_vectors()

        if output_fmt == "json":
            out = {
                "zk_intent_audit": {
                    "module": module or "all",
                    "vectors": scored,
                    "specs": list(ZK_SPECS.keys()),
                    "commitment_stub": COMMITMENT_STUB,
                }
            }
            print(json.dumps(out, indent=2))
            return

        print("# 🔏 zk-Intent Verification Audit\n")
        if module:
            print(f"**Target Module**: `{module}`\n")
        print("## Attack Vectors\n")
        print("| ID | Vector | Severity | Score | Key Fix |")
        print("| :--- | :--- | :---: | :---: | :--- |")
        for v in scored:
            print(f"| `{v['id']}` | {v['name']} | {v['color']} {v['severity']} | **{v['score']}** | {v['fix'][:60]}... |")
        crit = sum(1 for v in scored if v["severity"] == "Critical")
        high = sum(1 for v in scored if v["severity"] == "High")
        print(f"\n**Critical**: {crit} | **High**: {high}")
        print("\n## 🔬 Move Prover Specs\n")
        for spec, path in ZK_SPECS.items():
            full_path = os.path.join(ROOT, path)
            exists = "✅" if os.path.exists(full_path) else "❌"
            print(f"- {exists} `{spec}` → `{path}`")
        print("\n## 🐍 Python Commitment Stub\n")
        print("```python" + COMMITMENT_STUB + "```")
        print("\n## 💡 Recommended Action\n")
        print("```bash")
        print("python -m cli prove --module zk_intent_verify --link-vulns")
        print("python -m cli prove --module zk_nullifier_uniqueness --link-vulns")
        print("```")

    elif action == "nullifier-check":
        print("# 🔏 Nullifier Uniqueness Check\n")
        scored = _score_vectors()
        nullifier_vulns = [v for v in scored if "nullifier" in v.get("spec", "").lower() or "ZK-001" in v["id"]]
        for v in nullifier_vulns:
            print(f"## {v['id']}: {v['name']}")
            print(f"- **Severity**: {v['color']} {v['severity']} ({v['score']}/10)")
            print(f"- **Description**: {v['description']}")
            print(f"- **Fix**: {v['fix']}")
            if v.get("spec"):
                print(f"- **Spec**: `prover-examples/sources/{v['spec']}`")
            print()
        print("### Commitment Interface\n")
        print("```python" + COMMITMENT_STUB + "```")

    elif action == "vectors":
        scored = _score_vectors()
        print("# 🔏 zk-Intent Attack Vectors\n")
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
        print("# 🔬 zk-Intent Move Prover Specs\n")
        for spec, path in ZK_SPECS.items():
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
