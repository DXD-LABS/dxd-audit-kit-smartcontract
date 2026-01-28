import argparse
import re
import subprocess
import sys
from pathlib import Path

PATTERNS = [
    (re.compile(r"reentrancy|recursive", re.IGNORECASE), "Potential reentrancy in bytecode"),
]


def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True)


def disassemble_with_sui(mv_path: Path):
    result = run(["sui", "move", "disassemble", "--path", str(mv_path)])
    if result.returncode == 0:
        return result.stdout
    return None


def disassemble_with_move(mv_path: Path):
    result = run(["move", "disassemble", str(mv_path)])
    if result.returncode == 0:
        return result.stdout
    return None


def main():
    parser = argparse.ArgumentParser(description="Disassemble Move bytecode and scan for patterns")
    parser.add_argument("path", help="Sui package path")
    parser.add_argument("--strict", action="store_true", help="Fail on build errors")
    args = parser.parse_args()

    root = Path(args.path)
    if root.is_file():
        print("[WARN] Expected a directory path for a Sui package")
        return 0

    package_paths = []
    if (root / "Move.toml").exists():
        package_paths.append(root)
    else:
        package_paths = [p.parent for p in root.rglob("Move.toml")]

    if not package_paths:
        print("[WARN] No Move.toml found. Skipping bytecode analysis.")
        return 0

    found = False
    for pkg_path in package_paths:
        build = run(["sui", "move", "build", "--path", str(pkg_path)])
        if build.returncode != 0:
            print(build.stdout)
            print(build.stderr)
            if args.strict:
                return 1
            print(f"[WARN] Build failed for {pkg_path}. Skipping bytecode scan.")
            continue

        mv_files = list((pkg_path / "build").rglob("*.mv"))
        if not mv_files:
            print(f"[WARN] No .mv files found under {pkg_path / 'build'}")
            continue

        for mv in mv_files:
            text = disassemble_with_sui(mv)
            if text is None:
                text = disassemble_with_move(mv)
            if text is None:
                print(f"[WARN] Could not disassemble {mv}")
                continue

            for pattern, message in PATTERNS:
                if pattern.search(text):
                    print(f"[VULN] {message} in {mv}")
                    found = True

    return 1 if found else 0


if __name__ == "__main__":
    sys.exit(main())
