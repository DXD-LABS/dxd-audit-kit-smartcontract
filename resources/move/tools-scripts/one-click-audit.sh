#!/bin/bash
# one-click-audit.sh - Quick start audit Move/Sui contract

echo "=== One-Click Audit Starter for Move/Sui ==="

# 1. Run Sui Move analyzer
echo "1. Running Sui Move Analyzer..."
sui move analyze --path .

# 2. Run tests
echo "2. Running tests..."
sui move test --path .

# 3. Quick checklist reminder
echo "3. Quick Checklist Reminder:"
cat <<EOF
- Capability: No public borrow?
- Flash loan: Destroy in tx?
- Oracle: Staleness check?
- Kiosk: OwnerCap restrict?
- Upgrade: Version guard?
EOF

echo "Done! Use snippets in repo for fix. Feedback/PR welcome!"
