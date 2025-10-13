# AWS Setup for DevContainer (OPTIONAL)

This guide explains how to configure AWS credentials for the devcontainer using a project-specific IAM user with minimal permissions.

## When Do You Need This?

**Skip this if:** Your project doesn't use AWS services
**Use this if:** Your project needs to access AWS (S3, Lambda, DynamoDB, etc.)

## Security Model

**We do NOT mount your personal `~/.aws` directory** from the host. Instead:

✅ **Project-specific IAM user**: Create dedicated user for this project
✅ **Credentials in `.env` file**: Not committed to git
✅ **Container-local `~/.aws/`**: Generated on startup from `.env`
✅ **Least privilege**: Minimal IAM policies for this project only

This keeps your personal AWS credentials isolated and provides better security.

## Quick Setup

### 1. Create `.env` File

```bash
cp .env.example .env
nano .env
```

Add your AWS credentials:
```bash
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
AWS_ACCOUNT_ID=123456789012
AWS_REGION=us-east-1
```

### 2. Create IAM User (First Time Only)

**Option A: Automated Script (Recommended)**

Use the included setup script that creates the IAM user and updates `.env` automatically:

```bash
./scripts/setup-aws-iam-user.sh
```

**What the script does:**
- Prompts for project name (defaults to git repo name)
- Creates IAM user: `<project-name>-dev`
- Attaches AWS managed policies (configurable)
- Creates access key
- Automatically updates `.env` with credentials
- Backs up existing `.env` before modifying

**Configure Permissions:**

1. Copy the permissions config example:
   ```bash
   cp scripts/aws-permissions-config.example.sh scripts/aws-permissions-config.sh
   ```

2. Edit `scripts/aws-permissions-config.sh` and uncomment policies you need:
   ```bash
   POLICIES=(
       "arn:aws:iam::aws:policy/AmazonS3FullAccess"
       "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
       # Add more as needed...
   )
   ```

