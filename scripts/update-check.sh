#!/bin/bash
set -euo pipefail

LOG="/var/log/infralab/update-check.log"

install -d -m 0750 "$(dirname "$LOG")"

{
    echo "========================================"
    echo "InfraLab Update Check - $(date)"
    echo "========================================"

    apt update -qq

    echo
    echo "[UPGRADABLE PACKAGES]"
    apt list --upgradable 2>/dev/null

    echo
} >> "$LOG" 2>&1
