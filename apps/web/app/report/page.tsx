"use client";

import React, { useState, useEffect } from 'react';
import { FilePlus, LineChart, Copy, Download, Trash2, ListChecks, AlertTriangle } from 'lucide-react';
import { useReport } from '../../context/ReportContext';

export default function ReportPage() {
  const { reportCart, removeFromCart } = useReport();

  // Report metadata states
  const [projectName, setProjectName] = useState<string>('DeepBook V2 Core Protocol');
  const [commitHash, setCommitHash] = useState<string>('8f12a3d5b0c79e6aef881c2d3d4e5f6a8b23c90d');
  const [network, setNetwork] = useState<string>('Sui Mainnet');
  const [scope, setScope] = useState<string>('sources/deepbook.move, sources/pool.move');

  // Markdown output preview state
  const [markdownOutput, setMarkdownOutput] = useState<string>('');

  // Toast state
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => {
      setToastMessage(null);
    }, 3000);
  };

  // 1. Calculate Statistics
  const total = reportCart.length;
  let avgScore = 0;
  let criticalCount = 0;
  let highCount = 0;
  let mediumCount = 0;
  let lowCount = 0;

  if (total > 0) {
    let sum = 0;
    reportCart.forEach(item => {
      sum += item.score;
      if (item.severity === 'Critical') criticalCount++;
      else if (item.severity === 'High') highCount++;
      else if (item.severity === 'Medium') mediumCount++;
      else lowCount++;
    });
    avgScore = sum / total;
  }

  // Risk Rating Label & Color
  let riskRating = 'N/A';
  let riskColor = 'var(--text-secondary)';
  if (total > 0) {
    if (avgScore >= 8.5) {
      riskRating = 'CRITICAL RISK';
      riskColor = 'var(--color-critical)';
    } else if (avgScore >= 6.5) {
      riskRating = 'HIGH RISK';
      riskColor = 'var(--color-high)';
    } else if (avgScore >= 4.0) {
      riskRating = 'MEDIUM';
      riskColor = 'var(--color-medium)';
    } else {
      riskRating = 'LOW RISK';
      riskColor = 'var(--color-low)';
    }
  }

  const chartScale = total > 0 ? 100 / total : 0;

  // 2. Generate Markdown Live Output
  useEffect(() => {
    const timeNow = new Date().toISOString().slice(0, 10) + ' ' + new Date().toTimeString().slice(0, 5);
    let md = `# Security Audit Report: ${projectName}\n`;
    md += `> Compiled dynamically via DXD Labs Security Portal • ${timeNow}\n\n`;
    md += `## 1. Executive Metadata Overview\n`;
    md += `- **Project Target:** ${projectName}\n`;
    md += `- **Commit Hash:** \`${commitHash}\`\n`;
    md += `- **Target Network:** ${network}\n`;
    md += `- **Audit Scope:** \`${scope}\`\n\n`;
    
    md += `## 2. Executive Summary\n`;
    md += `| Statistics Metric | Audited Value |\n`;
    md += `| :--- | :--- |\n`;
    md += `| Total Identified Findings | **${total}** |\n`;
    md += `| Weighted Average BVSS Score | **${avgScore.toFixed(1)} / 10** |\n`;
    md += `| Critical Findings (🔴) | ${criticalCount} |\n`;
    md += `| High Findings (🟠) | ${highCount} |\n`;
    md += `| Medium Findings (🟡) | ${mediumCount} |\n`;
    md += `| Low Findings (🟢) | ${lowCount} |\n\n`;
    
    md += `## 3. Scorecard Vulnerability Assessment Matrix\n`;
    md += `| ID | Finding Title | Severity | BVSS Score |\n`;
    md += `| :--- | :--- | :---: | :---: |\n`;
    
    if (total === 0) {
      md += `| - | Report cart is empty | - | - |\n`;
    } else {
      reportCart.forEach(item => {
        const icon = item.severity === 'Critical' ? '🔴' : item.severity === 'High' ? '🟠' : item.severity === 'Medium' ? '🟡' : '🟢';
        md += `| \`${item.id}\` | ${item.name} | ${icon} ${item.severity} | **${item.score.toFixed(1)}** |\n`;
      });
    }

    md += `\n## 4. Comprehensive Findings Details & Mitigation Advice\n`;
    if (total === 0) {
      md += `No security findings added to this report compilation.\n`;
    } else {
      reportCart.forEach((item, idx) => {
        md += `\n### 4.${idx + 1} [${item.id}] ${item.name}\n`;
        md += `- **Severity Level:** ${item.severity} (BVSS Score: **${item.score.toFixed(1)} / 10**)\n`;
        md += `\n**Description:**\n${item.description.trim()}\n`;
        
        if (item.code_vuln) {
          md += `\n**Vulnerable Snippet:**\n\`\`\`rust\n${item.code_vuln.trim()}\n\`\`\`\n`;
        }
        if (item.code_fixed) {
          md += `\n**Audited Remediation Patch:**\n\`\`\`rust\n${item.code_fixed.trim()}\n\`\`\`\n`;
        }
        if (item.references && item.references.length > 0) {
          md += `\n**References:**\n`;
          item.references.forEach(r => {
            md += `- ${r}\n`;
          });
        }
        md += `\n---\n`;
      });
    }

    md += `\n\n_This report was compiled utilizing the DXD Labs Smart Contract Audit Suite._`;
    setMarkdownOutput(md);
  }, [projectName, commitHash, network, scope, reportCart, total, avgScore, criticalCount, highCount, mediumCount, lowCount]);

  const handleCopyMarkdown = () => {
    if (total === 0) {
      showToast("Report cart is currently empty!");
      return;
    }
    navigator.clipboard.writeText(markdownOutput);
    showToast("Markdown report copied to clipboard!");
  };

  const escapeHtml = (text: string) => {
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  };

  const handleDownloadHTML = () => {
    if (total === 0) {
      showToast("Report cart is currently empty!");
      return;
    }

    const timeNow = new Date().toLocaleString('en-US');

    let rows = '';
    reportCart.forEach((item, idx) => {
      let badgeColor = '#10b981';
      if (item.severity === 'Critical') badgeColor = '#ef4444';
      else if (item.severity === 'High') badgeColor = '#f97316';
      else if (item.severity === 'Medium') badgeColor = '#eab308';

      rows += `
      <tr>
          <td>${idx + 1}</td>
          <td><code>${item.id}</code></td>
          <td><strong>${item.name}</strong></td>
          <td><span style="background:${badgeColor}; color:white; padding:2px 8px; border-radius:4px; font-weight:700; font-size:11px; text-transform:uppercase;">${item.severity}</span></td>
          <td><strong style="color:${badgeColor};">${item.score.toFixed(1)}</strong>/10</td>
      </tr>`;
    });

    let details = '';
    reportCart.forEach((item, idx) => {
      let badgeColor = '#10b981';
      if (item.severity === 'Critical') badgeColor = '#ef4444';
      else if (item.severity === 'High') badgeColor = '#f97316';
      else if (item.severity === 'Medium') badgeColor = '#eab308';

      const vulnCode = item.code_vuln ? `<div class="code-title">Vulnerable Snippet</div><pre><code>${escapeHtml(item.code_vuln.trim())}</code></pre>` : '';
      const fixedCode = item.code_fixed ? `<div class="code-title safe">Audited Secure Patch</div><pre><code style="border-left-color:#10b981; color:#a7f3d0;">${escapeHtml(item.code_fixed.trim())}</code></pre>` : '';
      const refs = item.references && item.references.length > 0
          ? `<ul>${item.references.map(r => `<li><a href="${r}" target="_blank">${r}</a></li>`).join('')}</ul>`
          : '<p>None.</p>';

      details += `
      <div class="finding-card">
          <h3 class="finding-title">
              <span class="finding-badge" style="background:${badgeColor};">${item.severity}</span>
              4.${idx + 1} [${item.id}] ${item.name}
              <span style="float:right; font-size:14px; font-weight:800; color:${badgeColor};">BVSS: ${item.score.toFixed(1)}/10</span>
          </h3>
          <p style="margin:10px 0; color:#cbd5e1; line-height:1.6;">${item.description.replace(/\n/g, '<br>')}</p>
          ${vulnCode}
          ${fixedCode}
          <div style="margin-top:15px; font-size:13px;">
              <strong>References:</strong>
              ${refs}
          </div>
      </div>`;
    });

    const htmlContent = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Audit Report: ${projectName}</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #060913;
            --surface: #0f172a;
            --border: rgba(255,255,255,0.08);
            --accent: #3b82f6;
            --text: #f8fafc;
            --text-sec: #cbd5e1;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            padding: 3rem 1.5rem;
            line-height: 1.55;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .header {
            border-bottom: 2px solid var(--border);
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
            position: relative;
        }
        .header h1 {
            font-size: 2.25rem;
            font-weight: 800;
            background: linear-gradient(to right, #ffffff, #94a3b8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .header-meta {
            margin-top: 1rem;
            color: var(--text-sec);
            font-size: 13px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 8px;
        }
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
            gap: 12px;
            margin: 2rem 0;
        }
        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.25rem;
            text-align: center;
        }
        .stat-val { font-size: 28px; font-weight: 800; color: var(--accent); }
        .stat-lbl { font-size: 11px; text-transform: uppercase; color: var(--text-sec); margin-top: 4px; font-weight: 700; }
        h2 { font-size: 1.5rem; font-weight: 700; border-bottom: 1px solid var(--border); padding-bottom: 6px; margin: 2rem 0 1rem 0; color: var(--accent); }
        table { width: 100%; border-collapse: collapse; margin: 1rem 0; }
        th { text-align: left; background: var(--surface); color: var(--text-sec); padding: 10px 15px; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid var(--border); }
        td { padding: 12px 15px; border-bottom: 1px solid var(--border); font-size: 14px; }
        code { font-family: 'Fira Code', monospace; background: rgba(30, 41, 59, 0.5); padding: 2px 6px; border-radius: 4px; font-size: 13px; }
        pre { background: #070a13; padding: 1.25rem; border-radius: 8px; overflow-x: auto; font-family: 'Fira Code', monospace; font-size: 13px; border-left: 3px solid #ef4444; color: #fecdd3; margin-bottom: 15px; }
        .code-title { font-size: 12px; text-transform: uppercase; font-weight: 700; color: #ef4444; margin-bottom: 4px; }
        .code-title.safe { color: #10b981; }
        .finding-card { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 1.5rem; margin-bottom: 1.5rem; }
        .finding-title { border-bottom: 1px solid var(--border); padding-bottom: 10px; margin-bottom: 15px; font-size: 18px; font-weight: 700; }
        .finding-badge { display: inline-block; padding: 2px 8px; border-radius: 4px; color: white; font-size: 11px; font-weight: 700; vertical-align: middle; margin-right: 8px; text-transform: uppercase; }
        a { color: var(--accent); text-decoration: none; }
        a:hover { text-decoration: underline; }
        ul { padding-left: 20px; color: var(--text-sec); }
        .footer { margin-top: 4rem; text-align: center; color: var(--text-sec); font-size: 12px; border-top: 1px solid var(--border); padding-top: 1.5rem; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🛡️ Smart Contract Security Audit Report</h1>
            <div class="header-meta">
                <div><strong>Project:</strong> ${projectName}</div>
                <div><strong>Commit Hash:</strong> <code>${commitHash}</code></div>
                <div><strong>Date:</strong> ${timeNow}</div>
                <div><strong>Scope:</strong> <code>${scope}</code></div>
                <div><strong>Target Network:</strong> ${network}</div>
                <div><strong>Auditor:</strong> DXD Labs Security Team</div>
            </div>
        </div>

        <div class="stat-grid">
            <div class="stat-card"><div class="stat-val">${total}</div><div class="stat-lbl">Findings</div></div>
            <div class="stat-card"><div class="stat-val" style="color:#ef4444;">${criticalCount}</div><div class="stat-lbl">Critical</div></div>
            <div class="stat-card"><div class="stat-val" style="color:#f97316;">${highCount}</div><div class="stat-lbl">High</div></div>
            <div class="stat-card"><div class="stat-val" style="color:#eab308;">${mediumCount}</div><div class="stat-lbl">Medium</div></div>
            <div class="stat-card"><div class="stat-val" style="color:#10b981;">${lowCount}</div><div class="stat-lbl">Low</div></div>
            <div class="stat-card"><div class="stat-val">${avgScore.toFixed(1)}</div><div class="stat-lbl">Avg BVSS</div></div>
        </div>

        <h2>📊 Assessment Scorecard Summary</h2>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Vulnerability ID</th>
                    <th>Security Finding Title</th>
                    <th>Severity</th>
                    <th>BVSS Score</th>
                </tr>
            </thead>
            <tbody>
                ${rows}
            </tbody>
        </table>

        <h2>🔍 Detailed Security Audit Findings</h2>
        ${details}

        <div class="footer">
            Report compiled by <strong>DXD Labs Smart Contract Audit Suite</strong>.<br>
            © 2026 DXD Labs. All rights reserved.
        </div>
    </div>
</body>
</html>`;

    const blob = new Blob([htmlContent], { type: 'text/html;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${projectName.toLowerCase().replace(/\s+/g, '_')}_security_report.html`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    showToast("HTML report compiled and downloaded successfully!");
  };

  const getSeverityClass = (sev: string) => {
    if (sev === 'Critical') return 'sev-critical';
    if (sev === 'High') return 'sev-high';
    if (sev === 'Medium') return 'sev-medium';
    return 'sev-low';
  };

  return (
    <div className="report-grid">
      {/* Toast Notification */}
      {toastMessage && (
        <div id="toast" className="notification-toast active">
          <AlertTriangle style={{ width: '20px', height: '20px' }} />
          <span>{toastMessage}</span>
        </div>
      )}

      {/* Report metadata details & findings list */}
      <div className="glass-card">
        <h2 className="form-section-title" style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <FilePlus style={{ color: 'var(--color-accent)' }} />
          Project Scope & Selected Findings
        </h2>
        
        <div className="form-group">
          <label htmlFor="rep-project">Project Name</label>
          <input
            type="text"
            id="rep-project"
            className="form-control"
            value={projectName}
            onChange={(e) => setProjectName(e.target.value)}
            placeholder="e.g. Cetus AMM Core"
          />
        </div>
        
        <div style={{ display: 'grid', gridTemplateColumns: '1.2fr 0.8fr', gap: '1.25rem' }}>
          <div className="form-group">
            <label htmlFor="rep-hash">Audited Commit Hash</label>
            <input
              type="text"
              id="rep-hash"
              className="form-control"
              value={commitHash}
              onChange={(e) => setCommitHash(e.target.value)}
              placeholder="e.g. 8f12a3d..."
            />
          </div>
          <div className="form-group">
            <label htmlFor="rep-network">Target Network</label>
            <select
              id="rep-network"
              className="form-control"
              value={network}
              onChange={(e) => setNetwork(e.target.value)}
            >
              <option value="Sui Mainnet">Sui Mainnet</option>
              <option value="Sui Testnet">Sui Testnet</option>
              <option value="Both Mainnet/Testnet">Both</option>
            </select>
          </div>
        </div>

        <div className="form-group">
          <label htmlFor="rep-scope">Audit Scope Files</label>
          <input
            type="text"
            id="rep-scope"
            className="form-control"
            value={scope}
            onChange={(e) => setScope(e.target.value)}
            placeholder="e.g. sources/*.move"
          />
        </div>

        <h3 className="section-subtitle" style={{ marginTop: '1.75rem', marginBottom: '0.85rem', display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
          <ListChecks style={{ width: '16px', height: '16px' }} /> Compilation Findings ({total})
        </h3>
        
        <div className="cart-list" id="report-cart-list">
          {reportCart.length === 0 ? (
            <div className="cart-empty">
              Your report compilation cart is empty. Browse the &quot;BVSS Scorecard&quot; or &quot;Vuln Playbook&quot; tabs to add security findings.
            </div>
          ) : (
            reportCart.map((item) => (
              <div key={item.id} className="cart-item" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div className="cart-item-info">
                  <span className="cart-item-title" style={{ fontWeight: 600 }}>{item.name}</span>
                  <div className="cart-item-meta" style={{ display: 'flex', gap: '0.5rem', alignItems: 'center', marginTop: '0.25rem' }}>
                    <span className="vuln-card-id" style={{ fontSize: '0.7rem' }}>{item.id}</span>
                    <span className={`vuln-card-badge ${getSeverityClass(item.severity)}`} style={{ fontSize: '0.6rem', padding: '0.15rem 0.4rem' }}>
                      {item.severity} ({item.score.toFixed(1)})
                    </span>
                  </div>
                </div>
                <button
                  className="cart-item-remove"
                  onClick={() => removeFromCart(item.id)}
                  style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--color-critical)', padding: '0.5rem' }}
                >
                  <Trash2 style={{ width: '16px', height: '16px' }} />
                </button>
              </div>
            ))
          )}
        </div>
      </div>

      {/* Report Statistics & Compilation */}
      <div className="glass-card">
        <h2 className="form-section-title" style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <LineChart style={{ color: 'var(--color-low)' }} />
          Report Statistics & Compilation
        </h2>

        {/* Dynamic counts statistic grids */}
        <div className="summary-stats-box">
          <div className="summary-stat-item">
            <div className="summary-stat-val" id="rep-stat-total">{total}</div>
            <div className="summary-stat-lbl">Findings</div>
          </div>
          <div className="summary-stat-item">
            <div className="summary-stat-val" id="rep-stat-avg">{avgScore.toFixed(1)}</div>
            <div className="summary-stat-lbl">Avg Score</div>
          </div>
          <div className="summary-stat-item">
            <div
              className="summary-stat-val"
              id="rep-stat-level"
              style={{
                fontSize: '1.15rem',
                fontWeight: 800,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                height: '2.2rem',
                color: riskColor,
                transition: 'color 0.3s ease'
              }}
            >
              {riskRating}
            </div>
            <div className="summary-stat-lbl">Risk Rating</div>
          </div>
        </div>

        {/* Progress bar count distributions */}
        <div className="severity-chart-wrapper">
          <span style={{ fontSize: '0.75rem', textTransform: 'uppercase', letterSpacing: '1px', color: 'var(--text-secondary)', display: 'block', marginBottom: '0.75rem', fontWeight: 700 }}>
            Findings Severity Distribution:
          </span>
          
          <div className="chart-row">
            <div className="chart-row-lbl" style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.8rem', marginBottom: '0.25rem' }}>
              <span>Critical (🔴)</span>
              <span id="lbl-cnt-critical">{criticalCount}</span>
            </div>
            <div className="chart-bar-bg" style={{ background: 'rgba(255,255,255,0.05)', borderRadius: '4px', height: '8px', overflow: 'hidden' }}>
              <div
                className="chart-bar-fill"
                id="bar-critical"
                style={{ width: `${criticalCount * chartScale}%`, backgroundColor: 'var(--color-critical)', height: '100%', transition: 'width 0.3s ease' }}
              ></div>
            </div>
          </div>

          <div className="chart-row" style={{ marginTop: '0.75rem' }}>
            <div className="chart-row-lbl" style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.8rem', marginBottom: '0.25rem' }}>
              <span>High (🟠)</span>
              <span id="lbl-cnt-high">{highCount}</span>
            </div>
            <div className="chart-bar-bg" style={{ background: 'rgba(255,255,255,0.05)', borderRadius: '4px', height: '8px', overflow: 'hidden' }}>
              <div
                className="chart-bar-fill"
                id="bar-high"
                style={{ width: `${highCount * chartScale}%`, backgroundColor: 'var(--color-high)', height: '100%', transition: 'width 0.3s ease' }}
              ></div>
            </div>
          </div>

          <div className="chart-row" style={{ marginTop: '0.75rem' }}>
            <div className="chart-row-lbl" style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.8rem', marginBottom: '0.25rem' }}>
              <span>Medium (🟡)</span>
              <span id="lbl-cnt-medium">{mediumCount}</span>
            </div>
            <div className="chart-bar-bg" style={{ background: 'rgba(255,255,255,0.05)', borderRadius: '4px', height: '8px', overflow: 'hidden' }}>
              <div
                className="chart-bar-fill"
                id="bar-medium"
                style={{ width: `${mediumCount * chartScale}%`, backgroundColor: 'var(--color-medium)', height: '100%', transition: 'width 0.3s ease' }}
              ></div>
            </div>
          </div>

          <div className="chart-row" style={{ marginTop: '0.75rem' }}>
            <div className="chart-row-lbl" style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.8rem', marginBottom: '0.25rem' }}>
              <span>Low (🟢)</span>
              <span id="lbl-cnt-low">{lowCount}</span>
            </div>
            <div className="chart-bar-bg" style={{ background: 'rgba(255,255,255,0.05)', borderRadius: '4px', height: '8px', overflow: 'hidden' }}>
              <div
                className="chart-bar-fill"
                id="bar-low"
                style={{ width: `${lowCount * chartScale}%`, backgroundColor: 'var(--color-low)', height: '100%', transition: 'width 0.3s ease' }}
              ></div>
            </div>
          </div>
        </div>

        {/* Export Actions buttons */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem', marginTop: '1.5rem' }}>
          <button className="btn btn-outline" onClick={handleCopyMarkdown} style={{ display: 'inline-flex', alignItems: 'center', gap: '0.4rem', justifyContent: 'center' }}>
            <Copy style={{ width: '16px', height: '16px' }} /> Copy Markdown
          </button>
          <button className="btn" onClick={handleDownloadHTML} style={{ display: 'inline-flex', alignItems: 'center', gap: '0.4rem', justifyContent: 'center' }}>
            <Download style={{ width: '16px', height: '16px' }} /> Download HTML Report
          </button>
        </div>

        {/* Realtime Report preview panel */}
        <div className="report-preview-box" style={{ marginTop: '1.5rem' }}>
          <span style={{ fontSize: '0.75rem', fontWeight: 700, color: 'var(--text-secondary)', textTransform: 'uppercase', display: 'block', marginBottom: '0.5rem' }}>
            Live Compilation Markdown Output:
          </span>
          <textarea
            id="report-preview-text"
            className="report-textarea"
            style={{ width: '100%', minHeight: '200px', fontFamily: 'var(--font-mono)', fontSize: '0.8rem' }}
            readOnly
            placeholder="Compilation markdown will dynamically regenerate when selected findings change..."
            value={markdownOutput}
          />
        </div>
      </div>
    </div>
  );
}
