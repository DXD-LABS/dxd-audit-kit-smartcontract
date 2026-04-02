import os
import re
import sys
from glob import glob
import yaml

REQUIRED_FIELDS = [
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
    "en": {"suffix": "", "file": "summary.md", "title": "Sui Vuln Database Summary"},
    "vi": {"suffix": "_vi", "file": "summary.vi.md", "title": "Tổng hợp Lỗ hổng Sui (Move)"},
    "zh": {"suffix": "_zh", "file": "summary.zh.md", "title": "Sui 漏洞库摘要 (Move)"},
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


def _severity_key(vuln):
    severity = vuln.get("severity", "Informational")
    return SEVERITY_ORDER.get(severity, 999)


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


def generate_summaries():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    vuln_dirs = [
        os.path.join(base_dir, "vulns"),
        os.path.join(base_dir, "move-scanner")
    ]
    
    files = []
    for d in vuln_dirs:
        if os.path.exists(d):
            files.extend(glob(os.path.join(d, "*.yaml")))
            
    if not files:
        raise RuntimeError("no YAML files found in vuln-db/vulns or vuln-db/move-scanner")

    vulns = []
    for path in files:
        with open(path, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
        if not isinstance(data, dict):
            raise ValueError(f"{path}: expected a YAML object")
        _validate(data, path)
        vulns.append(data)

    # Sort by loss descending, then by date descending
    vulns.sort(key=lambda v: (_parse_loss(v.get("loss", "")), str(v.get("date", ""))), reverse=True)

    for lang_code, cfg in LANGUAGES.items():
        suffix = cfg["suffix"]
        lines = [f"# {cfg['title']}", ""]
        
        for vuln in vulns:
            # Fallback logic for translated fields
            name = vuln.get(f"name{suffix}") or vuln["name"]
            description = vuln.get(f"description{suffix}") or vuln["description"]
            impact = vuln.get(f"impact{suffix}") or vuln["impact"]
            
            lines.append(f"## {name}")
            lines.append(f"- Date: {vuln['date']}")
            lines.append(f"- Loss: {vuln['loss']}")
            lines.append(f"- Severity: {vuln['severity']}")
            lines.append(f"- Impact: {impact}")
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