import { Vuln } from './types';
import vulnsData from '../data/vulns.json';
import configData from '../data/config.json';

// Injected category resolver mapping vuln IDs to their respective tabs:
// SUI, ACC, MTH, ORC, DOS, LOG
const categoryMap: Record<string, string> = {
  // Oracle
  agent_btcfi_oracle_manip: 'ORC',
  oracle_manipulation: 'ORC',
  typus_oracle_bypass: 'ORC',

  // Access Control / Permissions
  agent_delegated_cap_misuse: 'ACC',
  agent_kiosk_bypass: 'ACC',
  agent_spend_limit_bypass: 'ACC',
  agent_unauthorized_tool_call: 'ACC',
  bluemove_access_bypass: 'ACC',

  // Math Shifting / Numerical
  cetus_spoof_overflow: 'MTH',
  souffl3_math_error: 'MTH',

  // Denial of Service / Race Conditions
  agent_shared_object_race: 'DOS',
  hamsterwheel_dos: 'DOS',
  shared_object_race_mysticeti: 'DOS',
  upgrade_abort: 'DOS',

  // Specific SUI Move APIs / Architecture
  dynamic_field_collision: 'SUI',
  seal_misuse: 'SUI',

  // Logic errors, intent verification, other agent specific logic
  agent_intent_mismatch: 'LOG',
  agent_memory_poisoning: 'LOG',
  agent_multi_consensus_failure: 'LOG',
  agent_no_verifiable_intent: 'LOG',
  agent_side_channel_leak: 'LOG',
  agent_tee_tampering: 'LOG',
  agent_unaudited_lib_vuln: 'LOG',
  agent_zk_intent_leak: 'LOG',
  fake_token_spoofing: 'LOG',
  nautilus_tee_bypass: 'LOG',
  nemo_economic_logic: 'LOG',
  unaudited_lib_inheritance: 'LOG',
  upgrade_migration_corruption: 'LOG',
  zk_intent_replay: 'LOG'
};

export function loadVulns(): Vuln[] {
  return (vulnsData as any[]).map(v => ({
    ...v,
    category: categoryMap[v.id] || 'LOG' // Fallback to LOG if not mapped
  })) as Vuln[];
}

export function loadConfig(): any {
  return configData;
}
