# GitHub SSH Setup for Dev Container

This guide explains how to configure GitHub SSH access for the dev container using a project-specific, read-only deploy key.

## Security Model

**We do NOT mount your personal `~/.ssh` directory** from the host. Instead:

✅ **Project-specific SSH key**: Stored in `.devcontainer/ssh/`
✅ **Read-only access**: GitHub deploy key (can't push)
✅ **Container-local `~/.ssh/`**: Key copied on startup
✅ **Public key committed**: Easy for team to see what key has access

This keeps your personal SSH keys isolated and provides better security.

## Quick Setup

### 1. Generate SSH Key

Generate a new SSH key pair for this project:

```bash
ssh-keygen -t ed25519 -C "your-project-container-readonly" \
  -f .devcontainer/ssh/id_ed25519_github_readonly
```

When prompted:
- **Enter passphrase**: Press Enter (no passphrase for container keys)
- **Enter same passphrase again**: Press Enter

This creates:
- `id_ed25519_github_readonly` - Private key (NOT in git)
- `id_ed25519_github_readonly.pub` - Public key (in git)

### 2. View Public Key

```bash
cat .devcontainer/ssh/id_ed25519_github_readonly.pub
```

Copy the entire output (starts with `ssh-ed25519`).

### 3. Add as GitHub Deploy Key

1. Go to your repository on GitHub
2. Click **Settings** → **Deploy keys**
3. Click **Add deploy key**
4. Configure:
   - **Title**: `your-project-container-readonly` (use your project name)
   - **Key**: Paste the public key (entire line)
   - **Allow write access**: ❌ **Leave unchecked** (read-only is safer)
5. Click **Add key**

### 4. Test Connection

Open a terminal in the container:

```bash
# Test SSH connection
ssh -T git@github.com

# Expected output:
# Hi username/repository! You've successfully authenticated...
```

```bash
# Test git operations
git fetch origin
git pull origin main
```

## How It Works

### On Container Startup

The `.devcontainer/start.sh` script:

1. Copies SSH key from `.devcontainer/ssh/` to `~/.ssh/`
2. Sets correct permissions (600 for private key)
3. Creates `~/.ssh/config`:
   ```
   Host github.com
       HostName github.com
       User git
       IdentityFile ~/.ssh/id_ed25519_github_readonly
       IdentitiesOnly yes
       StrictHostKeyChecking accept-new
   ```

### Why This Approach?

**Security Benefits:**
- ✅ No accidental use of personal SSH keys
- ✅ Read-only access (can't accidentally force push)
- ✅ Easy to revoke (delete deploy key from GitHub)
- ✅ Audit trail (GitHub shows which key accessed repo)

**Convenience:**
- ✅ Works automatically in container
- ✅ Same key for all developers
- ✅ No manual ssh-agent configuration

## Read-Only vs Write Access

### Read-Only (Current Setup)

**Allows:**
- ✅ `git clone`
- ✅ `git fetch`
- ✅ `git pull`

**Blocks:**
- ❌ `git push`
- ❌ `git push --force`

**When to use:** Most development work (you make commits locally, push from host)

### Write Access (If Needed)

If you need to push from within the container:

1. Edit deploy key on GitHub
2. Check **"Allow write access"**
3. Restart container

**Warning:** With write access, the key can push to `main` branch. Use with caution.

## Troubleshooting

### Permission Denied (publickey)

**Problem**: `git fetch` fails with "Permission denied (publickey)"

**Check:**
```bash
# 1. Does SSH key exist in container?
ls -la ~/.ssh/id_ed25519_github_readonly

# 2. Test SSH connection
ssh -T git@github.com

# 3. Verify SSH config
cat ~/.ssh/config
```

**Solution:**
1. Verify deploy key is added to GitHub
2. Verify you copied the correct public key
3. Restart container (SSH configured on startup)

### Host Key Verification Failed

**Problem**: "Host key verification failed" when connecting to GitHub

**Solution**: This should not happen (we use `StrictHostKeyChecking accept-new`), but if it does:

```bash
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

### Wrong Repository Access

**Problem**: Deploy key works but accesses wrong repository

**Explanation**: Deploy keys are repository-specific. Each project needs its own deploy key.

**To use with different repository:**
1. Generate new key pair
2. Add as deploy key to that repository
3. Update `.devcontainer/ssh/` files

### Bad Permissions Error

**Problem**: "Bad permissions" error for SSH key

**Solution**: The startup script sets correct permissions automatically, but you can fix manually:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519_github_readonly
chmod 644 ~/.ssh/id_ed25519_github_readonly.pub
chmod 600 ~/.ssh/config
```

## Regenerating SSH Key

If you need to create a new key (compromised, expired, etc.):

### 1. Generate New Key

```bash
ssh-keygen -t ed25519 -C "your-project-container-readonly" \
  -f .devcontainer/ssh/id_ed25519_github_readonly
```

This overwrites the existing key.

### 2. Display Public Key

```bash
cat .devcontainer/ssh/id_ed25519_github_readonly.pub
```

### 3. Update GitHub Deploy Key

1. Go to repository Settings → Deploy keys
2. Delete old deploy key
3. Add new key with same title
4. Paste new public key

### 4. Restart Container

```bash
# New key will be configured on startup
```

## Multi-Developer Setup

**Option 1: Shared Key (Recommended)**
- ✅ All developers use same deploy key
- ✅ Simpler setup
- ❌ Can't track which developer accessed repo

**Option 2: Individual Keys**
- Each developer generates their own key
- Add multiple deploy keys to GitHub with descriptive names:
  - `project-alice`
  - `project-bob`
- ✅ Better audit trail
- ❌ More setup work

For most projects, shared key is sufficient.

## CI/CD Setup

For GitHub Actions:

**Don't use deploy keys in CI/CD**. Instead, use:
- `GITHUB_TOKEN` (automatic in GitHub Actions)
- Personal Access Token (stored as secret)

Deploy keys are for development containers, not automation.

## What Gets Committed to Git

✅ **Committed:**
- `id_ed25519_github_readonly.pub` (public key)
- `.devcontainer/ssh/README.md` (documentation)

❌ **NOT Committed** (via `.gitignore`):
- `id_ed25519_github_readonly` (private key)

The `.gitignore` should contain:
```gitignore
# SSH Keys (only commit public keys, never private keys)
.devcontainer/ssh/id_*
!.devcontainer/ssh/id_*.pub
!.devcontainer/ssh/README.md
```

## Comparison with Other Credential Management

This SSH setup follows similar patterns as other credential management:

| Aspect | SSH Keys | Notes |
|--------|----------|-------|
| Storage location | `.devcontainer/ssh/` | Project-specific location |
| Committed to git? | 🔀 Public key only | Private key never committed |
| Container setup | Copied to `~/.ssh/` | Automatic on startup |
| Scope | Project-specific deploy key | One key per repository |
| Permissions | Read-only (deploy key) | Can enable write if needed |
| Host isolation | ✅ Yes | Personal keys stay on host |

Both prioritize:
- Explicit configuration (no hidden mounts)
- Least privilege (minimal access)
- Project isolation (not your personal credentials)

## Related Documentation

- [macOS Security](./MACOS_SECURITY.md) - Docker file sharing security
- [PyCharm Terminal](./PYCHARM_TERMINAL.md) - Terminal setup with Zsh
- [Main README](../../../README.md) - Dev container overview