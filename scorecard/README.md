# DXD Labs Security Scorecard Tool

Tool for assessing the severity of security vulnerabilities based on BVSS (Blockchain Vulnerability Scoring System) criteria.

## 📁 Directory Structure
- `core/`: Contains shared scoring logic.
- `parsers/`: Modules for reading data from vuln-db (YAML) and checklists (MD).
- `web/`: Interactive Dashboard interface (HTML/JS).
- `templates/`: Report templates (Jinja2).
- `scorecard_config.json`: Single Source of Truth configuration file for weights.

## 🚀 Usage Guide

### Option 1: CLI Tool (Python)
For Auditors to quickly score and export reports into Audit Reports.

**Score a single vulnerability from vuln-db:**
```bash
python scorecard/cli.py --vuln-id cetus_overflow
```

**Override risk parameters:**
```bash
python scorecard/cli.py --vuln-id cetus_overflow --likelihood High --maturity Active
```

**Export report from checklist:**
```bash
python scorecard/cli.py --checklist path/to/checklist.md --output html
```

**Sync data for Web:**
```bash
python scorecard/cli.py --export-web
```

### Option 2: Web Dashboard (GitHub Pages)
For demos or direct client interaction.

1. Ensure the `--export-web` command above has been run.
2. Open `scorecard/web/index.html` in a browser.
3. Select vulnerability or manually enter Impact/Likelihood parameters.

## 📊 Scoring Algorithm (BVSS)
Score is calculated based on:
- **Impact (60%)**: Financial/system impact level.
- **Likelihood (40%)**: Likelihood of attack occurrence.
- **Immutability Multiplier (1.5x)**: Blockchain-specific immutability feature.
- **Exploit Maturity**: Status of exploit code (Theoretical, POC, Active).
- **Privileged Access**: Requirement for special access.

## 🚀 Advanced Usage & CI/CD Integration

**Integrate Static Analysis (from lint.json):**
```bash
python scorecard/cli.py --lint-output lint.json --output html  # Creates scorecard_report.html
```

**Full BVSS Args Override:**
```bash
python scorecard/cli.py --vuln-id cetus_overflow \\
  --impact Critical --likelihood High \\
  --exploitability Network --scope Changed --economic-loss Billions \\
  --maturity Active --output markdown
```

**CI/CD (.github/workflows/static-analysis.yaml):**
- Automatically runs `analyze.py --json > lint.json` → scorecard → upload artifact `scorecard-report`.

## 📈 Example Results
```
# Results for cetus_overflow
- Impact: Critical
- Likelihood: High  
- Score: 9.8/10
- Severity: 🔴 Critical
```

**Custom Config:** Edit `scorecard_config.json` (weights, multipliers).

---
*Developed by DXD Labs.*
