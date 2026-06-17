"use client";

import React, { useState } from 'react';
import hljs from 'highlight.js';
import 'highlight.js/styles/github-dark.css'; // Load highlight.js dark theme styles
import { Search, BookOpen, Info, AlertCircle, Code2, Link as LinkIcon, PlusCircle, AlertTriangle, ShieldAlert, ExternalLink } from 'lucide-react';
import { loadVulns } from '../../lib/data';
import { Vuln, ReportEntry } from '../../lib/types';
import { useReport } from '../../context/ReportContext';

export default function PlaybookPage() {
  const vulns = loadVulns();
  const { addToCart } = useReport();

  // Search and filter states
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [activeCategory, setActiveCategory] = useState<string>('ALL');
  const [activePlaybookId, setActivePlaybookId] = useState<string | null>(
    vulns.length > 0 ? vulns[0].id : null
  );
  
  // Comparative sandbox tab state: 'split' | 'tab-vuln' | 'tab-fixed'
  const [sandboxMode, setSandboxMode] = useState<'split' | 'tab-vuln' | 'tab-fixed'>('split');

  // Toast state
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => {
      setToastMessage(null);
    }, 3000);
  };

  // Filter vulnerabilities list
  const filteredVulns = vulns.filter(v => {
    const matchSearch =
      v.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      v.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (v.description && v.description.toLowerCase().includes(searchQuery.toLowerCase()));

    const matchCategory =
      activeCategory === 'ALL' ||
      (v.category && v.category.toUpperCase() === activeCategory);

    return matchSearch && matchCategory;
  });

  // Sort: Critical (4) > High (3) > Medium (2) > Low (1)
  const severityOrder = { Critical: 4, High: 3, Medium: 2, Low: 1 };
  filteredVulns.sort((a, b) => {
    const aOrder = severityOrder[a.severity] || 0;
    const bOrder = severityOrder[b.severity] || 0;
    return bOrder - aOrder;
  });

  // Current active vulnerability
  const activeVuln = vulns.find(v => v.id === activePlaybookId) || filteredVulns[0];

  const handleAddPlaybookToReport = (vuln: Vuln) => {
    const score = vuln.bvss?.isImmutable !== undefined 
      ? (vuln.severity === 'Critical' ? 9.8 : vuln.severity === 'High' ? 7.8 : 4.8)
      : 5.0; // Fallback score estimation

    const entry: ReportEntry = {
      id: vuln.id,
      name: vuln.name,
      severity: vuln.severity,
      score: score,
      description: vuln.description,
      code_vuln: vuln.code_vuln,
      code_fixed: vuln.code_fixed,
      references: vuln.references
    };

    const added = addToCart(entry);
    if (added) {
      showToast(`Added ${vuln.id} to report cart.`);
    } else {
      showToast("Finding already included in report cart!");
    }
  };

  const getSeverityClass = (sev: string) => {
    if (sev === 'Critical') return 'sev-critical';
    if (sev === 'High') return 'sev-high';
    if (sev === 'Medium') return 'sev-medium';
    return 'sev-low';
  };

  // Safe highlighted code helper
  const renderCodeBlock = (code: string) => {
    try {
      const highlighted = hljs.highlight(code || '// No code sample available', { language: 'rust' }).value;
      return <code className="language-rust" dangerouslySetInnerHTML={{ __html: highlighted }} />;
    } catch (e) {
      return <code>{code}</code>;
    }
  };

  return (
    <div className="grid-playbook">
      {/* Toast Notification */}
      {toastMessage && (
        <div id="toast" className="notification-toast active">
          <AlertTriangle style={{ width: '20px', height: '20px' }} />
          <span>{toastMessage}</span>
        </div>
      )}

      {/* Sidebar: Search & Filtered List */}
      <div className="glass-card" style={{ padding: '1.5rem' }}>
        <div className="search-container">
          <Search className="search-icon" style={{ width: '16px', height: '16px' }} />
          <input
            type="text"
            className="form-control search-input"
            placeholder="Search vulnerabilities..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>

        <div className="category-filters" style={{ flexWrap: 'wrap', gap: '0.25rem' }}>
          {['ALL', 'SUI', 'ACC', 'MTH', 'ORC', 'DOS', 'LOG'].map(cat => (
            <button
              key={cat}
              className={`filter-btn ${activeCategory === cat ? 'active' : ''}`}
              onClick={() => {
                setActiveCategory(cat);
                setActivePlaybookId(null); // Reset active selection on category change
              }}
            >
              {cat}
            </button>
          ))}
        </div>

        <div className="vuln-list-wrapper">
          {filteredVulns.length === 0 ? (
            <div className="cart-empty" style={{ fontSize: '0.8rem', padding: '1.5rem' }}>
              No vulnerabilities loaded.
            </div>
          ) : (
            filteredVulns.map(v => (
              <div
                key={v.id}
                className={`vuln-card ${activeVuln?.id === v.id ? 'active' : ''}`}
                onClick={() => setActivePlaybookId(v.id)}
                style={{ cursor: 'pointer' }}
              >
                <div className="vuln-card-header">
                  <span className="vuln-card-id">{v.id}</span>
                  <span className={`vuln-card-badge ${getSeverityClass(v.severity)}`}>
                    {v.severity}
                  </span>
                </div>
                <div className="vuln-card-title">{v.name}</div>
              </div>
            ))
          )}
        </div>
      </div>

      {/* Right Detail Workspace panel */}
      <div className="glass-card playbook-detail">
        {!activeVuln ? (
          <div className="cart-empty" style={{ padding: '6rem', border: 'none' }}>
            <BookOpen style={{ width: '48px', height: '48px', color: 'var(--text-muted)', marginBottom: '1rem' }} />
            <p>Select a vulnerability entry from the list to view risk details, technical impacts, and comparative Move source codes (Vulnerable vs Safe).</p>
          </div>
        ) : (
          <div>
            <div className="detail-header">
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: '1rem', flexWrap: 'wrap' }}>
                <div>
                  <span className="vuln-card-id" style={{ fontSize: '0.95rem' }}>{activeVuln.id}</span>
                  <h2 style={{ fontSize: '1.55rem', fontWeight: 800, color: 'var(--text-primary)', marginTop: '0.25rem' }}>
                    {activeVuln.name}
                  </h2>
                </div>
                <span className={`severity-badge ${getSeverityClass(activeVuln.severity)}`} style={{ display: 'inline-flex', alignItems: 'center', gap: '0.4rem' }}>
                  <ShieldAlert style={{ width: '16px', height: '16px' }} />
                  {activeVuln.severity} (
                  {(activeVuln.bvss?.isImmutable !== undefined 
                    ? (activeVuln.severity === 'Critical' ? 9.8 : activeVuln.severity === 'High' ? 7.8 : 4.8)
                    : 5.0
                  ).toFixed(1)} / 10)
                </span>
              </div>
            </div>

            <div className="detail-meta-grid">
              <div className="detail-meta-item">
                <div className="detail-meta-label">Recorded Date</div>
                <div className="detail-meta-value">{activeVuln.date || 'N/A'}</div>
              </div>
              <div className="detail-meta-item">
                <div className="detail-meta-label">Estimated Loss</div>
                <div className="detail-meta-value" style={{ color: 'var(--color-critical)' }}>
                  {activeVuln.loss || 'N/A'}
                </div>
              </div>
              <div className="detail-meta-item">
                <div className="detail-meta-label">Platform Specificity</div>
                <div className="detail-meta-value">
                  {activeVuln.sui_specific ? 'Sui Move Specific' : 'General smart contract'}
                </div>
              </div>
            </div>

            <h3 className="section-subtitle" style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
              <Info style={{ width: '16px', height: '16px' }} /> Technical Description
            </h3>
            <p style={{ fontSize: '0.92rem', lineHeight: 1.6, color: 'var(--text-secondary)', marginBottom: '1.5rem', whiteSpace: 'pre-line' }}>
              {activeVuln.description || 'No details available.'}
            </p>
            
            {activeVuln.impact && (
              <>
                <h3 className="section-subtitle" style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                  <AlertCircle style={{ width: '16px', height: '16px' }} /> Protocol Impact
                </h3>
                <p style={{
                  fontSize: '0.9rem',
                  lineHeight: 1.5,
                  color: 'var(--text-secondary)',
                  marginBottom: '1.5rem',
                  background: 'rgba(30,41,59,0.25)',
                  padding: '0.75rem 1.15rem',
                  borderRadius: '8px',
                  borderLeft: '3px solid var(--color-accent)'
                }}>
                  {activeVuln.impact}
                </p>
              </>
            )}

            {/* Code comparative view tab control */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.75rem', marginTop: '1.5rem', flexWrap: 'wrap', gap: '0.5rem' }}>
              <h3 className="section-subtitle" style={{ margin: 0, display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                <Code2 style={{ width: '16px', height: '16px' }} /> Comparative Code Sandbox
              </h3>
              <div style={{ display: 'flex', gap: '0.25rem', fontSize: '0.7rem' }}>
                <button
                  className={`filter-btn ${sandboxMode === 'split' ? 'active' : ''}`}
                  onClick={() => setSandboxMode('split')}
                >
                  Side-by-Side
                </button>
                <button
                  className={`filter-btn ${sandboxMode === 'tab-vuln' ? 'active' : ''}`}
                  onClick={() => setSandboxMode('tab-vuln')}
                >
                  Vulnerable Code
                </button>
                <button
                  className={`filter-btn ${sandboxMode === 'tab-fixed' ? 'active' : ''}`}
                  onClick={() => setSandboxMode('tab-fixed')}
                >
                  Audited Fix
                </button>
              </div>
            </div>

            {/* Snippet Playground */}
            <div id="snippet-playground-area">
              {sandboxMode === 'split' && (
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }} className="mobile-stack">
                  <div>
                    <div className="snippet-tabs">
                      <div className="snippet-tab-btn active tab-vuln" style={{ display: 'inline-flex', alignItems: 'center', gap: '0.3rem' }}>
                        <AlertCircle style={{ width: '12px', height: '12px', color: 'var(--color-critical)' }} /> Vulnerable Snippet
                      </div>
                    </div>
                    <div className="code-container">
                      <pre>
                        {renderCodeBlock(activeVuln.code_vuln)}
                      </pre>
                    </div>
                  </div>
                  <div>
                    <div className="snippet-tabs">
                      <div className="snippet-tab-btn active tab-fixed" style={{ display: 'inline-flex', alignItems: 'center', gap: '0.3rem' }}>
                        <PlusCircle style={{ width: '12px', height: '12px', color: 'var(--color-low)' }} /> Secured & Audited Patch
                      </div>
                    </div>
                    <div className="code-container">
                      <pre>
                        {renderCodeBlock(activeVuln.code_fixed)}
                      </pre>
                    </div>
                  </div>
                </div>
              )}

              {sandboxMode === 'tab-vuln' && (
                <div>
                  <div className="snippet-tabs">
                    <div className="snippet-tab-btn active tab-vuln" style={{ display: 'inline-flex', alignItems: 'center', gap: '0.3rem' }}>
                      <AlertCircle style={{ width: '14px', height: '14px', color: 'var(--color-critical)' }} /> Vulnerable Move Snippet
                    </div>
                  </div>
                  <div className="code-container">
                    <pre>
                      {renderCodeBlock(activeVuln.code_vuln)}
                    </pre>
                  </div>
                </div>
              )}

              {sandboxMode === 'tab-fixed' && (
                <div>
                  <div className="snippet-tabs">
                    <div className="snippet-tab-btn active tab-fixed" style={{ display: 'inline-flex', alignItems: 'center', gap: '0.3rem' }}>
                      <PlusCircle style={{ width: '14px', height: '14px', color: 'var(--color-low)' }} /> Secured & Audited Patch
                    </div>
                  </div>
                  <div className="code-container">
                    <pre>
                      {renderCodeBlock(activeVuln.code_fixed)}
                    </pre>
                  </div>
                </div>
              )}
            </div>

            <h3 className="section-subtitle" style={{ marginTop: '1.75rem', display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
              <LinkIcon style={{ width: '16px', height: '16px' }} /> References & Materials
            </h3>
            <ul className="references-list">
              {activeVuln.references && activeVuln.references.length > 0 ? (
                activeVuln.references.map((r, i) => (
                  <li key={i} style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                    <ExternalLink style={{ width: '14px', height: '14px', color: 'var(--text-muted)' }} />
                    <a href={r} target="_blank" rel="noreferrer">
                      {r}
                    </a>
                  </li>
                ))
              ) : (
                <li>No documentation references attached.</li>
              )}
            </ul>

            <div style={{ marginTop: '2rem', paddingTop: '1.5rem', borderTop: '1px solid var(--border-subtle)' }}>
              <button className="btn btn-success" onClick={() => handleAddPlaybookToReport(activeVuln)} style={{ display: 'inline-flex', alignItems: 'center', gap: '0.4rem' }}>
                <PlusCircle /> Add This Finding to Report
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
