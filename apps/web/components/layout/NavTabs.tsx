"use client";

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Sliders, BookOpen, Terminal, FileText } from 'lucide-react';
import { useReport } from '../../context/ReportContext';

export default function NavTabs() {
  const pathname = usePathname();
  const { reportCart } = useReport();

  const navItems = [
    { name: 'BVSS Scorecard', path: '/scorecard', icon: Sliders },
    { name: 'Vuln Playbook', path: '/playbook', icon: BookOpen },
    { name: 'SUI Move Scanner', path: '/scanner', icon: Terminal },
    { name: 'Report Builder', path: '/report', icon: FileText, badge: true },
  ];

  return (
    <div className="tabs-nav">
      {navItems.map((item) => {
        const IconComponent = item.icon;
        const isActive = pathname.startsWith(item.path);

        return (
          <Link
            key={item.path}
            href={item.path}
            className={`tab-btn ${isActive ? 'active' : ''}`}
            style={{ display: 'inline-flex', alignItems: 'center', gap: '0.5rem' }}
          >
            <IconComponent style={{ width: '16px', height: '16px' }} />
            <span>{item.name}</span>
            {item.badge && reportCart.length > 0 && (
              <span
                id="cart-badge"
                style={{
                  background: 'var(--color-accent)',
                  color: 'white',
                  fontSize: '0.7rem',
                  borderRadius: '50%',
                  width: '16px',
                  height: '16px',
                  display: 'inline-flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontWeight: 700,
                }}
              >
                {reportCart.length}
              </span>
            )}
          </Link>
        );
      })}
    </div>
  );
}
