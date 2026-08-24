.PHONY: validate bash links nft

validate: bash links
	@echo "Basic InfraLab validation passed."
	@if command -v shellcheck >/dev/null 2>&1; then shellcheck scripts/*.sh; else echo "shellcheck not installed; skipping ShellCheck."; fi
	@if command -v nft >/dev/null 2>&1; then sudo nft -c -f configs/nftables/nftables.conf.example; else echo "nft not installed; skipping nftables parser check."; fi

bash:
	bash -n scripts/health-check.sh
	bash -n scripts/config-backup.sh
	bash -n scripts/update-check.sh

links:
	python3 tools/check_relative_links.py

nft:
	sudo nft -c -f configs/nftables/nftables.conf.example