3. Run the setup script (it's safe to rerun - will add new policies):
   ```bash
   ./scripts/setup-aws-iam-user.sh
   ```

**Option B: AWS Console (Manual)**

1. Go to IAM → Users → Create User
2. User name: `my-project-dev` (replace with your project name)
3. Attach policies based on your needs:
   - **S3 only**: `AmazonS3FullAccess`
   - **Lambda**: `AWSLambdaFullAccess`
   - **DynamoDB**: `AmazonDynamoDBFullAccess`
   - **Read-only testing**: `ReadOnlyAccess`
4. Create access key → Save to `.env`

**Option C: AWS CLI (Advanced)**

```bash
# Create IAM user
aws iam create-user --user-name my-project-dev

# Attach policies (example for S3)
aws iam attach-user-policy \
  --user-name my-project-dev \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

# Create access key
aws iam create-access-key --user-name my-project-dev
# Save output to .env file
```

### 3. Restart Container

Credentials are loaded from `.env` on container startup.

**In PyCharm:**
- Stop container
- Start container
- Open new terminal

**Verify:**
```bash
aws-whoami
# Should show: arn:aws:iam::123456789012:user/my-project-dev
```

## How It Works

### On Container Startup

The `.devcontainer/start.sh` script:

1. Reads `.env` file
2. Creates `~/.aws/credentials`:
   ```
   [default]
   aws_access_key_id = <from .env>
   aws_secret_access_key = <from .env>
   ```
3. Creates `~/.aws/config`:
   ```
   [default]
   region = us-east-1
   output = json
   ```

### Why This Approach?

**Security Benefits:**
- ✅ No accidental use of personal AWS credentials
- ✅ Scoped permissions (can't accidentally delete production resources)
- ✅ Easy to revoke (delete IAM user, not your personal access)
- ✅ Audit trail (CloudTrail shows project-specific user actions)

**Convenience:**
- ✅ Same credentials work in container and CI/CD
- ✅ Works with all AWS tools (CLI, SDK, boto3, etc.)
- ✅ No manual `aws configure` needed

## Minimal IAM Policies

Choose policies based on your project needs:

### S3 Access (Data Storage)
```
Policy: AmazonS3FullAccess
Use case: Store/retrieve files, data pipelines
```

### Lambda (Serverless Functions)
```
Policy: AWSLambdaFullAccess
Use case: Deploy and invoke Lambda functions
```

### DynamoDB (NoSQL Database)
```
Policy: AmazonDynamoDBFullAccess
Use case: Database operations
```

### Read-Only (Testing/Development)
```
Policy: ReadOnlyAccess
Use case: Safely test AWS integrations without modifying resources
```

## Troubleshooting

### Credentials Not Found

**Problem**: `aws sts get-caller-identity` returns error

**Check:**
```bash
# 1. Does .env file exist?
ls -la /workspace/.env

# 2. Does it have credentials?
grep AWS_ACCESS_KEY_ID /workspace/.env

# 3. Are they loaded in container?
echo $AWS_ACCESS_KEY_ID

# 4. Does ~/.aws/credentials exist?
cat ~/.aws/credentials
```

**Solution**:
- Ensure `.env` file exists with correct values
- Restart container (credentials loaded on startup)
- Check `.devcontainer/start.sh` for errors

### Wrong AWS Account

**Problem**: `aws-whoami` shows different account than expected

**Solution**:
```bash
# Check .env file
cat /workspace/.env | grep AWS_ACCOUNT_ID
```

### Permission Denied Errors

**Problem**: AWS operation fails with "AccessDenied"

**Common causes:**
1. Missing IAM policy for that service
2. Resource in different region
3. Resource belongs to different account

**Solution**:
```bash
# Verify which user you're using
aws sts get-caller-identity

# Check IAM policies attached
aws iam list-attached-user-policies --user-name my-project-dev
```

## Rotating Credentials

### When to Rotate

- Every 90 days (security best practice)
- If credentials are compromised
- When team member leaves project

### How to Rotate

1. **Create new access key** (AWS Console or CLI):
   ```bash
   aws iam create-access-key --user-name my-project-dev
   ```

2. **Update `.env` file** with new credentials

3. **Restart container** to load new credentials

4. **Verify** new credentials work:
   ```bash
   aws-whoami
   ```

5. **Delete old access key**:
   ```bash
   aws iam delete-access-key \
     --user-name my-project-dev \
     --access-key-id AKIA...
   ```

## Multi-Developer Setup

**Option 1: Shared IAM User** (Simpler)
- All developers use same IAM user (`my-project-dev`)
- Share credentials securely (password manager, secrets manager)
- Each developer adds to their personal `.env` file (not committed)

**Option 2: Individual IAM Users** (Better audit trail)
- Each developer creates own IAM user with same policies:
  - `my-project-alice`
  - `my-project-bob`
- Better tracking of who did what

## CI/CD Setup

For GitHub Actions or other CI/CD:

1. Store `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as secrets
2. Use same `my-project-dev` user (or create `my-project-ci`)
3. Same IAM policies as development

## Cleanup

### Remove IAM User

When project is complete or user no longer needed:

**Option A: Cleanup Script (Recommended)**

```bash
./scripts/cleanup-aws-iam-user.sh my-project-dev
```

The script will:
- Show user details and attached policies
- Delete all access keys
- Detach all policies
- Delete the IAM user
- Optionally remove credentials from `.env`

**Option B: Manual Cleanup (AWS CLI)**

```bash
# List and delete access keys
aws iam list-access-keys --user-name my-project-dev
aws iam delete-access-key \
  --user-name my-project-dev \
  --access-key-id AKIA...

# Detach policies
aws iam list-attached-user-policies --user-name my-project-dev
aws iam detach-user-policy \
  --user-name my-project-dev \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

# Delete user
aws iam delete-user --user-name my-project-dev
```

## Related Documentation

- [GitHub Setup](./GITHUB_SETUP.md) - Similar credential management for GitHub
- [macOS Security](./MACOS_SECURITY.md) - Docker file sharing security
- [PyCharm Terminal](./PYCHARM_TERMINAL.md) - Zsh configuration

## Quick Reference

```bash
# Check AWS identity
aws-whoami

# Check account
aws-account

# List S3 buckets
aws s3 ls

# Test permissions
aws sts get-caller-identity
```