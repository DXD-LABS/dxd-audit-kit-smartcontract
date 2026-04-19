#!/bin/bash

# DXD Audit Kit - One-Click Audit Script
# High-level entry point to run environment checks and all verified security tests.

set -e

echo "================================================"
echo "    DXD Audit Kit - One-Click Audit v0.1.0"
echo "================================================"

# 1. Run Environment Check
if [ -f "./scripts/check-env.sh" ]; then
    bash ./scripts/check-env.sh
else
    echo "[!] Error: ./scripts/check-env.sh not found."
    exit 1
fi

# 2. Run Security Tests (PoCs)
echo ""
echo "[*] Step 1: Running Security Tests (PoCs)..."
if [ -d "./tests" ]; then
    cd tests
    sui move test
    cd ..
    echo "[+] Security tests passed (expected failures for vulnerable PoCs are labeled)."
else
    echo "[!] Warning: tests/ directory not found. Skipping."
fi

# 3. Parse Vulnerability Database
echo ""
echo "[*] Step 2: Parsing Vulnerability Database Summary..."
if [ -d "./vuln-db" ]; then
    cd vuln-db
    if [ -f "parser.py" ]; then
        python3 parser.py || python parser.py
        echo "[+] Vuln-DB summary generated."
    else
        echo "[!] Warning: parser.py not found in vuln-db/."
    fi
    cd ..
else
    echo "[!] Warning: vuln-db/ directory not found. Skipping."
fi

# 4. Formal Verification (Move Prover) - Optional Step
echo ""
echo "[*] Step 3: Running Formal Verification (Move Prover)..."
if [ -d "./secure-patterns" ]; then
    cd secure-patterns
    if command -v z3 &> /dev/null; then
        echo "[+] Prover dependencies detected. Running verification..."
        sui move prove || echo "[!] Prover found issues or was interrupted."
    else
        echo "[SKIP] Move Prover dependencies (Z3/CVC5) not found. Skipping FV."
        echo "       Tip: Use Docker environment to run Formal Verification."
    fi
    cd ..
else
    echo "[!] Warning: secure-patterns/ directory not found. Skipping."
fi

# 5. Final Summary
echo ""
echo "================================================"
echo "[SUCCESS] Audit Kit Run Complete."
echo "Check README.md for adoption instructions."
echo "================================================"
