import argparse
import re
import subprocess
import sys
from pathlib import Path

import yaml

SEVERITY_RANK = {"info": 0, "low": 1, "medium": 2, "high": 3, "critical": 4}


def load_rules(yaml_path: Path):
    with yaml_path.open("r", encoding="utf-8") as f:
        data = yaml.safe_load(f) or {}
    return data.get("rules", [])


def iter_move_files(path: Path):
    if path.is_file():
        if path.suffix == ".move":
            yield path
        return
    for p in path.rglob("*.move"):
        if p.is_file():
            yield p


def check_vuln(code: str, rule: dict, file_path: Path):
    pattern = rule.get("pattern", "")
    if not pattern:
        return None
    if re.search(pattern, code, flags=re.MULTILINE):
        name = rule.get("name", "unknown")
        desc = rule.get("description", "")
        sev = rule.get("severity", "info").lower()
        print(f"[VULN] {name}: {desc} (Severity: {sev}) in {file_path}")
        return sev
    return None


def find_move_package_root(path: Path):
    current = path if path.is_dir() else path.parent
    for parent in [current, *current.parents]:
        if (parent / "Move.toml").exists():
            return parent
    return None


def run_move_lint(package_path: Path):
    try:
        result = subprocess.run(["move-lint", "-p", str(package_path)], capture_output=True, text=True)
    except FileNotFoundError:
        print("[WARN] move-lint not found on PATH. Skipping.")
        return 0
    if result.stdout:
        print(result.stdout.strip())
    if result.stderr:
        print(result.stderr.strip())
    return result.returncode


def main():
    parser = argparse.ArgumentParser(description="Run Move Lint + custom Sui rules")
    parser.add_argument("path", help="Move file or package directory")
    parser.add_argument("--rules", default="static-analysis/rules/sui_vuln_rules.yaml")
    parser.add_argument("--no-move-lint", action="store_true")
    args = parser.parse_args()

    base = Path(args.path)
    rules_path = Path(args.rules)
    rules = load_rules(rules_path)

    highest = 0
    linted_packages = set()
    for move_file in iter_move_files(base):
        code = move_file.read_text(encoding="utf-8")
        for rule in rules:
            sev = check_vuln(code, rule, move_file)
            if sev:
                highest = max(highest, SEVERITY_RANK.get(sev, 0))

        if not args.no_move_lint:
            pkg = find_move_package_root(move_file)
            if pkg and pkg not in linted_packages:
                run_move_lint(pkg)
                linted_packages.add(pkg)

    if highest >= SEVERITY_RANK["high"]:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
