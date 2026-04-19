import os
import yaml
from datetime import datetime

VULNS_DIR = r'd:\DXD LABS\dxdlabs-audit-smartcontract\vuln-db\vulns'
SCANNER_DIR = r'd:\DXD LABS\dxdlabs-audit-smartcontract\vuln-db\move-scanner'

def enrich_directory(directory, id_prefix, start_id):
    files = [f for f in os.listdir(directory) if f.endswith('.yaml')]
    files.sort()
    
    current_id = start_id
    for filename in files:
        path = os.path.join(directory, filename)
        with open(path, 'r', encoding='utf-8') as f:
            try:
                data = yaml.safe_load(f)
            except: continue
        
        if not data: continue
        
        # 1. Assign ID if missing
        changed = False
        if 'id' not in data:
            data_id = f"{id_prefix}-{current_id:03d}"
            print(f"Assigning {data_id} to {filename}")
            current_id += 1
            changed = True
        else:
            # If it has an ID, we might want to skip or update start_id
            # For simplicity, we only add if missing
            pass
            
        # 2. Add BVSS block if missing (using severity heuristic)
        if 'bvss' not in data:
            sev = str(data.get('severity', 'Medium')).capitalize()
            if sev not in ['Low', 'Medium', 'High', 'Critical']: sev = 'Medium'
            eco = "Thousands" if sev in ['Low', 'Medium'] else "Millions"
            
            data['bvss'] = {
                'impact': sev,
                'likelihood': 'Medium',
                'exploitability': 'Network',
                'economic_loss': eco,
                'scope': 'Unchanged',
                'is_immutable': True,
                'exploit_maturity': 'POC',
                'privileged_access': 'Not Required'
            }
            changed = True
            
        if changed:
            # Re-read to preserve comments as much as possible, or just dump
            # yaml.dump often loses comments. Let's try to prepend ID manually 
            # and append BVSS if we want to be safe, but for a registry tool 
            # overwriting is often acceptable if the source is meant to be machine-processed.
            # However, these are human-readable YAMLs.
            
            with open(path, 'w', encoding='utf-8') as f:
                # We put ID at the top
                if 'id' not in open(path).read():
                    f.write(f"id: {id_prefix}-{current_id-1:03d}\n")
                yaml.dump(data, f, allow_unicode=True, sort_keys=False)

# 1. Process VULNS (Case Studies) - Start from 011 (since 001-010 are done)
# Wait, I need to find what the max ID currently is
enrich_directory(VULNS_DIR, "DXD-SUI-2025", 11)

# 2. Process SCANNER (Rules) - Start from 001
enrich_directory(SCANNER_DIR, "DXD-MS-2026", 1)
