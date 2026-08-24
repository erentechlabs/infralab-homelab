# Validation

## Router reboot test

After reboot, the router was checked with:

```bash
ip -br addr
ip route
sudo systemctl is-active nftables
systemctl is-active infralab-health.timer
systemctl is-active infralab-backup.timer
systemctl is-active infralab-update-check.timer
ping -c 3 1.1.1.1
ping -4 -c 3 deb.debian.org
```

Expected/final state:

- `ens18` UP with `192.168.74.130/24`;
- `ens19` UP;
- `ens19.20` UP with `10.20.0.1/24`;
- `ens19.30` UP with `10.30.0.1/24`;
- default route through the VMware-facing network;
- VLAN 20 and VLAN 30 routes present;
- nftables active;
- all three InfraLab timers active;
- internet and DNS working.

## Zabbix agent validation

From `zabbix01`:

```bash
zabbix_get -s 10.20.0.11 -p 10050 -k agent.ping
zabbix_get -s 10.20.0.12 -p 10050 -k agent.ping
```

Both returned:

```text
1
```

## Management isolation

From `app01`:

```bash
curl -k --connect-timeout 5 --max-time 7 \
  https://192.168.74.128:8006 -o /dev/null
echo $?
```

The timeout and exit code `28` were the expected result.

## Final monitoring state

Zabbix showed:

- `app01` available;
- `app02` available;
- Zabbix server available.

The remaining package-count warnings were expected inventory/change notices following software installation, not service outages.
