# Monitoring

## Stack

`zabbix01` runs:

- Zabbix Server 7.4
- PostgreSQL 17
- Nginx
- PHP-FPM
- Zabbix Agent 2

The application containers run Zabbix Agent 2.

## Agent configuration

`app01`:

```ini
Server=10.30.0.10
ServerActive=10.30.0.10
Hostname=app01
```

`app02` uses the same server addresses with `Hostname=app02`.

## Connectivity checks

From `zabbix01`:

```bash
zabbix_get -s 10.20.0.11 -p 10050 -k agent.ping
zabbix_get -s 10.20.0.12 -p 10050 -k agent.ping
```

Both returned:

```text
1
```

## Failure simulation

On `app02`:

```bash
systemctl stop zabbix-agent2
```

Zabbix raised:

```text
Linux: Zabbix agent is not available (for 3m)
```

The agent was then restarted and monitoring recovered.

This validated both collection and alerting behavior.
