#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Running Move unit tests..."
( cd "$ROOT_DIR" && sui move test )

SUI_ENV_ALIAS=${SUI_ENV_ALIAS:-testnet}
SUI_RPC_URL=${SUI_RPC_URL:-https://fullnode.testnet.sui.io:443}
SUI_GAS_BUDGET=${SUI_GAS_BUDGET:-10000000}
SUI_SKIP_FAUCET=${SUI_SKIP_FAUCET:-0}

if ! sui client envs | grep -q "$SUI_ENV_ALIAS"; then
  sui client new-env --alias "$SUI_ENV_ALIAS" --rpc "$SUI_RPC_URL"
fi

sui client switch --env "$SUI_ENV_ALIAS"

if [ -z "${SUI_ADDRESS:-}" ]; then
  ADDRESS_JSON=$(sui client new-address ed25519 --json)
  SUI_ADDRESS=$(python - <<'PY' "$ADDRESS_JSON"
import json,sys
print(json.loads(sys.argv[1])["address"])
PY
  )
fi

sui client switch --address "$SUI_ADDRESS"

if [ "$SUI_SKIP_FAUCET" != "1" ]; then
  if ! sui client faucet --address "$SUI_ADDRESS"; then
    echo "Faucet failed. Fund the address via https://faucet.sui.io/?address=$SUI_ADDRESS"
    echo "Then re-run with: SUI_ADDRESS=$SUI_ADDRESS SUI_SKIP_FAUCET=1 ./run_tests.sh"
    exit 1
  fi
  sleep 10
fi

PUBLISH_JSON=$(sui client publish --path "$ROOT_DIR" --gas-budget "$SUI_GAS_BUDGET" --json)
PACKAGE_ID=$(python - <<'PY' "$PUBLISH_JSON"
import json,sys
payload = json.loads(sys.argv[1])
package_id = None
for change in payload.get("objectChanges", []):
    if change.get("type") == "published":
        package_id = change.get("packageId")
        break
if not package_id:
    raise SystemExit("packageId not found in publish output")
print(package_id)
PY
)

echo "Published package: $PACKAGE_ID"

echo "Running testnet exploit entry calls..."
sui client call --package "$PACKAGE_ID" --module cetus_overflow --function exploit --gas-budget "$SUI_GAS_BUDGET"
sui client call --package "$PACKAGE_ID" --module hamsterwheel_dos --function exploit --gas-budget "$SUI_GAS_BUDGET"
sui client call --package "$PACKAGE_ID" --module oracle_manipulation --function exploit --gas-budget "$SUI_GAS_BUDGET"
sui client call --package "$PACKAGE_ID" --module upgrade_abort --function exploit --gas-budget "$SUI_GAS_BUDGET"
sui client call --package "$PACKAGE_ID" --module seal_misuse --function exploit --gas-budget "$SUI_GAS_BUDGET"

echo "Integration tests completed."
