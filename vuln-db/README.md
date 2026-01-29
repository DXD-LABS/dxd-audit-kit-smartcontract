# Vuln DB (Sui/Move)

This folder stores real-world Move/Sui vulnerability writeups in YAML format and a parser to generate a summary report.

## Structure

- `vulns/` - One YAML file per vulnerability.
- `parser.py` - Parses all YAML files and generates `summary.md`.
- `requirements.txt` - Python dependencies for the parser.

## YAML schema (required fields)

- `name`
- `date` (YYYY-MM-DD)
- `description`
- `impact`
- `severity`
- `references` (list of URLs)
- `code_vuln`
- `code_fixed`
- `test_vector`

Optional fields:

- `cve_id`
- `affected_projects`
- `sui_testnet_tx`

## Add a new vuln

1. Create a new YAML file in `vulns/` using `snake_case` naming.
2. Fill all required fields and keep descriptions concise and technical.
3. Run the parser to validate and generate the summary.

## Run the parser

```bash
cd vuln-db
python parser.py
```

This writes `vuln-db/summary.md`.