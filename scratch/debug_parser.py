import yaml
import os

path = "d:/DXD LABS/dxdlabs-audit-smartcontract/vuln-db/vulns/agent_btcfi_oracle_manip.yaml"
with open(path, "r", encoding="utf-8") as f:
    data = yaml.safe_load(f)

print(f"ID: {data.get('id')}")
print(f"Root Cause keys: {[k for k in data.keys() if 'root' in k]}")
print(f"Mitigation keys: {[k for k in data.keys() if 'mitigation' in k]}")
print(f"Root Cause val: {data.get('root_cause')}")
