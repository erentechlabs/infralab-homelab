# GitHub Publishing Checklist

Before the first push:

- [x] Add the published blog URL to `README.md` when it is available.
- [ ] Confirm the GitHub repository is named `infralab-homelab`, or update the workflow badge URL.
- [ ] Run `make validate`.
- [ ] Review all screenshots one last time for unrelated personal information.
- [ ] Confirm no real password/token/private key exists.
- [ ] Create the repository description:
  `Proxmox-based homelab with VLAN segmentation, Debian routing, nftables, Zabbix, PostgreSQL, troubleshooting, failure simulation and systemd automation.`
- [ ] Add topics: `proxmox`, `homelab`, `linux`, `networking`, `vlan`, `nftables`, `zabbix`, `systemd`, `infrastructure`, `devops`.
- [ ] Push the repository.
- [ ] Confirm the `Validate InfraLab` workflow passes.
- [ ] Optionally create release `v1.0.0`.
