# Changelog

## v1.0.0 — Initial InfraLab build

- Nested Proxmox VE environment on VMware Workstation.
- Debian `lab-router`.
- VLAN 20 server network.
- VLAN 30 monitoring network.
- IPv4 forwarding and NAT.
- Default-drop nftables forwarding policy.
- Management-network isolation.
- Zabbix 7.4 monitoring stack with PostgreSQL 17.
- Zabbix Agent 2 on `app01` and `app02`.
- Deliberate monitoring failure and recovery test.
- Packet-level DNS/firewall troubleshooting with `tcpdump`.
- Daily health-check, configuration-backup, and update-check timers.
- Router reboot and persistence validation.
