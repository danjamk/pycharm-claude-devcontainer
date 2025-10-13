# SSH Keys for Dev Container

This directory contains project-specific SSH keys for GitHub access in the development container.

## Files

- `id_ed25519_github_readonly` - **Private key** (NOT committed to git)
- `id_ed25519_github_readonly.pub` - **Public key** (committed to git)

## Purpose

These keys provide **read-only access** to your project repository from within the dev container.

## Security

- **Scope**: Read-only access to this repository only (GitHub deploy key)
- **Isolation**: Personal SSH keys from `~/.ssh` on host are NOT mounted
- **Automatic**: Keys are automatically configured by `.devcontainer/start.sh` on container startup

## Setup

See [docs/GITHUB_SETUP.md](../docs/GITHUB_SETUP.md) for complete setup instructions.

**Quick start:**

1. Generate SSH key pair for this project
2. Add the public key as a GitHub deploy key (read-only)
3. Restart the container
4. SSH will be automatically configured

## Public Key

```bash
cat id_ed25519_github_readonly.pub
```

Copy this to GitHub: Repository Settings → Deploy keys → Add deploy key

## Regenerating Keys

If you need to regenerate the keys:

```bash
ssh-keygen -t ed25519 -C "your-project-container-readonly" \
  -f .devcontainer/ssh/id_ed25519_github_readonly
```

Then update the deploy key on GitHub with the new public key.

## What Gets Committed

✅ **Public key** (`id_ed25519_github_readonly.pub`) - Safe to commit
❌ **Private key** (`id_ed25519_github_readonly`) - NEVER commit

The `.gitignore` file should contain:
```
# SSH Keys (only commit public keys, never private keys)
.devcontainer/ssh/id_*
!.devcontainer/ssh/id_*.pub
!.devcontainer/ssh/README.md
```