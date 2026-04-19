#!/bin/bash
# Sui Audit Kit - Verification Suite
# Sets up the environment and runs the Move Prover on all examples.

set -e

echo "--- [1/3] Environment Setup ---"
# Check if Boogle/Z3 are in path (in Docker they will be)
if ! command -v boogie &> /dev/null; then
    echo "Warning: boogie not found. Prover might fail."
fi

echo "--- [2/3] Building Prover Examples ---"
cd prover-examples
sui move build

echo "--- [3/3] Formal Verification (Move Prover) ---"
echo "Running: sui move prove..."
sui move prove > ../verification_results.log 2>&1 || {
    echo "Verification FAILED. Check verification_results.log"
    exit 1
}

echo "--- SUCCESS ---"
echo "Formal verification passed for all high-assurance modules."
echo "Results saved to verification_results.log"
