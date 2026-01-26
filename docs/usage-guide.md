# Usage Guide: DxDLabs Audit Kit

## EN

### 1) Clone & Install

```bash
git clone https://github.com/DXD-LABS/dxd-audit-kit-smartcontract.git
cd dxd-audit-kit-smartcontract
```

Install Sui CLI (if not installed):

```bash
cargo install --git https://github.com/MystenLabs/sui sui-cli --locked
```

### 2) Run Snippet Tests

```bash
sui move test --path resources/move/
```

### 3) Use Snippets in Your Project

- Copy code from `resources/move/safe/capability-safe.move` (or other snippets).
- Paste into your Move package under `sources/`.
- Run your project tests:

```bash
sui move test --path path/to/your-project/
```

### 4) Run Tools

Quick audit:

```bash
bash resources/move/tools-scripts/run-move-audit.sh
```

Generate report template:

```bash
python resources/move/tools-scripts/generate-report-template.py \
  --template templates/move-audit-report-template-v2.md \
  --output my-report.md
```

### 5) Audit with Checklists

- Open `resources/move/checklists/move-defi-checklist.md`.
- Tick items as you review the code.

Tip: Integrate VSCode snippets JSON to auto-complete safe patterns.

## VI

### 1) Clone & Cai dat

```bash
git clone https://github.com/DXD-LABS/dxd-audit-kit-smartcontract.git
cd dxd-audit-kit-smartcontract
```

Cai Sui CLI (neu chua co):

```bash
cargo install --git https://github.com/MystenLabs/sui sui-cli --locked
```

### 2) Chay test cho snippets

```bash
sui move test --path resources/move/
```

### 3) Dung snippets trong project

- Copy code tu `resources/move/safe/capability-safe.move` (hoac snippet khac).
- Paste vao Move package cua ban trong `sources/`.
- Chay test project:

```bash
sui move test --path path/to/your-project/
```

### 4) Chay tools

Audit nhanh:

```bash
bash resources/move/tools-scripts/run-move-audit.sh
```

Tao report template:

```bash
python resources/move/tools-scripts/generate-report-template.py \
  --template templates/move-audit-report-template-v2.md \
  --output my-report.md
```

### 5) Audit bang checklist

- Mo `resources/move/checklists/move-defi-checklist.md`.
- Tick tung muc khi review code.

Tip: Tich hop VSCode snippets JSON de auto-complete pattern an toan.

## ZH

### 1) Clone & An zhuang

```bash
git clone https://github.com/DXD-LABS/dxd-audit-kit-smartcontract.git
cd dxd-audit-kit-smartcontract
```

An zhuang Sui CLI (ru guo hai mei an zhuang):

```bash
cargo install --git https://github.com/MystenLabs/sui sui-cli --locked
```

### 2) Yun xing snippet tests

```bash
sui move test --path resources/move/
```

### 3) Zai xiang mu zhong shi yong snippets

- Fu zhi `resources/move/safe/capability-safe.move` (huo qi ta snippet).
- Zhan tie dao Move package de `sources/`.
- Yun xing xiang mu tests:

```bash
sui move test --path path/to/your-project/
```

### 4) Yun xing tools

Kuai su audit:

```bash
bash resources/move/tools-scripts/run-move-audit.sh
```

Sheng cheng report template:

```bash
python resources/move/tools-scripts/generate-report-template.py \
  --template templates/move-audit-report-template-v2.md \
  --output my-report.md
```

### 5) Yong checklist audit

- Da kai `resources/move/checklists/move-defi-checklist.md`.
- Zai review shi da gou.

Tip: Zai VSCode zhong ji cheng snippets JSON yi bian kuai su xie an toan pattern.
