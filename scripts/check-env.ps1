# DXD Audit Kit - Environment Check Script (Windows)
# Validates the toolchain required for reproducible audits.

$REQUIRED_SUI_VERSION = "1.64.2"
$REQUIRED_PYTHON_VERSION = "3.10"

Write-Host "------------------------------------------------" -ForegroundColor Cyan
Write-Host "DXD Audit Kit - Environment Check (Windows)" -ForegroundColor Cyan
Write-Host "------------------------------------------------" -ForegroundColor Cyan

# 1. Check Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    $GIT_VER = git --version
    Write-Host "[+] Git detected: $GIT_VER" -ForegroundColor Green
} else {
    Write-Host "[!] ERROR: Git is not installed. Please install Git." -ForegroundColor Red
    exit 1
}

# 2. Check Sui CLI
if (Get-Command sui -ErrorAction SilentlyContinue) {
    $SUI_VER_OUT = sui --version
    Write-Host "[+] Sui CLI detected: $SUI_VER_OUT" -ForegroundColor Green
    
    if ($SUI_VER_OUT -like "*$REQUIRED_SUI_VERSION*") {
        Write-Host "[+] Sui CLI version matches requirement ($REQUIRED_SUI_VERSION)." -ForegroundColor Green
    } else {
        Write-Host "[!] ERROR: Sui CLI version does not match REQUIRED $REQUIRED_SUI_VERSION." -ForegroundColor Red
        Write-Host "           Current: $SUI_VER_OUT" -ForegroundColor Yellow
        Write-Host "           Please install the correct version to ensure audit reproducibility." -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "[!] ERROR: Sui CLI is not installed. Please install Sui CLI." -ForegroundColor Red
    exit 1
}

# 3. Check Python
$PYTHON_CMD = ""
if (Get-Command python -ErrorAction SilentlyContinue) {
    $PYTHON_CMD = "python"
} elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
    $PYTHON_CMD = "python3"
}

if ($PYTHON_CMD -ne "") {
    $PY_VER = & $PYTHON_CMD --version
    Write-Host "[+] Python detected: $PY_VER" -ForegroundColor Green
} else {
    Write-Host "[!] ERROR: Python is not installed. Please install Python $REQUIRED_PYTHON_VERSION+." -ForegroundColor Red
    exit 1
}

# 4. Check PyYAML
& $PYTHON_CMD -c "import yaml" 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[+] PyYAML detected." -ForegroundColor Green
} else {
    Write-Host "[!] ERROR: PyYAML not found. Please run: pip install PyYAML" -ForegroundColor Red
    exit 1
}

Write-Host "------------------------------------------------" -ForegroundColor Cyan
Write-Host "[OK] Environment check complete." -ForegroundColor Green
