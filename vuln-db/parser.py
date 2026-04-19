# Registry Parser: Generates security summaries and JSON registry from YAML vulnerabilities.
# Supports BVSS scoring and formal verification (Move Prover) linkage.
import os
import re
import sys
import json
from glob import glob
import yaml

# Inject ROOT into sys.path to find scorecard
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from scorecard.core.calculator import BVSSCalculator

REQUIRED_FIELDS = [
    "id",
    "name",
    "date",
    "loss",
    "description",
    "impact",
    "severity",
    "references",
    "code_vuln",
    "code_fixed",
    "test_vector",
]

SEVERITY_ORDER = {
    "Critical": 0,
    "High": 1,
    "Medium": 2,
    "Low": 3,
    "Informational": 4,
}

LANGUAGES = {
    "en": {"suffix": "", "file": "summary.md", "title": "Sui Vuln Database Summary", "score_label": "Score", "severity_label": "Severity"},
    "vi": {"suffix": "_vi", "file": "summary.vi.md", "title": "Tổng hợp Lỗ hổng Sui (Move)", "score_label": "Điểm số", "severity_label": "Mức độ"},
    "zh": {"suffix": "_zh", "file": "summary.zh.md", "title": "Sui 漏洞库摘要 (Move)", "score_label": "评分", "severity_label": "严重程度"},
}

DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


def _validate(vuln, path):
    errors = []
    for field in REQUIRED_FIELDS:
        if field not in vuln:
            errors.append(f"missing required field: {field}")
    if "date" in vuln and not DATE_RE.match(str(vuln["date"])):
        errors.append("invalid date format, expected YYYY-MM-DD")
    if "references" in vuln:
        if not isinstance(vuln["references"], list) or not vuln["references"]:
            errors.append("references must be a non-empty list")
        else:
            for ref in vuln["references"]:
                if not isinstance(ref, str) or not ref.startswith("http"):
                    errors.append("references must be a list of URLs")
                    break
    if errors:
        joined = "; ".join(errors)
        raise ValueError(f"{path}: {joined}")


def _parse_loss(loss_str):
    if not loss_str or "N/A" in str(loss_str):
        return 0
    match = re.search(r"\$?([\d.]+)\s*([MB]?)", str(loss_str), re.IGNORECASE)
    if match:
        value = float(match.group(1))
        multiplier = match.group(2).upper()
        if multiplier == "M":
            return value * 1_000_000
        if multiplier == "B":
            return value * 1_000_000_000
        return value
    return 0

def calculate_bvss_score(calc, vuln):
    """Calculate score using explicit bvss block or heuristic fallback."""
    if "bvss" in vuln:
        b = vuln["bvss"]
        return calc.calculate(
            impact=b.get("impact", vuln["severity"]),
            likelihood=b.get("likelihood", "Medium"),
            exploitability=b.get("exploitability", "Network"),
            scope=b.get("scope", "Unchanged"),
            economic_loss=b.get("economic_loss", "Millions"),
            is_immutable=b.get("is_immutable", True),
            exploit_maturity=b.get("exploit_maturity", "POC"),
            privileged_access=b.get("privileged_access", "Not Required")
        )
    
    # Fallback heuristic
    impact = vuln["severity"]
    return calc.calculate(
        impact=impact,
        likelihood="Medium",
        exploitability="Network" if impact in ["Critical", "High"] else "Adjacent",
        scope="Changed" if impact == "Critical" else "Unchanged",
        economic_loss="Millions" if impact in ["Critical", "High"] else "Thousands",
        is_immutable=True,
        exploit_maturity="POC",
        privileged_access="Not Required"
    )

