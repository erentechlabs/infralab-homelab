# Troubleshooting

This document captures the most useful failures from the build.

## 1. Clone inherited the source IP

`app02` was cloned from `app01` and initially inherited the source network identity.

The clone was corrected to:

- hostname: `app02`;
- IP: `10.20.0.12/24`;
- gateway: `10.20.0.1`;
- VLAN tag: `20`.

**Lesson:** cloning infrastructure also clones identity. Review addressing, hostname, and service identity before starting the clone.

---

## 2. zabbix01 could not reach its own gateway

`zabbix01` returned `Destination Host Unreachable` while trying to reach `10.30.0.1`.

Because the directly connected gateway was unreachable, the failure was below DNS and internet routing.

The container had been attached incorrectly on the Proxmox side. Correcting the bridge/VLAN attachment restored VLAN 30 connectivity.

**Lesson:** when the local gateway is unreachable, inspect Layer 2 attachment before debugging higher layers.

---

## 3. APT repository metadata was “not live until” a future time

Chrony was active and had reachable sources, but the local clock was roughly 5491 seconds slow.

```bash
chronyc makestep
```

After the step, the offset returned near zero and package operations worked normally.

**Lesson:** time synchronization is infrastructure. Repository signatures, TLS, authentication, logs, and monitoring timestamps depend on it.

---

## 4. Nginx was not listening on 8080

Initial checks:

```bash
ss -ltnp | grep 8080
curl -I http://127.0.0.1:8080/
```

showed no listener.

The packaged Zabbix Nginx configuration still had the relevant listener disabled/commented. After enabling it and restarting Nginx/PHP-FPM, the service listened on `0.0.0.0:8080`.

---

## 5. HTTPS was tested against a plain HTTP listener

Testing:

```bash
curl -I https://127.0.0.1:8080/
```

produced an OpenSSL `wrong version number`-style error.

The listener was healthy; it served plain HTTP.

Correct URL:

```text
http://10.30.0.10:8080
```

---

## 6. The Windows route used the wrong next hop

The first route pointed VLAN 30 traffic to the Proxmox management IP instead of the router.

The correct persistent route was:

```text
route -p add 10.30.0.0 mask 255.255.255.0 192.168.74.130
```

**Lesson:** the hypervisor management address is not automatically the gateway for nested networks.

---

## 7. Zabbix locale pre-check failed

The installer reported that `en_US` was not available.

The locale was generated on the server and PHP-FPM/Nginx were restarted. The prerequisite check then passed.

---

## 8. Zabbix frontend installed, server daemon still down

The server log showed:

```text
fe_sendauth: no password supplied
database is down: reconnecting in 10 seconds
```

The PostgreSQL database and schema existed, but the Zabbix server daemon did not yet have its database password configured.

After adding the DB password to the daemon configuration and restarting `zabbix-server`, the dashboard changed from `No` to `Yes`.

**Lesson:** a web installer and its backend daemon can have separate configuration paths.

---

## 9. Agent file was correct, running state was stale

The Agent 2 file allowed `10.30.0.10`, but the log still showed:

```text
connection from "10.30.0.10" rejected, allowed hosts: "127.0.0.1"
```

The daemon had not loaded the new configuration.

```bash
systemctl restart zabbix-agent2
```

From `zabbix01`:

```bash
zabbix_get -s 10.20.0.11 -p 10050 -k agent.ping
```

returned `1`.

---

## 10. zabbix_get was tested from the wrong source

A local test from `app01` failed because the agent allowlist permitted the monitoring server, not arbitrary callers.

Repeating the same query from `zabbix01` worked.

**Lesson:** source address is part of a network test when allowlists are involved.

---

## 11. nftables `!=` logic broke DNS while ping still worked

Incorrect rule:

```nft
ip saddr 10.20.0.0/24 ip daddr != 192.168.74.0/24 oifname "ens18" drop
```

Read literally, this drops destinations that are **not** in the management network — the opposite of the intended policy.

Symptoms:

```bash
ping -c 3 1.1.1.1
```

worked, but:

```bash
getent hosts deb.debian.org
```

did not.

Why ping worked: ICMP matched an earlier allow rule.

Packet capture:

```bash
tcpdump -ni any 'port 53'
```

showed DNS requests arriving on `ens19.20`, proving the application host and resolver were working.

Correct policy:

```nft
ip saddr 10.20.0.0/24 ip daddr 192.168.74.0/24 drop
ip saddr 10.30.0.0/24 ip daddr 192.168.74.0/24 drop

ip saddr 10.20.0.0/24 oifname "ens18" accept
ip saddr 10.30.0.0/24 oifname "ens18" accept
```

After correction, DNS and IPv4 connectivity by hostname recovered.

**Lesson:** rule ordering and comparisons must be read literally. Packet capture is stronger evidence than speculative firewall edits.

---

## 12. Backup timestamp typo

An early manually typed date format produced malformed filenames.

Correct format:

```bash
STAMP="$(date +%Y%m%d-%H%M%S)"
```

The next archive used the intended timestamp format.

---

## 13. AF_VSOCK warning during systemd reload

The nested router occasionally emitted:

```text
systemd-ssh-generator: Failed to query local AF_VSOCK CID:
Cannot assign requested address
```

The custom timers were still enabled, active, scheduled, and persistent after reboot.

It was treated as a non-blocking virtualization-related warning.

---

## Debugging pattern

Across the project, the most effective pattern was:

**symptom → evidence → root cause → fix → validation → lesson**
