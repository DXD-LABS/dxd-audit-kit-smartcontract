"use client";

import React, { createContext, useContext, useState, useEffect } from 'react';
import { ReportEntry } from '../lib/types';

interface ReportContextType {
  reportCart: ReportEntry[];
  addToCart: (entry: ReportEntry) => boolean;
  removeFromCart: (id: string) => void;
  clearCart: () => void;
}

const ReportContext = createContext<ReportContextType | undefined>(undefined);

export function ReportProvider({ children }: { children: React.ReactNode }) {
  const [reportCart, setReportCart] = useState<ReportEntry[]>([]);
  const [isLoaded, setIsLoaded] = useState(false);

  // Load from localStorage on client mount
  useEffect(() => {
    try {
      const saved = localStorage.getItem('dxd_report_cart');
      if (saved) {
        setReportCart(JSON.parse(saved));
      }
    } catch (e) {
      console.error('Failed to load report cart from localStorage', e);
    }
    setIsLoaded(true);
  }, []);

  // Save to localStorage whenever cart changes
  useEffect(() => {
    if (!isLoaded) return;
    try {
      localStorage.setItem('dxd_report_cart', JSON.stringify(reportCart));
    } catch (e) {
      console.error('Failed to save report cart to localStorage', e);
    }
  }, [reportCart, isLoaded]);

  const addToCart = (entry: ReportEntry): boolean => {
    if (reportCart.some(item => item.id === entry.id)) {
      return false; // Already exists
    }
    setReportCart(prev => [...prev, entry]);
    return true;
  };

  const removeFromCart = (id: string) => {
    setReportCart(prev => prev.filter(item => item.id !== id));
  };

  const clearCart = () => {
    setReportCart([]);
  };

  return (
    <ReportContext.Provider value={{ reportCart, addToCart, removeFromCart, clearCart }}>
      {children}
    </ReportContext.Provider>
  );
}

export function useReport() {
  const context = useContext(ReportContext);
  if (!context) {
    throw new Error('useReport must be used within a ReportProvider');
  }
  return context;
}
