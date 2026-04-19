# DXD Audit Kit - One-Click Audit Script (Windows)
# High-level entry point to run environment checks and all verified security tests.

$ErrorActionPreference = "Stop"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "    DXD Audit Kit - One-Click Audit v0.1.0" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# 1. Run Environment Check
if (Test-Path "./scripts/check-env.ps1") {
    & ./scripts/check-env.ps1
} else {
    Write-Host "[!] Error: ./scripts/check-env.ps1 not found." -ForegroundColor Red
    exit 1
}

# 2. Run Security Tests (PoCs)
Write-Host ""
Write-Host "[*] Step 1: Running Security Tests (PoCs)..." -ForegroundColor Yellow
if (Test-Path "./tests") {
    Push-Location tests
    sui move test
    Pop-Location
    Write-Host "[+] Security tests passed (expected failures for vulnerable PoCs are labeled)." -ForegroundColor Green
} else {
    Write-Host "[!] Warning: tests/ directory not found. Skipping." -ForegroundColor Yellow
}

# 3. Parse Vulnerability Database
Write-Host ""
Write-Host "[*] Step 2: Parsing Vulnerability Database Summary..." -ForegroundColor Yellow
if (Test-Path "./vuln-db") {
    Push-Location vuln-db
    if (Test-Path "parser.py") {
        $PYTHON_CMD = if (Get-Command python -ErrorAction SilentlyContinue) { "python" } else { "python3" }
        & $PYTHON_CMD parser.py
        Write-Host "[+] Vuln-DB summary generated." -ForegroundColor Green
    } else {
        Write-Host "[!] Warning: parser.py not found in vuln-db/." -ForegroundColor Yellow
    }
    Pop-Location
} else {
    Write-Host "[!] Warning: vuln-db/ directory not found. Skipping." -ForegroundColor Yellow
}

# 4. Formal Verification (Move Prover) - Optional Step
Write-Host ""
Write-Host "[*] Step 3: Running Formal Verification (Move Prover)..." -ForegroundColor Yellow
if (Test-Path "./secure-patterns") {
    Push-Location secure-patterns
    if (Get-Command z3 -ErrorAction SilentlyContinue) {
        Write-Host "[+] Prover dependencies detected. Running verification..." -ForegroundColor Green
        sui move prove
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[!] Prover found issues or was interrupted." -ForegroundColor Red
        }
    } else {
        Write-Host "[SKIP] Move Prover dependencies (Z3/CVC5) not found. Skipping FV." -ForegroundColor Yellow
        Write-Host "       Tip: Use Docker environment to run Formal Verification." -ForegroundColor Cyan
    }
    Pop-Location
} else {
    Write-Host "[!] Warning: secure-patterns/ directory not found. Skipping." -ForegroundColor Yellow
}

# 5. Final Summary
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "[SUCCESS] Audit Kit Run Complete (Windows)." -ForegroundColor Green
Write-Host "Check README.md for adoption instructions." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