def generate_summaries():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    vuln_dirs = [
        os.path.join(base_dir, "vulns"),
        os.path.join(base_dir, "move-scanner")
    ]
    
    calc = BVSSCalculator(os.path.join(ROOT, "scorecard", "scorecard_config.json"))
    
    files = []
    for d in vuln_dirs:
        if os.path.exists(d):
            files.extend(glob(os.path.join(d, "*.yaml")))
            
    if not files:
        raise RuntimeError("no YAML files found in vuln-db/vulns or vuln-db/move-scanner")

    vulns = []
    for path in files:
        with open(path, "r", encoding="utf-8") as f:
            try:
                data = yaml.safe_load(f)
            except Exception as e:
                print(f"Error parsing {path}: {e}", file=sys.stderr)
                continue
        if not isinstance(data, dict):
            continue
        try:
            _validate(data, path)
        except ValueError as e:
            print(f"Skipping {path}: {e}", file=sys.stderr)
            continue
        
        # Inject Score
        score_result = calculate_bvss_score(calc, data)
        data["bvss_score"] = score_result["score"]
        data["bvss_severity"] = score_result["severity"]
        data["bvss_color"] = score_result["color"]
        
        vulns.append(data)

    # Sort by score descending (high risk first), then by date descending
    vulns.sort(key=lambda v: (v["bvss_score"], str(v.get("date", ""))), reverse=True)

    # 1. Generate Registry Export
    registry_path = os.path.join(base_dir, "registry.json")
    with open(registry_path, "w", encoding="utf-8") as rf:
        # Convert date objects to strings for JSON
        def json_serial(obj):
            if isinstance(obj, (os.PathLike,)):
                return str(obj)
            import datetime
            if isinstance(obj, (datetime.date, datetime.datetime)):
                return obj.isoformat()
            raise TypeError(f"Type {type(obj)} not serializable")
        
        json.dump(vulns, rf, indent=2, ensure_ascii=False, default=json_serial)

    # 2. Generate Markdown Summaries
    for lang_code, cfg in LANGUAGES.items():
        suffix = cfg["suffix"]
        lines = [f"# {cfg['title']}", ""]
        
        # Summary Table
        table_hdr = f"| ID | Name | {cfg['score_label']} | {cfg['severity_label']} | Proof | Date |"
        table_sep = "| :--- | :--- | :---: | :--- | :---: | :--- |"
            
        lines.append(table_hdr)
        lines.append(table_sep)
        for vuln in vulns:
            v_id = vuln["id"]
            name = vuln.get(f"name{suffix}") or vuln["name"]
            score = vuln["bvss_score"]
            color = vuln["bvss_color"]
            sev_val = vuln["severity"]
            date = vuln["date"]
            
            # Proof link
            proof = vuln.get("formal_spec", "")
            proof_link = "✅" if proof else "⏳"
            if proof:
                proof_name = os.path.basename(proof)
                proof_link = f"[🔍 {proof_name}]({proof})"

            lines.append(f"| {v_id} | {name} | **{score}** | {color} {sev_val} | {proof_link} | {date} |")
        
        lines.append("")
        lines.append("---")
        lines.append("")
        
        # Detailed sections
        for vuln in vulns:
            v_id = vuln["id"]
            name = vuln.get(f"name{suffix}") or vuln["name"]
            description = vuln.get(f"description{suffix}") or vuln["description"]
            impact = vuln.get(f"impact{suffix}") or vuln["impact"]
            
            lines.append(f"## [{v_id}] {name}")
            lines.append(f"- Score: **{vuln['bvss_score']}/10** {vuln['bvss_color']}")
            
            proof = vuln.get("formal_spec", "")
            if proof:
                lines.append(f"- **Formal Proof**: [`{os.path.basename(proof)}`]({proof})")
            
            lines.append(f"- Date: {vuln['date']}")
            lines.append(f"- Loss: {vuln['loss']}")
            lines.append(f"- Impact: {impact}")
            
            # Root Cause
            rc_label = "Root Cause" if lang_code == "en" else "Nguyên nhân gốc rễ" if lang_code == "vi" else "根本原因"
            rc_val = vuln.get(f"root_cause{suffix}") or vuln.get("root_cause")
            if rc_val:
                lines.append(f"- **{rc_label}**: {rc_val}")
            
            # Mitigation
            mit_label = "Mitigation" if lang_code == "en" else "Giải pháp giảm thiểu" if lang_code == "vi" else "缓解措施"
            mit_val = vuln.get(f"mitigation{suffix}") or vuln.get("mitigation")
            if mit_val:
                lines.append(f"- **{mit_label}**: {mit_val}")

            # Verification
            ver_label = "Verification" if lang_code == "en" else "Xác minh" if lang_code == "vi" else "验证"
            ver_val = vuln.get(f"verification{suffix}") or vuln.get("verification")
            if ver_val:
                lines.append(f"- **{ver_label}**: {ver_val}")

            lines.append("")
            lines.append(description.strip())
            lines.append("")

        out_path = os.path.join(base_dir, cfg["file"])
        with open(out_path, "w", encoding="utf-8") as f:
            f.write("\n".join(lines).rstrip() + "\n")


if __name__ == "__main__":
    try:
        generate_summaries()
    except Exception as exc:
        print(str(exc), file=sys.stderr)
        sys.exit(1)