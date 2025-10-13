#!/bin/bash
# cleanup-aws-iam-user.sh - Safely delete project IAM user and access keys
# Usage: ./scripts/cleanup-aws-iam-user.sh [username]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  AWS IAM User Cleanup                                  ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# ============================================================================
# Get IAM Username
# ============================================================================

if [ -n "$1" ]; then
    IAM_USERNAME="$1"
else
    # Try to guess from git repo
    if git rev-parse --git-dir > /dev/null 2>&1; then
        GIT_REPO_NAME=$(basename $(git rev-parse --show-toplevel) 2>/dev/null || echo "")
        DEFAULT_USERNAME="${GIT_REPO_NAME}-dev"
    else
        DEFAULT_USERNAME="my-project-dev"
    fi

    read -p "IAM username to delete [${DEFAULT_USERNAME}]: " IAM_USERNAME
    IAM_USERNAME=${IAM_USERNAME:-$DEFAULT_USERNAME}
fi

echo ""
echo -e "${YELLOW}⚠${NC}  WARNING: This will permanently delete:"
echo "   • IAM User: ${IAM_USERNAME}"
echo "   • All access keys for this user"
echo "   • All attached policies for this user"
echo ""

# ============================================================================
# Verify AWS CLI Configuration
# ============================================================================

if ! command -v aws &> /dev/null; then
    echo -e "${RED}✗${NC} AWS CLI not found"
    exit 1
fi

if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}✗${NC} AWS CLI not configured or credentials invalid"
    exit 1
fi

# ============================================================================
# Check if User Exists
# ============================================================================

if ! aws iam get-user --user-name "$IAM_USERNAME" &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  User '${IAM_USERNAME}' does not exist"
    echo "   Nothing to clean up"
    exit 0
fi

echo -e "${BLUE}Found IAM user:${NC} ${IAM_USERNAME}"
echo ""

# Show user details
USER_INFO=$(aws iam get-user --user-name "$IAM_USERNAME" --query 'User.{Created:CreateDate,ARN:Arn}' --output text)
echo "User Details:"
echo "$USER_INFO" | awk '{print "  " $0}'
echo ""

# Show attached policies
echo "Attached Policies:"
ATTACHED_POLICIES=$(aws iam list-attached-user-policies --user-name "$IAM_USERNAME" --query 'AttachedPolicies[*].PolicyName' --output text)
if [ -n "$ATTACHED_POLICIES" ]; then
    echo "$ATTACHED_POLICIES" | tr '\t' '\n' | sed 's/^/  • /'
else
    echo "  (none)"
fi
echo ""

# Show access keys
echo "Access Keys:"
ACCESS_KEYS=$(aws iam list-access-keys --user-name "$IAM_USERNAME" --query 'AccessKeyMetadata[*].[AccessKeyId,Status,CreateDate]' --output text)
if [ -n "$ACCESS_KEYS" ]; then
    echo "$ACCESS_KEYS" | awk '{print "  • " $1 " (" $2 ") - Created: " $3}'
else
    echo "  (none)"
fi
echo ""

# ============================================================================
# Confirm Deletion
# ============================================================================

echo -e "${RED}This action cannot be undone!${NC}"
echo ""
read -p "Are you sure you want to delete this IAM user? (type 'yes' to confirm): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo -e "${BLUE}Deleting IAM user: ${IAM_USERNAME}${NC}"
echo ""

# ============================================================================
# Delete Access Keys
# ============================================================================

echo "Deleting access keys..."
ACCESS_KEY_IDS=$(aws iam list-access-keys --user-name "$IAM_USERNAME" --query 'AccessKeyMetadata[*].AccessKeyId' --output text)

for key_id in $ACCESS_KEY_IDS; do
    echo "   Deleting key: $key_id"
    if aws iam delete-access-key --user-name "$IAM_USERNAME" --access-key-id "$key_id"; then
        echo -e "   ${GREEN}✓${NC} Deleted"
    else
        echo -e "   ${RED}✗${NC} Failed to delete key: $key_id"
    fi
done

# ============================================================================
# Detach Policies
# ============================================================================

echo ""
echo "Detaching policies..."
POLICY_ARNS=$(aws iam list-attached-user-policies --user-name "$IAM_USERNAME" --query 'AttachedPolicies[*].PolicyArn' --output text)

for policy_arn in $POLICY_ARNS; do
    policy_name=$(echo "$policy_arn" | awk -F'/' '{print $NF}')
    echo "   Detaching: $policy_name"
    if aws iam detach-user-policy --user-name "$IAM_USERNAME" --policy-arn "$policy_arn"; then
        echo -e "   ${GREEN}✓${NC} Detached"
    else
        echo -e "   ${RED}✗${NC} Failed to detach: $policy_name"
    fi
done

# ============================================================================
# Delete User
# ============================================================================

echo ""
echo "Deleting IAM user..."
if aws iam delete-user --user-name "$IAM_USERNAME"; then
    echo -e "${GREEN}✓${NC} Successfully deleted IAM user: ${IAM_USERNAME}"
else
    echo -e "${RED}✗${NC} Failed to delete IAM user"
    exit 1
fi

# ============================================================================
# Clean up .env File (Optional)
# ============================================================================

echo ""
if [ -f ".env" ]; then
    read -p "Remove AWS credentials from .env file? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Backup .env
        cp .env ".env.backup.$(date +%Y%m%d_%H%M%S)"

        # Comment out AWS credentials
        sed -i.tmp 's/^AWS_ACCESS_KEY_ID=/#AWS_ACCESS_KEY_ID=/' .env
        sed -i.tmp 's/^AWS_SECRET_ACCESS_KEY=/#AWS_SECRET_ACCESS_KEY=/' .env
        rm -f .env.tmp

        echo -e "${GREEN}✓${NC} Commented out AWS credentials in .env"
        echo "   Backup saved to .env.backup.*"
    fi
fi

# ============================================================================
# Summary
# ============================================================================

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  Cleanup Complete                                      ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}✓${NC} IAM user deleted: ${IAM_USERNAME}"
echo -e "${GREEN}✓${NC} All access keys deleted"
echo -e "${GREEN}✓${NC} All policies detached"
echo ""
echo "The IAM user and associated credentials have been removed from AWS."
echo ""
