#!/bin/bash
# setup-aws-iam-user.sh - Create project-specific AWS IAM user with minimal permissions
# This script creates an IAM user for development and updates .env with credentials

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  AWS IAM User Setup for DevContainer                  ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# ============================================================================
# Configuration
# ============================================================================

# Try to get project name from git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
    GIT_REPO_NAME=$(basename $(git rev-parse --show-toplevel) 2>/dev/null || echo "")
    DEFAULT_PROJECT_NAME="${GIT_REPO_NAME}"
else
    DEFAULT_PROJECT_NAME="my-project"
fi

# Prompt for project name
echo -e "${BLUE}Project Configuration${NC}"
echo "----------------------------------------"
read -p "Project name [${DEFAULT_PROJECT_NAME}]: " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}

# Create IAM username from project name
IAM_USERNAME="${PROJECT_NAME}-dev"

echo ""
echo -e "Will create IAM user: ${GREEN}${IAM_USERNAME}${NC}"
echo ""

# ============================================================================
# Load IAM Policies Configuration
# ============================================================================

# Check if custom config exists
CONFIG_FILE="scripts/aws-permissions-config.sh"

if [ -f "$CONFIG_FILE" ]; then
    echo -e "${GREEN}✓${NC} Loading custom permissions from: ${CONFIG_FILE}"
    source "$CONFIG_FILE"
else
    echo -e "${YELLOW}⚠${NC}  No custom permissions config found"
    echo "   Using default minimal permissions (ReadOnlyAccess)"
    echo ""
    echo "   To customize permissions:"
    echo "   1. Copy scripts/aws-permissions-config.example.sh to scripts/aws-permissions-config.sh"
    echo "   2. Edit the POLICIES array with your required AWS managed policies"
    echo "   3. Re-run this script"
    echo ""

    # Default minimal permissions
    POLICIES=(
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
    )
fi

echo ""
echo -e "${BLUE}IAM Policies to Attach:${NC}"
for policy in "${POLICIES[@]}"; do
    policy_name=$(echo "$policy" | awk -F'/' '{print $NF}')
    echo "  • ${policy_name}"
done
echo ""

# Confirm before proceeding
read -p "Continue with IAM user creation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# ============================================================================
# Verify AWS CLI Configuration
# ============================================================================

echo ""
echo -e "${BLUE}Checking AWS CLI configuration...${NC}"

if ! command -v aws &> /dev/null; then
    echo -e "${RED}✗${NC} AWS CLI not found"
    echo "   Install AWS CLI: https://aws.amazon.com/cli/"
    exit 1
fi

# Check if AWS credentials are configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}✗${NC} AWS CLI not configured or credentials invalid"
    echo ""
    echo "Please configure AWS CLI first:"
    echo "  aws configure"
    echo ""
    echo "Or set environment variables:"
    echo "  export AWS_ACCESS_KEY_ID=..."
    echo "  export AWS_SECRET_ACCESS_KEY=..."
    exit 1
fi

# Display current AWS identity
CURRENT_IDENTITY=$(aws sts get-caller-identity 2>/dev/null)
CURRENT_ACCOUNT=$(echo "$CURRENT_IDENTITY" | grep -o '"Account": "[^"]*"' | cut -d'"' -f4)
CURRENT_USER=$(echo "$CURRENT_IDENTITY" | grep -o '"Arn": "[^"]*"' | cut -d'"' -f4)

echo -e "${GREEN}✓${NC} Authenticated as:"
echo "   Account: ${CURRENT_ACCOUNT}"
echo "   User: ${CURRENT_USER}"
echo ""

# Warning if trying to create IAM user with insufficient permissions
echo -e "${YELLOW}⚠${NC}  Note: Your current user must have IAM permissions to:"
echo "   • Create users (iam:CreateUser)"
echo "   • Attach user policies (iam:AttachUserPolicy)"
echo "   • Create access keys (iam:CreateAccessKey)"
echo ""

# ============================================================================
# Create or Update IAM User
# ============================================================================

echo -e "${BLUE}Creating/updating IAM user: ${IAM_USERNAME}${NC}"
echo ""

# Check if user already exists
if aws iam get-user --user-name "$IAM_USERNAME" &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  User '${IAM_USERNAME}' already exists"
    echo "   Will update policies if needed"
else
    echo "Creating IAM user..."
    if aws iam create-user --user-name "$IAM_USERNAME" > /dev/null; then
        echo -e "${GREEN}✓${NC} Created IAM user: ${IAM_USERNAME}"
    else
        echo -e "${RED}✗${NC} Failed to create IAM user"
        exit 1
    fi
fi

# ============================================================================
# Attach IAM Policies
# ============================================================================

echo ""
echo "Attaching IAM policies..."

for policy_arn in "${POLICIES[@]}"; do
    policy_name=$(echo "$policy_arn" | awk -F'/' '{print $NF}')

    # Check if policy is already attached
    if aws iam list-attached-user-policies --user-name "$IAM_USERNAME" | grep -q "$policy_arn"; then
        echo -e "${GREEN}✓${NC} Policy already attached: ${policy_name}"
    else
        echo "   Attaching: ${policy_name}..."
        if aws iam attach-user-policy --user-name "$IAM_USERNAME" --policy-arn "$policy_arn"; then
            echo -e "${GREEN}✓${NC} Attached: ${policy_name}"
        else
            echo -e "${RED}✗${NC} Failed to attach: ${policy_name}"
            echo "   Policy ARN: ${policy_arn}"
            echo "   Verify the policy ARN is correct"
        fi
    fi
