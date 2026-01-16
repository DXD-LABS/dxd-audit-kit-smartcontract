#!/bin/bash
# run-move-audit.sh - Quick audit script for Move/Sui contracts

echo "=== Running Sui Move Audit Script ==="
echo "1. Running Sui Move Analyzer..."
sui move analyze --path .  # Run on current package

echo "2. Running unit tests..."
sui move test --path .

echo "3. Checking coverage..."
sui move coverage --path .  # If coverage enabled

echo "4. Manual checklist reminder:"
echo "- Check capability & ownership (see capability-safe.move)"
echo "- Check flash loan destroy (see flash-loan-hot-potato-safe.move)"
echo "- Check oracle staleness (see oracle-integration-safe.move)"

echo "Done! Review output above and use snippets in repo for fix."
