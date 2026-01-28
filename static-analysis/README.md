# Move Static Analysis

This folder provides a lightweight static analysis pipeline for Sui Move.

## Quick start

- Install dependencies:
  - Rust toolchain (for `move-lint`)
  - Sui CLI (for `sui move disassemble`)
  - Python 3.10+

- Python deps:
  - `pip install -r static-analysis/requirements.txt`

- Run on a single file:
  - `python static-analysis/scripts/analyze.py path/to/module.move`

- Run on a directory:
  - `python static-analysis/scripts/analyze.py path/to/package`

- Bytecode scan (requires buildable Sui package path):
  - `python static-analysis/scripts/parse_bytecode.py path/to/package`

## Custom rules

Rules live in `static-analysis/rules/sui_vuln_rules.yaml`.
Each rule has:
- `name`, `description`, `pattern` (regex), `severity`

The analyzer flags matches and exits non-zero for `high` or `critical`.

## Optional Rust extension

`static-analysis/Cargo.toml` is a scaffold to extend Move Lint using Rust.
The default pipeline uses Python for speed of iteration.
