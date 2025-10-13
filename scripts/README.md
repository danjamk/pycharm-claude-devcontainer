# Scripts Directory

Utility scripts for managing the PyCharm + Claude Code development environment.

## AWS IAM Management Scripts

### `setup-aws-iam-user.sh`

**Purpose**: Automate creation of project-specific AWS IAM users with configurable permissions.

**Usage:**
```bash
./scripts/setup-aws-iam-user.sh
```

**What it does:**
- Prompts for project name (defaults to git repository name)
- Creates IAM user: `<project-name>-dev`
- Attaches AWS managed policies (configurable via `aws-permissions-config.sh`)
- Creates access key for the user
- Automatically updates `.env` file with credentials
- Backs up existing `.env` before modifications
- Safe to rerun - adds new policies without recreating user

**Configuration:**

1. **First time setup:**
   ```bash
   cp scripts/aws-permissions-config.example.sh scripts/aws-permissions-config.sh
   ```

2. **Edit permissions:**
   ```bash
   nano scripts/aws-permissions-config.sh
   ```

   Uncomment the AWS policies you need:
   ```bash
   POLICIES=(
       "arn:aws:iam::aws:policy/AmazonS3FullAccess"
       "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
       # Add more as needed
   )
   ```

3. **Run setup:**
   ```bash
   ./scripts/setup-aws-iam-user.sh
   ```

**Prerequisites:**
- AWS CLI installed and configured
- IAM permissions to create users and attach policies
- Authenticated with AWS (`aws configure` or environment variables)

**See:** [.devcontainer/docs/AWS_SETUP.md](../.devcontainer/docs/AWS_SETUP.md) for detailed setup guide

---

### `aws-permissions-config.example.sh`

**Purpose**: Template for configuring AWS IAM policies to attach to project IAM user.

**Usage:**
```bash
# Copy to create your configuration
cp scripts/aws-permissions-config.example.sh scripts/aws-permissions-config.sh

# Edit to uncomment policies you need
nano scripts/aws-permissions-config.sh
```

**Contains:**
- Comprehensive list of AWS managed policies
- Common policy combinations for different project types
- Comments explaining when to use each policy
- Instructions for finding additional policies

**Common Configurations:**

**Data Pipeline:**
```bash
POLICIES=(
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    "arn:aws:iam::aws:policy/AmazonEMRFullAccessPolicy_v2"
    "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
)
```

**Web Application:**
```bash
POLICIES=(
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
)
```

**Machine Learning:**
```bash
POLICIES=(
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
    "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
)
```

---

### `cleanup-aws-iam-user.sh`

**Purpose**: Safely delete project IAM user and all associated resources.

**Usage:**
```bash
# Interactive (prompts for username)
./scripts/cleanup-aws-iam-user.sh

# Direct (specify username)
./scripts/cleanup-aws-iam-user.sh my-project-dev
```

**What it does:**
- Shows user details, policies, and access keys
- Requires confirmation before deletion
- Deletes all access keys
- Detaches all IAM policies
- Deletes the IAM user
- Optionally removes credentials from `.env` file
- Creates backup of `.env` before modifications

**Prerequisites:**
- AWS CLI installed and configured
- IAM permissions to delete users and detach policies
- Authenticated with AWS

**Safety Features:**
- Shows all resources before deletion
- Requires typing 'yes' to confirm
- Backs up `.env` before modifying
- Cannot be accidentally run without confirmation

---

### `dev-commands.sh`

**Purpose**: Common development task shortcuts.

**Usage:**
```bash
./scripts/dev-commands.sh <command>
```

**Available Commands:**
- `test` - Run test suite with pytest
- `format` - Format code with black
- `lint` - Check code style with flake8
- `check` - Run format, lint, and tests (full check)
- `requirements` - Install Python dependencies

**Examples:**
```bash
# Run tests
./scripts/dev-commands.sh test

# Format and check everything
./scripts/dev-commands.sh check
```

---

## File Structure

```
scripts/
├── README.md                           # This file
├── setup-aws-iam-user.sh              # Create AWS IAM user
├── cleanup-aws-iam-user.sh            # Delete AWS IAM user
├── aws-permissions-config.example.sh  # Template for IAM policies
├── aws-permissions-config.sh          # Your IAM policies (gitignored)
└── dev-commands.sh                    # Development task shortcuts
```

## Notes

- **`aws-permissions-config.sh` is gitignored** - Copy from example and customize per project
- All scripts are designed to be **safe to rerun**
- Scripts provide **colored output** for better readability
- **Backups are created** before modifying files
- Scripts use **project naming conventions** (based on git repo name)

## Related Documentation

- [AWS Setup Guide](../.devcontainer/docs/AWS_SETUP.md) - Complete AWS configuration guide
- [GitHub Setup Guide](../.devcontainer/docs/GITHUB_SETUP.md) - GitHub SSH configuration
- [Main README](../README.md) - Project overview
