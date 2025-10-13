# macOS Docker Desktop Security

This guide explains Docker Desktop file sharing configuration for better security on macOS.

## The Problem

By default, Docker Desktop for Mac shares `/Users` with all containers. This exposes:

❌ `~/.aws` - Your personal AWS credentials
❌ `~/.ssh` - Your personal SSH keys
❌ `~/Documents` - Personal documents
❌ `~/Downloads` - Downloaded files
❌ `~/Desktop` - Desktop files

**Any container can access these directories**, which is a security risk.

## The Solution

**Restrict Docker Desktop file sharing to only your project directories.**

### Configuration Steps

1. Open **Docker Desktop** → **Settings** (gear icon)
2. Go to **Resources** → **File sharing**
3. Remove `/Users` from the list
4. Add only: `/Users/<your-username>/<your-projects-directory>`
   - Replace `<your-username>` with your macOS username
   - Replace `<your-projects-directory>` with the parent directory of your projects
   - Example: `/Users/john/projects`
5. Click **Apply & restart**

### What This Does

**Before** (insecure):
```
File sharing: /Users
  → Containers can access: ~/.aws, ~/.ssh, ~/Documents, ~/Downloads, ~/Desktop
```

**After** (secure):
```
File sharing: /Users/john/projects
  → Containers can ONLY access: /Users/john/projects/*
```

Now containers can't access:
- ✅ `~/.aws` (blocked)
- ✅ `~/.ssh` (blocked)
- ✅ `~/Documents` (blocked)
- ✅ `~/Downloads` (blocked)
- ✅ `~/Desktop` (blocked)

## Trade-offs

### Advantages
✅ **Better security** - Personal credentials isolated
✅ **Explicit access** - You choose what containers can see
✅ **Audit trail** - Clear what directories are shared

### Disadvantages
❌ **Manual setup** - Each new project directory must be added
❌ **One-time config** - Must configure Docker Desktop settings

**Example:** If you clone a new project to `/Users/john/another-project`, you need to add that path to file sharing.

## This Project's Approach

This project uses **explicit credential management** instead of mounting host directories:

### SSH Keys
- ❌ Don't mount `~/.ssh` from host
- ✅ Copy project SSH key from `.devcontainer/ssh/`
- ✅ Read-only GitHub access
- See: [GITHUB_SETUP.md](./GITHUB_SETUP.md)

### Other Credentials
- ❌ Don't mount personal credential directories
- ✅ Use project-specific configuration files
- ✅ Container-local only

This works regardless of Docker Desktop file sharing settings.

## Verification

### Check Current File Sharing

1. Docker Desktop → Settings → Resources → File sharing
2. Verify only project parent directory is listed

### Test Container Isolation

From within the container, try to access your home directory:

```bash
# This should FAIL (directory doesn't exist in container)
ls -la ~/.aws
# Error: No such file or directory

ls -la ~/Documents
# Error: No such file or directory
```

But project directory works:
```bash
ls -la /workspace
# Shows project files ✅
```

## Other macOS Users

If you're using this project on a different Mac:

1. Update file sharing: `/Users/<your-username>/<your-projects-dir>`
2. Ensure project is inside that directory
3. No other changes needed (credentials managed by project config)

## Linux/Windows Users

This guide is **macOS-specific**. Linux and Windows have different Docker configurations:

**Linux:**
- File sharing works differently
- Usually more secure by default
- May not need these restrictions

**Windows:**
- WSL2 integration has different security model
- Check Docker Desktop → Resources → WSL Integration
- Similar principles apply (restrict shared drives)

## Alternative: Keep Default File Sharing

If you prefer to keep `/Users` shared (more convenient):

**This project still works securely** because:
- ✅ SSH keys explicitly copied from `.devcontainer/ssh/`
- ✅ No automatic mounting of `~/.ssh`
- ✅ Explicit credential configuration

However, **other containers** you run may still access your personal directories.

## Why This Matters

### Real-World Scenario

You download a Docker image from Docker Hub to test something:

```bash
docker run -v /Users/john:/host some-random-image
```

**With default settings:**
- ❌ Container can access `~/.aws` (your AWS credentials)
- ❌ Container can access `~/.ssh` (your SSH keys)
- ❌ Container can exfiltrate sensitive data

**With restricted settings:**
- ✅ Container can't access `/Users/john` (not in file sharing)
- ✅ `docker run` command fails (can't mount directory)
- ✅ You're forced to be explicit about what you share

## Best Practices

1. **Restrict file sharing** to project directories only
2. **Never mount `~/.aws` or `~/.ssh`** into containers
3. **Use project-specific credentials** (like this project does)
4. **Be explicit** about what data containers can access
5. **Audit regularly** - Review Docker Desktop file sharing settings

## Related Documentation

- [GitHub Setup](./GITHUB_SETUP.md) - Explicit SSH key management
- [PyCharm Terminal](./PYCHARM_TERMINAL.md) - Terminal setup with Zsh
- [Main README](../../../README.md) - Dev container overview

## Summary

**For this project:**
1. Restrict Docker Desktop file sharing to `/Users/<username>/<projects-dir>`
2. Credentials managed via project-specific configuration
3. No need to mount personal `~/.ssh` or other credential directories
4. Better security with minimal inconvenience