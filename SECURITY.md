# Security

InfraLab is a homelab and educational project.

## Secrets

Do not commit:

- database passwords;
- private keys;
- API tokens;
- cookies or browser session data;
- `.env` files containing credentials;
- backup archives containing live configuration secrets.

The repository uses placeholders such as:

```text
<REPLACE_WITH_SECRET>
```

where a real secret would normally be required.

## Addresses

Private RFC1918 addresses are intentionally retained because they document the lab topology.

## Firewall warning

The example nftables configuration can disconnect a host if applied to a different environment without adaptation.

Validate changes locally before applying them to a remotely managed router.

## Vulnerability reports

If this repository is public and you discover a secret or sensitive value that was committed accidentally, remove/rotate the secret before treating the Git history as clean.
