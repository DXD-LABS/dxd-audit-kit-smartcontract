import React from 'react';
import { ShieldCheck, Cpu, Binary } from 'lucide-react';

interface HeaderProps {
  vulnCount: number;
}

export default function Header({ vulnCount }: HeaderProps) {
  return (
    <header>
      <div className="header-container">
        <div className="logo-section">
          <div className="logo-icon-container">
            <ShieldCheck style={{ width: '24px', height: '24px', color: '#ffffff' }} />
          </div>
          <div className="logo-title">
            <h1>DXD Labs Security Suite</h1>
            <span>Smart Contract Auditing Portal</span>
          </div>
        </div>
        
        <div className="system-ticker">
          <div className="ticker-item">
            <div className="ticker-dot"></div>
            <span>Vulnerability DB: <strong id="ticker-vuln-count">{vulnCount}</strong></span>
          </div>
          <div className="ticker-item">
            <Cpu style={{ width: '14px', height: '14px', color: 'var(--color-accent)' }} />
            <span>Sui CLI: <strong>1.64.2</strong></span>
          </div>
          <div className="ticker-item">
            <Binary style={{ width: '14px', height: '14px', color: '#8b5cf6' }} />
            <span>Formal Verification: <strong>Active</strong></span>
          </div>
        </div>
      </div>
    </header>
  );
}
