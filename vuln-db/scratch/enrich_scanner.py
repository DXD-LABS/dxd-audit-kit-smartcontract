import os
import yaml

dir_path = r'd:\DXD LABS\dxdlabs-audit-smartcontract\vuln-db\move-scanner'
files = [f for f in os.listdir(dir_path) if f.endswith('.yaml')]
files.sort()

count = 1
for filename in files:
    path = os.path.join(dir_path, filename)
    with open(path, 'r', encoding='utf-8') as f:
        try:
            data = yaml.safe_load(f)
        except:
            continue
            
    if data and 'id' not in data:
        new_id = f"DXD-MS-2026-{count:03d}"
        print(f"Assigning {new_id} to {filename}")
        
        # Determine BVSS based on severity
        sev = str(data.get('severity', 'Medium')).capitalize()
        if sev not in ['Low', 'Medium', 'High', 'Critical']:
            sev = 'Medium'
            
        eco = "Thousands" if sev in ['Low', 'Medium'] else "Millions"
        
        bvss_block = {
            'impact': sev,
            'likelihood': 'Medium',
            'exploitability': 'Network',
            'economic_loss': eco,
            'scope': 'Unchanged',
            'is_immutable': True,
            'exploit_maturity': 'POC',
            'privileged_access': 'Not Required'
        }
        
        # Prepend ID and add BVSS block
        new_content = f"id: {new_id}\n"
        with open(path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            
        # Add BVSS block at the end if not present
        if 'bvss:' not in "".join(lines):
            new_lines = [f"id: {new_id}\n"] + lines + ["\nbvss:\n"]
            for k, v in bvss_block.items():
                val = f"'{v}'" if isinstance(v, str) else str(v).lower()
                new_lines.append(f"  {k}: {val}\n")
        else:
            new_lines = [f"id: {new_id}\n"] + lines
            
        with open(path, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)
            
        count += 1
