#!/usr/bin/env python3
"""
DXD Audit Kit — Unified CLI
Usage: python -m cli <command> [options]

Commands:
  score   — BVSS scoring từ vuln-db hoặc lint output
  prove   — Chạy sui-prover trên Move module, parse kết quả
  report  — Auto-generate audit report (MD/HTML) từ scorecard + vuln-db + prover
  tee     — Nautilus TEE attestation audit workflow
  zk      — zk-Intent verification audit workflow
"""
import argparse
import sys
import os

# Ensure project root is in sys.path
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from cli.commands.score import run_score
from cli.commands.prove import run_prove
from cli.commands.report import run_report
from cli.commands.tee import run_tee
from cli.commands.zk import run_zk

BANNER = """
╔══════════════════════════════════════════════════╗
║   DXD Labs — Unified Smart Contract Audit CLI   ║
║   Version 1.0.0  |  dxdlabs.io                  ║
╚══════════════════════════════════════════════════╝
"""


def build_parser():
    parser = argparse.ArgumentParser(
        prog="dxd-audit",
        description="DXD Labs Smart Contract Audit Kit — Unified CLI",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python -m cli score --vuln-id oracle_manipulation
  python -m cli score --all --output json
  python -m cli prove --module oracle_safe
  python -m cli report --project navi-protocol --output html
  python -m cli tee attest --module my_module
  python -m cli zk verify-intent --module my_intent
""",
    )
    parser.add_argument("--version", action="version", version="dxd-audit 1.0.0")
    parser.add_argument("--no-banner", action="store_true", help="Hide banner")

    subparsers = parser.add_subparsers(dest="command", metavar="<command>")
    subparsers.required = True

    # ── score ──────────────────────────────────────────────────────────
    sp_score = subparsers.add_parser(
        "score",
        help="Tính BVSS score từ vuln-db hoặc lint output",
        description="BVSS Scoring — tích hợp với vuln-db và static analysis",
    )
    sp_score.add_argument("--vuln-id", help="ID của vulnerability trong vuln-db/vulns/<id>.yaml")
    sp_score.add_argument("--all", dest="all_vulns", action="store_true", help="Score tất cả vulns trong DB")
    sp_score.add_argument("--lint-output", help="Path tới static analysis JSON output")
    sp_score.add_argument(
        "--output",
        choices=["markdown", "html", "json"],
        default="markdown",
        help="Output format (default: markdown)",
    )
    sp_score.add_argument("--impact", choices=["Critical", "High", "Medium", "Low"])
    sp_score.add_argument("--likelihood", choices=["High", "Medium", "Low"])
    sp_score.add_argument(
        "--maturity", choices=["Active", "POC", "Theoretical"], default="POC"
    )

    # ── prove ──────────────────────────────────────────────────────────
    sp_prove = subparsers.add_parser(
        "prove",
        help="Chạy sui move prove và parse kết quả",
        description="Move Prover integration — chạy formal verification và link về vuln-db",
    )
    sp_prove.add_argument("--module", help="Tên module trong prover-examples (e.g. oracle_safe)")
    sp_prove.add_argument(
        "--path",
        default="prover-examples",
        help="Path tới Move project chứa prover specs (default: prover-examples)",
    )
    sp_prove.add_argument(
        "--output", choices=["markdown", "json"], default="markdown"
    )
    sp_prove.add_argument(
        "--link-vulns", action="store_true", help="Link kết quả prover về vuln-db entries"
    )

    # ── report ─────────────────────────────────────────────────────────
    sp_report = subparsers.add_parser(
        "report",
        help="Auto-generate audit report từ scorecard + vuln-db + prover",
        description="Audit Report Engine — render Markdown/HTML từ toàn bộ pipeline",
    )
    sp_report.add_argument("--project", required=True, help="Tên project (dùng làm tên file output)")
    sp_report.add_argument(
        "--output", choices=["markdown", "html", "both"], default="both"
    )
    sp_report.add_argument(
        "--vuln-db",
        default="vuln-db/vulns",
        help="Path tới vuln-db/vulns/ directory (default: vuln-db/vulns)",
    )
    sp_report.add_argument(
        "--prover-path",
        default="prover-examples",
        help="Path tới prover-examples/ (default: prover-examples)",
    )
    sp_report.add_argument(
        "--client-dir",
        help="Path tới client report directory (ví dụ: clients/2026-03-navi-protocol)",
    )
    sp_report.add_argument(
        "--no-prover", action="store_true", help="Bỏ qua prover step (chỉ score + vuln-db)"
    )

    # ── tee ────────────────────────────────────────────────────────────
    sp_tee = subparsers.add_parser(
        "tee",
        help="Nautilus TEE attestation audit workflow",
        description="TEE Audit — kiểm tra Nautilus TEE attestation patterns và risks",
    )
    tee_sub = sp_tee.add_subparsers(dest="tee_action", metavar="<action>")
    tee_sub.required = True

    tee_attest = tee_sub.add_parser("attest", help="Audit TEE attestation flow của một module")
    tee_attest.add_argument("--module", help="Tên module Move cần audit TEE")
    tee_attest.add_argument("--output", choices=["markdown", "json"], default="markdown")

    tee_sub.add_parser("vectors", help="Liệt kê tất cả TEE attack vectors với BVSS scores")
    tee_sub.add_parser("specs", help="Hiển thị Move prover specs cho TEE patterns")

    # ── zk ─────────────────────────────────────────────────────────────
    sp_zk = subparsers.add_parser(
        "zk",
        help="zk-Intent verification audit workflow",
        description="ZK-Intent Audit — kiểm tra zero-knowledge intent verification patterns",
    )
    zk_sub = sp_zk.add_subparsers(dest="zk_action", metavar="<action>")
    zk_sub.required = True

    zk_verify = zk_sub.add_parser("verify-intent", help="Audit zk-intent verification flow")
    zk_verify.add_argument("--module", help="Tên module Move cần audit zk-intent")
    zk_verify.add_argument("--output", choices=["markdown", "json"], default="markdown")

    zk_sub.add_parser("nullifier-check", help="Kiểm tra nullifier uniqueness pattern")
    zk_sub.add_parser("vectors", help="Liệt kê zk-intent attack vectors với BVSS scores")
    zk_sub.add_parser("specs", help="Hiển thị Move prover specs cho zk-intent patterns")

    return parser


def main():
    parser = build_parser()
    args = parser.parse_args()

    if not getattr(args, "no_banner", False):
        print(BANNER)

    cmd = args.command
    if cmd == "score":
        run_score(args)
    elif cmd == "prove":
        run_prove(args)
    elif cmd == "report":
        run_report(args)
    elif cmd == "tee":
        run_tee(args)
    elif cmd == "zk":
        run_zk(args)


if __name__ == "__main__":
    main()
