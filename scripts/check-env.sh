#!/bin/bash

# DXD Audit Kit - Environment Check Script
# Validates the toolchain required for reproducible audits.

REQUIRED_SUI_VERSION="1.64.2"
REQUIRED_PYTHON_VERSION="3.10"

echo "------------------------------------------------"
echo "DXD Audit Kit - Environment Check"
echo "------------------------------------------------"

# 1. Check Git
if ! command -v git &> /dev/null; then
    echo "[!] Git is not installed. Please install Git."
    exit 1
else
    echo "[+] Git detected: $(git --version)"
fi

# 2. Check Sui CLI
if ! command -v sui &> /dev/null; then
    echo "[!] Sui CLI is not installed. Please install Sui CLI."
    exit 1
else
    SUI_VERSION_OUT=$(sui --version)
    echo "[+] Sui CLI detected: $SUI_VERSION_OUT"
    
    if [[ $SUI_VERSION_OUT == *"$REQUIRED_SUI_VERSION"* ]]; then
        echo "[+] Sui CLI version matches requirement ($REQUIRED_SUI_VERSION)."
    else
        echo "[!] ERROR: Sui CLI version does not match REQUIRED $REQUIRED_SUI_VERSION."
        echo "           Current: $SUI_VERSION_OUT"
        echo "           Please install the correct version to ensure audit reproducibility."
        exit 1
    fi
fi

# 3. Check Python
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        echo "[!] Python is not installed. Please install Python $REQUIRED_PYTHON_VERSION+."
        exit 1
    else
        PYTHON_CMD="python"
    fi
else
    PYTHON_CMD="python3"
fi

PYTHON_VERSION_OUT=$($PYTHON_CMD --version)
echo "[+] Python detected: $PYTHON_VERSION_OUT"

# 4. Check PyYAML (required for vuln-db parser)
if ! $PYTHON_CMD -c "import yaml" &> /dev/null; then
    echo "[!] PyYAML not found. Please run: pip install PyYAML"
else
    echo "[+] PyYAML detected."
fi

echo "------------------------------------------------"
echo "[OK] Environment check complete."
