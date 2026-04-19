# DXD-SUI Vulnerability ID Specification

To ensure audit traceability and professional standards, the DXD Audit Kit uses a standardized identification system for all cataloged vulnerabilities.

## ID Structure: `DXD-SUI-YYYY-XXX`

- **`DXD`**: Organization Identifier (DXDLABS).
- **`SUI`**: Ecosystem Identifier (SUI Network).
- **`YYYY`**: The year the vulnerability was discovered, reported, or added to the database.
- **`XXX`**: A 3-digit sequential number starting from `001` each year.

## Categories (Taxonomy)

While not part of the ID string itself to keep it concise, every entry in the `master-list.json` is categorized into:

1.  **ACC**: Access Control (Capabilities, Owner-only functions).
2.  **LOG**: Business Logic (Intent mismatch, state machine errors).
3.  **MTH**: Mathematical Errors (Rounding, overflows, decimals).
4.  **ORC**: Oracle & External Data (Staleness, manipulation).
5.  **FLN**: Flashloans & Price Slippage.
6.  **SUI**: Sui-Specific Patterns (Object dependency, dynamic fields, Kiosks).

## Usage Policy

-   Every YAML entry must have an `id` field matching this specification.
-   IDs are immutable once published in a major release.
-   The `master-list.json` serves as the single source of truth for mapping IDs to PoC files.