done

# ============================================================================
# Create Access Key
# ============================================================================

echo ""
echo -e "${BLUE}Creating access key...${NC}"

# Check existing access keys
EXISTING_KEYS=$(aws iam list-access-keys --user-name "$IAM_USERNAME" --query 'AccessKeyMetadata[*].AccessKeyId' --output text)

if [ -n "$EXISTING_KEYS" ]; then
    echo -e "${YELLOW}⚠${NC}  User already has access key(s):"
    for key in $EXISTING_KEYS; do
        echo "     $key"
    done
    echo ""
    read -p "Create new access key? (previous keys will remain active) (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping access key creation."
        echo ""
        echo -e "${YELLOW}⚠${NC}  You'll need to use an existing access key in .env"
        echo "   Or delete old keys and re-run this script"
        exit 0
    fi
fi

# Create new access key
echo "Creating new access key..."
ACCESS_KEY_OUTPUT=$(aws iam create-access-key --user-name "$IAM_USERNAME" --output json)

if [ $? -eq 0 ]; then
    ACCESS_KEY_ID=$(echo "$ACCESS_KEY_OUTPUT" | grep -o '"AccessKeyId": "[^"]*"' | cut -d'"' -f4)
    SECRET_ACCESS_KEY=$(echo "$ACCESS_KEY_OUTPUT" | grep -o '"SecretAccessKey": "[^"]*"' | cut -d'"' -f4)

    echo -e "${GREEN}✓${NC} Access key created successfully"
else
    echo -e "${RED}✗${NC} Failed to create access key"
    exit 1
fi

# ============================================================================
# Update .env File
# ============================================================================

echo ""
echo -e "${BLUE}Updating .env file...${NC}"

ENV_FILE=".env"

# Create .env from template if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example "$ENV_FILE"
        echo -e "${GREEN}✓${NC} Created .env from .env.example"
    else
        touch "$ENV_FILE"
        echo -e "${GREEN}✓${NC} Created new .env file"
    fi
fi

# Backup existing .env
cp "$ENV_FILE" "${ENV_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
echo -e "${GREEN}✓${NC} Backed up existing .env"

# Function to update or add line in .env
update_env_var() {
    local key=$1
    local value=$2
    local file=$3

    if grep -q "^${key}=" "$file"; then
        # Update existing (uncommented) line
        sed -i.tmp "s|^${key}=.*|${key}=${value}|" "$file"
    elif grep -q "^# ${key}=" "$file" || grep -q "^#${key}=" "$file"; then
        # Uncomment and update
        sed -i.tmp "s|^#* *${key}=.*|${key}=${value}|" "$file"
    else
        # Add new line
        echo "${key}=${value}" >> "$file"
    fi
    rm -f "${file}.tmp"
}

# Update AWS credentials in .env
update_env_var "AWS_ACCESS_KEY_ID" "$ACCESS_KEY_ID" "$ENV_FILE"
update_env_var "AWS_SECRET_ACCESS_KEY" "$SECRET_ACCESS_KEY" "$ENV_FILE"
update_env_var "AWS_ACCOUNT_ID" "$CURRENT_ACCOUNT" "$ENV_FILE"
update_env_var "AWS_REGION" "${AWS_REGION:-us-east-1}" "$ENV_FILE"

echo -e "${GREEN}✓${NC} Updated .env with new credentials"

# ============================================================================
# Summary
# ============================================================================

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  Setup Complete!                                       ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}✓${NC} IAM User: ${IAM_USERNAME}"
echo -e "${GREEN}✓${NC} Account: ${CURRENT_ACCOUNT}"
echo -e "${GREEN}✓${NC} Region: ${AWS_REGION:-us-east-1}"
echo -e "${GREEN}✓${NC} Access Key: ${ACCESS_KEY_ID}"
echo -e "${GREEN}✓${NC} Credentials saved to: .env"
echo ""

echo -e "${BLUE}Attached Policies:${NC}"
for policy in "${POLICIES[@]}"; do
    policy_name=$(echo "$policy" | awk -F'/' '{print $NF}')
    echo "  • ${policy_name}"
done
echo ""

echo -e "${YELLOW}⚠${NC}  Important Security Notes:"
echo "   1. Never commit .env to git (already in .gitignore)"
echo "   2. Store backup of credentials securely (password manager)"
echo "   3. Rotate credentials every 90 days"
echo "   4. Delete old access keys after rotation"
echo ""

echo -e "${BLUE}Next Steps:${NC}"
echo "   1. Restart your devcontainer to load new credentials"
echo "   2. Test AWS access: aws sts get-caller-identity"
echo "   3. Verify permissions for your use case"
echo ""

echo -e "${BLUE}To Verify in Container:${NC}"
echo "   aws-whoami"
echo ""

echo -e "${BLUE}To View Attached Policies:${NC}"
echo "   aws iam list-attached-user-policies --user-name ${IAM_USERNAME}"
echo ""

echo -e "${BLUE}To Delete This IAM User (when no longer needed):${NC}"
echo "   ./scripts/cleanup-aws-iam-user.sh ${IAM_USERNAME}"
echo ""
