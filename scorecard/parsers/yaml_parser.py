import yaml
import os

class VulnDBParser:
    def __init__(self, vuln_db_path='vuln-db/vulns'):
        self.vuln_db_path = vuln_db_path

    def get_vuln_data(self, vuln_id):
        """
        Load vulnerability data from YAML file in vuln-db/vulns/
        """
        # Try different extensions if needed
        file_path = os.path.join(self.vuln_db_path, f"{vuln_id}.yaml")
        
        if not os.path.exists(file_path):
            return None
            
        with open(file_path, 'r', encoding='utf-8') as f:
            try:
                data = yaml.safe_load(f)
                return data
            except yaml.YAMLError:
                return None

    def export_all_to_json(self, output_path):
        """
        Export all vulnerabilities to a single JSON file for the Web tool
        """
        import json
        from datetime import date

        class DateTimeEncoder(json.JSONEncoder):
            def default(self, obj):
                if isinstance(obj, date):
                    return obj.isoformat()
                return super().default(obj)

        all_vulns = []
        
        if not os.path.exists(self.vuln_db_path):
            return False
            
        for filename in os.listdir(self.vuln_db_path):
            if filename.endswith('.yaml'):
                vuln_id = filename[:-5]
                data = self.get_vuln_data(vuln_id)
                if data:
                    # Add ID if not present
                    data['id'] = vuln_id
                    all_vulns.append(data)
                    
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(all_vulns, f, indent=2, ensure_ascii=False, cls=DateTimeEncoder)
        return True
