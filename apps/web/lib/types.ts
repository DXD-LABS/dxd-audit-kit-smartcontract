export interface BVSSParams {
  impact: 'Critical' | 'High' | 'Medium' | 'Low';
  likelihood: 'High' | 'Medium' | 'Low';
  exploitability: 'Network' | 'Adjacent' | 'Local';
  economicLoss: 'Billions' | 'Millions' | 'Thousands' | 'Negligible';
  scope: 'Unchanged' | 'Changed';
  isImmutable: boolean;
  exploitMaturity: 'Active' | 'POC' | 'Theoretical';
  privilegedAccess: 'Required' | 'Not Required';
  agentAutonomy: 'None' | 'Partial' | 'Full';
}

export interface MetricBreakdown {
  impact: { label: string; val: number };
  likelihood: { label: string; val: number };
  exploitability: { label: string; val: number };
  economicLoss: { label: string; val: number };
  scope: { label: string; mult: number };
  isImmutable: { active: boolean; mult: number };
  exploitMaturity: { label: string; mult: number };
  privilegedAccess: { label: string; mult: number };
  agentAutonomy: { label: string; mult: number };
  baseScoreRaw: number;
  maxPossible: number;
}

export interface ScoreResult {
  score: number;
  severity: 'Critical' | 'High' | 'Medium' | 'Low';
  color: string;
  breakdown: MetricBreakdown;
  remedy?: string;
}

export interface Vuln {
  id: string;
  name: string;
  name_vi?: string;
  date: string;
  loss: string;
  severity: 'Critical' | 'High' | 'Medium' | 'Low';
  description: string;
  description_vi?: string;
  root_cause: string;
  root_cause_vi?: string;
  mitigation: string;
  mitigation_vi?: string;
  verification?: string;
  verification_vi?: string;
  impact?: string;
  impact_vi?: string;
  code_vuln: string;
  code_fixed: string;
  references: string[];
  sui_specific: boolean;
  bvss: BVSSParams;
  formal_spec?: string;
  category?: string; // Injected dynamically for categorizing playbook listings
}

export interface ReportEntry {
  id: string;
  name: string;
  severity: 'Critical' | 'High' | 'Medium' | 'Low';
  score: number;
  description: string;
  code_vuln?: string;
  code_fixed?: string;
  references?: string[];
}

export interface ScanFinding {
  title: string;
  severity: 'Critical' | 'High' | 'Medium' | 'Low';
  desc: string;
  remedy: string;
  type: 'critical' | 'high' | 'warning' | 'info';
}
