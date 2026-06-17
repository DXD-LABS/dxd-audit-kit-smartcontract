"use client";

import React, { useState } from 'react';
import { Code, Activity, Sparkles, ClipboardList, CheckCircle, ShieldAlert, AlertTriangle } from 'lucide-react';
import { scanTemplates } from '../../lib/scanner';
import { ScanFinding } from '../../lib/types';

export default function ScannerPage() {
  const [code, setCode] = useState<string>('');
  const [findings, setFindings] = useState<ScanFinding[] | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => {
      setToastMessage(null);
    }, 3000);
  };

  const loadTemplate = (type: keyof typeof scanTemplates) => {
    const template = scanTemplates[type];
    if (template) {
      setCode(template);
    }
  };

  const handleScan = async () => {
    if (!code.trim()) {
      showToast("Please enter or load Move code to start scanning!");
      return;
    }

    showToast("Executing static analysis scanner...");
    setIsLoading(true);
    setFindings(null);

    try {
      const response = await fetch('/api/scan', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ code }),
      });

      if (!response.ok) {
        throw new Error('Scanner API responded with an error');
      }

      const results = await response.json();
      
      // Simulate analysis lag of 800ms to mimic parser load
      setTimeout(() => {
        setFindings(results);
        setIsLoading(false);
        showToast(`Scanner complete. Identified ${results.length} findings.`);
      }, 800);

    } catch (error) {
      console.error('Code scan failed:', error);
      setIsLoading(false);
      showToast('Static scan execution failed.');
    }
  };

  const getSeverityClass = (sev: string) => {
    if (sev === 'Critical') return 'sev-critical';
    if (sev === 'High') return 'sev-high';
    if (sev === 'Medium') return 'sev-medium';
    return 'sev-low';
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

      {/* Move Code Editor Panel */}
      <div className="glass-card scanner-editor-wrapper" style={{ display: 'flex', flexDirection: 'column' }}>
        <h2 className="form-section-title" style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <Code style={{ color: 'var(--color-accent)' }} />
          Sui Move Code Analyzer
        </h2>
        
        <div className="scan-templates-box">
          <span style={{ fontSize: '0.75rem', fontWeight: 700, color: 'var(--text-secondary)', display: 'block', marginBottom: '0.5rem', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
            Load Code Template:
          </span>
          <button className="template-btn" onClick={() => loadTemplate('oracle')}>Oracle Stale Price</button>
          <button className="template-btn" onClick={() => loadTemplate('shift')}>Arithmetic Shift Overflow</button>
          <button className="template-btn" onClick={() => loadTemplate('upgrade')}>Unsecured Upgrade Version</button>
          <button className="template-btn" onClick={() => loadTemplate('flashloan')}>Unchecked Flash Loan</button>
        </div>

        <textarea
          id="scanner-code"
          className="code-textarea"
          style={{ flex: 1, minHeight: '350px', fontFamily: 'var(--font-mono)' }}
          placeholder="// Paste your Sui Move module code here to scan..."
          value={code}
          onChange={(e) => setCode(e.target.value)}
        />
        
        <button className="btn" onClick={handleScan} style={{ marginTop: '1rem', display: 'inline-flex', alignItems: 'center', gap: '0.4rem', justifyContent: 'center' }}>
          <Sparkles style={{ width: '16px', height: '16px' }} /> Scan Move Code
        </button>
      </div>

      {/* Analyzer static findings results */}
      <div className="glass-card" style={{ display: 'flex', flexDirection: 'column' }}>
        <h2 className="form-section-title" style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <Activity style={{ color: 'var(--color-low)' }} />
          Static Scan Results (Findings)
        </h2>
        
        <div className="scan-results-box" id="scan-findings-container" style={{ flex: 1 }}>
          {isLoading && (
            <div className="cart-empty" style={{ padding: '5.5rem', border: 'none' }}>
              <div className="ticker-dot" style={{ display: 'inline-block', width: '12px', height: '12px', marginBottom: '1rem' }}></div>
              <p>Running static analyzer parser...</p>
            </div>
          )}

          {!isLoading && findings === null && (
            <div className="cart-empty" style={{ padding: '5.5rem', border: 'none' }}>
              <ClipboardList style={{ width: '36px', height: '36px', color: 'var(--text-muted)', marginBottom: '1rem' }} />
              <p>Click &quot;Scan Move Code&quot; or load a preset code template to execute the smart contract static analysis engine simulator.</p>
            </div>
          )}

          {!isLoading && findings !== null && findings.length === 0 && (
            <div className="scan-finding-item success" style={{ background: 'rgba(16,185,129,0.05)', border: '1px solid rgba(16,185,129,0.2)', padding: '1.25rem', borderRadius: '8px' }}>
              <div className="scan-finding-header" style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                <span className="scan-finding-title" style={{ color: 'var(--color-low)', display: 'inline-flex', alignItems: 'center', gap: '0.4rem', fontWeight: 700 }}>
                  <CheckCircle style={{ width: '16px', height: '16px' }} /> Module Checked: Secure!
                </span>
                <span className="scan-finding-severity" style={{ background: 'rgba(16, 185, 129, 0.2)', color: 'var(--color-low)', padding: '2px 8px', borderRadius: '4px', fontSize: '0.75rem', fontWeight: 700 }}>
                  SAFE
                </span>
              </div>
              <p className="scan-finding-desc" style={{ fontSize: '0.85rem', color: 'var(--text-secondary)' }}>
                No common SUI Move vulnerability signatures were found. Run comprehensive formal verification proofs in &apos;prover-examples/&apos; using Sui Prover before deployment.
              </p>
            </div>
          )}

          {!isLoading && findings !== null && findings.length > 0 && (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
              {findings.map((f, i) => (
                <div key={i} className={`scan-finding-item ${f.type}`}>
                  <div className="scan-finding-header" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.5rem' }}>
                    <span className="scan-finding-title" style={{ display: 'inline-flex', alignItems: 'center', gap: '0.4rem', fontWeight: 700 }}>
                      <ShieldAlert style={{ width: '16px', height: '16px', color: `var(--color-${f.type})` }} /> {f.title}
                    </span>
                    <span className={`scan-finding-severity ${getSeverityClass(f.severity)}`}>
                      {f.severity}
                    </span>
                  </div>
                  <p className="scan-finding-desc" style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', lineHeight: 1.5 }}>
                    {f.desc}
                  </p>
                  <div style={{ fontSize: '0.75rem', fontWeight: 700, color: 'var(--text-secondary)', marginTop: '0.65rem', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                    Remediation Patch Pattern:
                  </div>
                  <div className="scan-finding-remedy" style={{ background: 'rgba(0,0,0,0.3)', padding: '0.5rem 0.75rem', borderRadius: '4px', marginTop: '0.25rem', fontFamily: 'var(--font-mono)', fontSize: '0.8rem', color: 'var(--color-low)' }}>
                    {f.remedy}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
