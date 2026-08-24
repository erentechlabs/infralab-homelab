#!/bin/bash
set -euo pipefail

BACKUP_DIR="/var/backups/infralab"
HOST="$(hostname)"
STAMP="$(date +%Y%m%d-%H%M%S)"

ARCHIVE="${BACKUP_DIR}/${HOST}-config-${STAMP}.tar.gz"

mkdir -p "$BACKUP_DIR"

FILES=(
    "/etc/nftables.conf"
    "/etc/network/interfaces"
    "/etc/sysctl.d/99-infralab-router.conf"
    "/etc/systemd/system/infralab-health.service"
    "/etc/systemd/system/infralab-health.timer"
    "/opt/infralab/scripts/health-check.sh"
)

EXISTING_FILES=()

for file in "${FILES[@]}"; do
    if [ -e "$file" ]; then
        EXISTING_FILES+=("$file")
    fi
done

tar -czf "$ARCHIVE" "${EXISTING_FILES[@]}"
sha256sum "$ARCHIVE" > "${ARCHIVE}.sha256"

find "$BACKUP_DIR" -type f \
    \( -name "${HOST}-config-*.tar.gz" -o -name "${HOST}-config-*.tar.gz.sha256" \) \
    -mtime +7 -delete

echo "Backup created: $ARCHIVE"
