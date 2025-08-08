# Personal Nix Environment

This flake provides a personal Nix environment with global tools (`world`) and a Python development shell. It is intended to simplify tool management and Python development setup across systems.

# Installation

To install the global tools (`world`) permanently to your Nix profile, run:
```bash
# Installs the 'world' package globally from FlakeHub
nix profile install flakehub:guilhermevini/nix#world
```

# Updating

To update your installed tools to the latest version from FlakeHub, run:
```bash
# Upgrades all packages in your profile, fetching the newest flake version
nix profile upgrade '.*'
```

# Development Shell

To enter a temporary development shell with Python, `uv`, and `ruff` available, use:
```bash
# Spawns a shell with Python, uv, and ruff (does not affect global environment)
nix develop flakehub:guilhermevini/nix
```
