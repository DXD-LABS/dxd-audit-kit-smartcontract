"use client";

import React, { useState, useEffect } from 'react';
import { Settings, PlusCircle, AlertTriangle } from 'lucide-react';
import { calculateBVSS } from '../../lib/calculator';
import { loadConfig } from '../../lib/data';
import { BVSSParams, ReportEntry } from '../../lib/types';
import { useReport } from '../../context/ReportContext';

export default function ScorecardPage() {
  const config = loadConfig();
  const { addToCart } = useReport();

  // Scorecard input states
  const [impact, setImpact] = useState<BVSSParams['impact']>('High');
  const [likelihood, setLikelihood] = useState<BVSSParams['likelihood']>('Medium');
  const [exploitability, setExploitability] = useState<BVSSParams['exploitability']>('Network');
  const [economicLoss, setEconomicLoss] = useState<BVSSParams['economicLoss']>('Millions');
  const [scope, setScope] = useState<BVSSParams['scope']>('Unchanged');
  const [exploitMaturity, setExploitMaturity] = useState<BVSSParams['exploitMaturity']>('POC');
  const [privilegedAccess, setPrivilegedAccess] = useState<BVSSParams['privilegedAccess']>('Not Required');
  const [agentAutonomy, setAgentAutonomy] = useState<BVSSParams['agentAutonomy']>('None');
  const [isImmutable, setIsImmutable] = useState<boolean>(true);
  
  // Custom vulnerability title state
  const [customTitle, setCustomTitle] = useState<string>('');
  
  // Toast state
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const params: Partial<BVSSParams> = {
    impact,
    likelihood,
    exploitability,
    economicLoss,
    scope,
    exploitMaturity,
    privilegedAccess,
    agentAutonomy,
    isImmutable
  };

  // Run calculator
  const result = calculateBVSS(params, config);

  // SVG dashOffset calculation
  const dashOffsetMax = 565.48;
  const calculatedOffset = dashOffsetMax - (result.score / 10) * dashOffsetMax;

  // Determine colors based on severity
  let strokeColor = 'var(--color-low)';
  let severityClass = 'sev-low';
  if (result.severity === 'Critical') {
    strokeColor = 'var(--color-critical)';
    severityClass = 'sev-critical';
  } else if (result.severity === 'High') {
    strokeColor = 'var(--color-high)';
    severityClass = 'sev-high';
  } else if (result.severity === 'Medium') {
    strokeColor = 'var(--color-medium)';
    severityClass = 'sev-medium';
  }

  // Toast helper
  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => {
      setToastMessage(null);
    }, 3000);
  };

  const handleAddCustomFinding = () => {
    const title = customTitle.trim() || 'Manual Security Assessment Finding';
    const uniqueId = `DXD-CUST-${Math.floor(100 + Math.random() * 900)}`;

    const entry: ReportEntry = {
      id: uniqueId,
      name: title,
      severity: result.severity,
      score: result.score,
      description: `Manual risk scorecard assessment: Impact=${impact}, Likelihood=${likelihood}, Exploitability=${exploitability}, EconomicLoss=${economicLoss}, Immutability=${isImmutable}, Maturity=${exploitMaturity}, Privilege=${privilegedAccess}, AI Autonomy=${agentAutonomy}`,
      references: ['https://dxdlabs.io/bvss-scorecard']
    };

    const added = addToCart(entry);
    if (added) {
      showToast(`Custom scorecard metrics saved to report!`);
      setCustomTitle('');
    } else {
      showToast('Finding already included in report cart!');
    }
  };

  return (
    <div className="grid-2col">
      {/* Toast Notification */}
      {toastMessage && (
        <div id="toast" className="notification-toast active">
          <AlertTriangle style={{ width: '20px', height: '20px' }} />
          <span>{toastMessage}</span>
        </div>
      )}

      {/* Scorecard Configuration Options */}
      <div className="glass-card">
        <h2 className="form-section-title" style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <Settings style={{ color: 'var(--color-accent)' }} />
          BVSS Weights Configuration
        </h2>
        
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
          <div className="form-group">
            <label htmlFor="calc-impact">Impact Severity</label>
            <select
              id="calc-impact"
              className="form-control"
              value={impact}
              onChange={(e) => setImpact(e.target.value as BVSSParams['impact'])}
            >
              <option value="Critical">Critical (4.0)</option>
              <option value="High">High (3.0)</option>
              <option value="Medium">Medium (2.0)</option>
              <option value="Low">Low (1.0)</option>
            </select>
          </div>
          
          <div className="form-group">
            <label htmlFor="calc-likelihood">Exploit Likelihood</label>
            <select
              id="calc-likelihood"
              className="form-control"
              value={likelihood}
              onChange={(e) => setLikelihood(e.target.value as BVSSParams['likelihood'])}
            >
              <option value="High">High (3.0)</option>
              <option value="Medium">Medium (2.0)</option>
              <option value="Low">Low (1.0)</option>
            </select>
          </div>
        </div>
        
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
          <div className="form-group">
            <label htmlFor="calc-exploitability">Exploitability Method</label>
            <select
              id="calc-exploitability"
              className="form-control"
              value={exploitability}
              onChange={(e) => setExploitability(e.target.value as BVSSParams['exploitability'])}
            >
              <option value="Network">Network (3.0)</option>
              <option value="Adjacent">Adjacent (2.0)</option>
              <option value="Local">Local (1.0)</option>
            </select>
          </div>
          
          <div className="form-group">
            <label htmlFor="calc-economic">Estimated Economic Loss</label>
            <select
              id="calc-economic"
              className="form-control"
              value={economicLoss}
              onChange={(e) => setEconomicLoss(e.target.value as BVSSParams['economicLoss'])}
            >
              <option value="Billions">Billions (4.0)</option>
              <option value="Millions">Millions (3.0)</option>
              <option value="Thousands">Thousands (2.0)</option>
              <option value="Negligible">Negligible (1.0)</option>
            </select>
          </div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
          <div className="form-group">
            <label htmlFor="calc-scope">Impact Scope</label>
            <select
              id="calc-scope"
              className="form-control"
              value={scope}
              onChange={(e) => setScope(e.target.value as BVSSParams['scope'])}
            >
              <option value="Unchanged">Unchanged (1.0x)</option>
              <option value="Changed">Changed (1.2x)</option>
            </select>
          </div>
          
          <div className="form-group">
            <label htmlFor="calc-maturity">Exploit Maturity</label>
            <select
              id="calc-maturity"
              className="form-control"
              value={exploitMaturity}
              onChange={(e) => setExploitMaturity(e.target.value as BVSSParams['exploitMaturity'])}
            >
              <option value="Active">Active Exploits (1.2x)</option>
              <option value="POC">POC Available (1.0x)</option>
              <option value="Theoretical">Theoretical (0.8x)</option>
            </select>
          </div>
        </div>
        
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.25rem' }}>
          <div className="form-group">
            <label htmlFor="calc-privilege">Privileged Access</label>
            <select
              id="calc-privilege"
              className="form-control"
              value={privilegedAccess}
              onChange={(e) => setPrivilegedAccess(e.target.value as BVSSParams['privilegedAccess'])}
            >
              <option value="Required">Required (0.7x)</option>
              <option value="Not Required">Not Required (1.1x)</option>
            </select>
          </div>
          
          <div className="form-group">
            <label htmlFor="calc-autonomy">AI Agent Autonomy</label>
            <select
              id="calc-autonomy"
              className="form-control"
              value={agentAutonomy}
              onChange={(e) => setAgentAutonomy(e.target.value as BVSSParams['agentAutonomy'])}
            >
              <option value="Full">Full Autonomy (1.5x)</option>
              <option value="Partial">Partial Autonomy (1.2x)</option>
              <option value="None">None (1.0x)</option>
            </select>
          </div>
        </div>

        <div className="form-group">
          <div className="checkbox-container" onClick={() => setIsImmutable(!isImmutable)} style={{ cursor: 'pointer' }}>
            <input
              type="checkbox"
              id="calc-immutable"
              checked={isImmutable}
              onChange={(e) => setIsImmutable(e.target.checked)}
              onClick={(e) => e.stopPropagation()}
            />
            <div>
              <strong style={{ fontSize: '0.85rem', display: 'block', color: 'var(--text-primary)' }}>
                Blockchain Immutability Multiplier (1.5x)
              </strong>
              <span style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>
                Applies additional multiplier penalty due to blockchain's immutable post-deployment state.
              </span>
            </div>
          </div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1.20fr 0.80fr', gap: '0.75rem', marginTop: '1.75rem' }}>
          <div className="form-group" style={{ margin: 0 }}>
            <input
              type="text"
              id="calc-title"
              className="form-control"
              placeholder="Vulnerability Title (e.g. Arithmetic overflow)"
              value={customTitle}
              onChange={(e) => setCustomTitle(e.target.value)}
            />
          </div>
          <button className="btn btn-success" onClick={handleAddCustomFinding} style={{ display: 'inline-flex', alignItems: 'center', gap: '0.3rem', justifyContent: 'center' }}>
            <PlusCircle style={{ width: '16px', height: '16px' }} /> Add to Report
          </button>
        </div>
      </div>

      {/* Animated Radial Gauge score Results */}
      <div className="scorecard-summary-card">
        <span style={{ fontSize: '0.75rem', textTransform: 'uppercase', letterSpacing: '2px', fontWeight: 700, color: 'var(--text-secondary)' }}>
          BVSS Risk Assessment Score
        </span>
        
        <div className="gauge-container">
          <svg className="gauge-svg" width="200" height="200">
            <circle className="gauge-bg" cx="100" cy="100" r="90" />
            <circle
              className="gauge-fill"
              id="gauge-score-fill"
              cx="100"
              cy="100"
              r="90"
              style={{
                strokeDashoffset: calculatedOffset,
                stroke: strokeColor,
                filter: `drop-shadow(0 0 8px ${strokeColor})`,
                transition: 'stroke-dashoffset 0.5s ease-out, stroke 0.5s ease-out'
              }}
            />
          </svg>
          <div className="gauge-label">
            <div className="gauge-score" id="gauge-score-text">{result.score.toFixed(1)}</div>
            <div className="gauge-max">MAX 10.0</div>
          </div>
        </div>

        <div id="calc-severity-badge" className={`severity-badge ${severityClass}`} style={{ display: 'inline-flex', alignItems: 'center', gap: '0.4rem' }}>
          <AlertTriangle style={{ width: '16px', height: '16px' }} /> {result.severity}
        </div>

        {/* Remediation box based on score */}
        <div
          className="recommendation-box"
          id="calc-remedy-box"
          style={{ borderLeftColor: strokeColor, transition: 'border-left-color 0.5s ease' }}
        >
          {result.remedy}
        </div>

        {/* Score Breakdown Matrix */}
        <table className="breakdown-table">
          <thead>
            <tr>
              <th>Metric Component</th>
              <th>Configuration</th>
              <th style={{ textAlign: 'right' }}>Weighted Value</th>
            </tr>
          </thead>
          <tbody id="breakdown-rows">
            <tr>
              <td>BVSS Base Metrics</td>
              <td>Impact ({result.breakdown.impact.label}) &times; Likelihood ({result.breakdown.likelihood.label})</td>
              <td style={{ textAlign: 'right' }}>
                <span className="metric-pill">Base: {result.breakdown.impact.val} / {result.breakdown.likelihood.val}</span>
              </td>
            </tr>
            <tr>
              <td>Exploitability</td>
              <td>{result.breakdown.exploitability.label} access vector</td>
              <td style={{ textAlign: 'right' }}>
                <span className="metric-pill">Mult: {result.breakdown.exploitability.val}x</span>
              </td>
            </tr>
            <tr>
              <td>Economic Loss</td>
              <td>Estimated impact: {result.breakdown.economicLoss.label}</td>
              <td style={{ textAlign: 'right' }}>
                <span className="metric-pill">Val: {result.breakdown.economicLoss.val}</span>
              </td>
            </tr>
            <tr>
              <td>Scope Adjustment</td>
              <td>Impact borders: {result.breakdown.scope.label}</td>
              <td style={{ textAlign: 'right' }}>
                <span className="metric-pill">{result.breakdown.scope.mult}x</span>
              </td>
            </tr>
            <tr>
              <td>Immutability Multiplier</td>
              <td>Blockchain persistent contract</td>
              <td style={{ textAlign: 'right' }}>
                <span className="metric-pill" style={{ color: 'var(--color-medium)' }}>{result.breakdown.isImmutable.mult}x</span>
              </td>
            </tr>
            <tr>
              <td>Exploit Maturity</td>
              <td>Vulnerability status: {result.breakdown.exploitMaturity.label}</td>
              <td style={{ textAlign: 'right' }}>
                <span className="metric-pill">{result.breakdown.exploitMaturity.mult}x</span>
              </td>
            </tr>
            <tr>
              <td>Privileged Access</td>
              <td>Access prerequisite: {result.breakdown.privilegedAccess.label}</td>
              <td style={{ textAlign: 'right' }}>
                <span className="metric-pill">{result.breakdown.privilegedAccess.mult}x</span>
              </td>
            </tr>
            <tr>
              <td>AI Agent Autonomy</td>
              <td>Agent system connection: {result.breakdown.agentAutonomy.label}</td>
              <td style={{ textAlign: 'right' }}>
                <span className="metric-pill" style={{ color: 'var(--color-info)' }}>{result.breakdown.agentAutonomy.mult}x</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}
