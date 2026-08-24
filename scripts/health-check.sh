#!/bin/bash
set -euo pipefail

LOG="/var/log/infralab/health-check.log"

install -d -m 0750 "$(dirname "$LOG")"

{
    echo "========================================"
    echo "InfraLab Health Check - $(date)"
    echo "========================================"

    echo
    echo "[HOST]"
    hostname

    echo
    echo "[UPTIME]"
    uptime

    echo
    echo "[DISK]"
    df -h /

    echo
    echo "[MEMORY]"
    free -h

    echo
    echo "[NETWORK]"
    ip -br addr

    echo
    echo "[ROUTES]"
    ip route

    echo
    echo "[NFTABLES]"
    systemctl is-active nftables

    echo
} >> "$LOG"
