# Automation

InfraLab uses small Bash scripts and systemd timers for routine operations.

## Schedule

| Time | Timer | Purpose |
|---|---|---|
| 03:00 | `infralab-health.timer` | Health snapshot |
| 03:15 | `infralab-backup.timer` | Configuration backup |
| 03:30 | `infralab-update-check.timer` | Package update check |

## Health check

[`../scripts/health-check.sh`](../scripts/health-check.sh) records:

- hostname;
- uptime;
- root filesystem usage;
- memory;
- interfaces;
- routes;
- nftables service state.

## Configuration backup

[`../scripts/config-backup.sh`](../scripts/config-backup.sh):

- creates a timestamped `.tar.gz`;
- creates a SHA-256 checksum;
- backs up the selected router configuration;
- removes matching archives older than seven days.

## Update check

[`../scripts/update-check.sh`](../scripts/update-check.sh) refreshes package metadata and records upgradable packages.

## Persistence

All three timers were confirmed active after reboot.
