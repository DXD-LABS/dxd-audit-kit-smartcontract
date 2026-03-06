"""
cli/core/prover_runner.py — Move Prover subprocess wrapper
Chạy `sui move prove` và parse stdout để phát hiện PASS/FAIL/ERROR.
"""
import os
import re
import subprocess
import sys
from typing import Optional


# Patterns từ sui-prover output
_PASS_RE = re.compile(r"\[PASS\]\s+(.+)")
_FAIL_RE = re.compile(r"\[FAIL\]\s+(.+)")
_ERROR_RE = re.compile(r"^error(\[E\d+\])?:", re.MULTILINE | re.IGNORECASE)
_SPEC_RE = re.compile(r"spec\s+(\w+)\s*\{", re.MULTILINE)
_ABORT_RE = re.compile(r"aborts_if\s+(.+);")
_ENSURES_RE = re.compile(r"ensures\s+(.+);")


class ProverRunner:
    def __init__(self, project_path: str):
        self.project_path = os.path.abspath(project_path)

    def _run_prover(self, extra_args: list = None) -> tuple[int, str, str]:
        """Chạy `sui move prove` và trả về (returncode, stdout, stderr)."""
        cmd = ["sui", "move", "prove", "--named-address", "prover_examples=_"]
        if extra_args:
            cmd.extend(extra_args)

        try:
            proc = subprocess.run(
                cmd,
                cwd=self.project_path,
                capture_output=True,
                text=True,
                timeout=120,
            )
            return proc.returncode, proc.stdout, proc.stderr
        except FileNotFoundError:
            # sui CLI không được cài
            return -1, "", "sui CLI not found — prover not available in this environment"
        except subprocess.TimeoutExpired:
            return -2, "", "Prover timed out after 120 seconds"

    def _parse_specs_from_file(self, module_name: str) -> list:
        """Đọc file .move và extract tên spec functions."""
        sources_dir = os.path.join(self.project_path, "sources")
        move_file = os.path.join(sources_dir, f"{module_name}.move")
        if not os.path.exists(move_file):
            return []
        with open(move_file, "r", encoding="utf-8") as f:
            content = f.read()
        return _SPEC_RE.findall(content)

    def _parse_output(self, module: str, returncode: int, stdout: str, stderr: str) -> dict:
        """Parse prover output và return structured result."""
        combined = (stdout + "\n" + stderr).strip()
        specs = self._parse_specs_from_file(module)

        if returncode == -1:
            return {
                "module": module,
                "status": "UNAVAILABLE",
                "specs": specs,
                "hints": [
                    "sui CLI not installed — install sui CLI để chạy prover",
                    "Xem: https://docs.sui.io/guides/developer/getting-started/sui-install",
                ],
                "raw": stderr,
            }
        if returncode == -2:
            return {
                "module": module,
                "status": "ERROR",
                "specs": specs,
                "hints": ["Prover timed out — thử reduce prover complexity hoặc tăng timeout"],
                "raw": "",
            }

        # Detect PASS/FAIL
        has_pass = bool(_PASS_RE.search(combined))
        has_fail = bool(_FAIL_RE.search(combined))
        has_error = bool(_ERROR_RE.search(combined))

        if returncode == 0 and not has_fail and not has_error:
            status = "PASS"
        elif has_fail:
            status = "FAIL"
        else:
            status = "ERROR" if has_error else ("PASS" if returncode == 0 else "FAIL")

        # Extract hints from failures
        hints = []
        for m in _FAIL_RE.finditer(combined):
            hints.append(f"FAIL: {m.group(1).strip()}")
        for line in combined.split("\n"):
            if "error:" in line.lower() and len(line) < 300:
                hints.append(line.strip())

        return {
            "module": module,
            "status": status,
            "specs": specs,
            "hints": hints[:10],  # cap at 10 hints
            "raw": combined[:500],  # cap raw output
        }

    def prove_module(self, module_name: str) -> dict:
        """Prove một module cụ thể."""
        returncode, stdout, stderr = self._run_prover(
            ["--filter", module_name]
        )
        return self._parse_output(module_name, returncode, stdout, stderr)

    def prove_all(self) -> list:
        """Prove tất cả modules trong prover-examples/sources/."""
        sources_dir = os.path.join(self.project_path, "sources")
        if not os.path.isdir(sources_dir):
            return []

        modules = [
            f[:-5] for f in os.listdir(sources_dir)
            if f.endswith(".move")
        ]

        if not modules:
            return []

        # Chạy prove all một lần (hiệu quả hơn từng module)
        returncode, stdout, stderr = self._run_prover()
        combined = stdout + "\n" + stderr

        results = []
        for module in sorted(modules):
            # Parse per-module từ combined output
            specs = self._parse_specs_from_file(module)
            # Tìm PASS/FAIL cho module cụ thể trong output
            module_pattern = re.compile(
                rf"(PASS|FAIL|error).{{0,200}}{re.escape(module)}.{{0,200}}", re.IGNORECASE
            )
            module_mentions = module_pattern.findall(combined)

            if returncode == -1:  # sui not found
                status = "UNAVAILABLE"
                hints = ["sui CLI not installed — specs defined, prover unavailable"]
            elif any("FAIL" in m or "error" in m.lower() for m in module_mentions):
                status = "FAIL"
                hints = [f"Check spec: {s}" for s in specs[:3]]
            elif returncode == 0:
                status = "PASS"
                hints = []
            else:
                status = "ERROR" if _ERROR_RE.search(combined) else "UNKNOWN"
                hints = []

            results.append({
                "module": module,
                "status": status,
                "specs": specs,
                "hints": hints,
            })

        return results
