#!/bin/bash
# aws-permissions-config.example.sh
#
# Copy this file to: aws-permissions-config.sh
# Then edit the POLICIES array below with the AWS managed policies your project needs
#
# This file is sourced by setup-aws-iam-user.sh to determine which IAM policies
# to attach to the project's IAM user.

# ============================================================================
# IAM Policies Configuration
# ============================================================================

# Array of AWS managed policy ARNs to attach to the IAM user
# Add or remove policies based on your project's AWS service requirements

POLICIES=(
    # ========================================================================
    # Common Policies (uncomment what you need)
    # ========================================================================

    # Read-only access to all AWS services (safe for development)
    "arn:aws:iam::aws:policy/ReadOnlyAccess"

    # S3 - Full access to S3 buckets
    # "arn:aws:iam::aws:policy/AmazonS3FullAccess"

    # DynamoDB - Full access to DynamoDB tables
    # "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"

    # Lambda - Full access to Lambda functions
    # "arn:aws:iam::aws:policy/AWSLambdaFullAccess"

    # CloudWatch - Full access to CloudWatch logs and metrics
    # "arn:aws:iam::aws:policy/CloudWatchFullAccess"

    # CloudWatch Logs - Full access to CloudWatch Logs only
    # "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"

    # SQS - Full access to SQS queues
    # "arn:aws:iam::aws:policy/AmazonSQSFullAccess"

    # SNS - Full access to SNS topics
    # "arn:aws:iam::aws:policy/AmazonSNSFullAccess"

    # ========================================================================
    # Data & Analytics
    # ========================================================================

    # EMR - Full access to EMR clusters
    # "arn:aws:iam::aws:policy/AmazonEMRFullAccessPolicy_v2"

    # Glue - Full access to AWS Glue
    # "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"

    # Athena - Full access to Athena
    # "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"

    # Kinesis - Full access to Kinesis streams
    # "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"

    # ========================================================================
    # Machine Learning
    # ========================================================================

    # SageMaker - Full access to SageMaker
    # "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"

    # Bedrock - Full access to Bedrock
    # "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"

    # ========================================================================
    # Containers & Compute
    # ========================================================================

    # ECS - Full access to ECS
    # "arn:aws:iam::aws:policy/AmazonECS_FullAccess"

    # EKS - Full access to EKS
    # "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

    # EC2 - Full access to EC2 instances
    # "arn:aws:iam::aws:policy/AmazonEC2FullAccess"

    # ========================================================================
    # Orchestration
    # ========================================================================

    # Step Functions - Full access to Step Functions
    # "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"

    # EventBridge - Full access to EventBridge
    # "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"

    # ========================================================================
    # Security & Identity
    # ========================================================================

    # Secrets Manager - Full access
    # "arn:aws:iam::aws:policy/SecretsManagerReadWrite"

    # Systems Manager Parameter Store - Full access
    # "arn:aws:iam::aws:policy/AmazonSSMFullAccess"

    # IAM - Read-only access (useful for debugging permissions)
    # "arn:aws:iam::aws:policy/IAMReadOnlyAccess"

    # ========================================================================
    # Databases
    # ========================================================================

    # RDS - Full access to RDS databases
    # "arn:aws:iam::aws:policy/AmazonRDSFullAccess"

    # DocumentDB - Full access
    # "arn:aws:iam::aws:policy/AmazonDocDBFullAccess"

    # ElastiCache - Full access
    # "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
)

# ============================================================================
# Notes on Policy Selection
# ============================================================================
#
# Best Practices:
# 1. Start with ReadOnlyAccess for exploration
# 2. Add specific service policies as needed
# 3. Use FullAccess policies for development (easier)
# 4. Consider custom policies for production (more secure)
#
# Common Combinations:
#
# Data Pipeline Project:
#   - AmazonS3FullAccess
#   - AmazonEMRFullAccessPolicy_v2
#   - AWSGlueConsoleFullAccess
#   - CloudWatchLogsFullAccess
#
# Web Application:
#   - AmazonS3FullAccess (for static assets)
#   - AWSLambdaFullAccess (for backend)
#   - AmazonDynamoDBFullAccess (for database)
#   - CloudWatchLogsFullAccess (for logging)
#
# Machine Learning:
#   - AmazonS3FullAccess (for data/models)
#   - AmazonSageMakerFullAccess (for training)
#   - AmazonBedrockFullAccess (for inference)
#
# Serverless Application:
#   - AWSLambdaFullAccess
#   - AmazonDynamoDBFullAccess
#   - AWSStepFunctionsFullAccess
#   - AmazonEventBridgeFullAccess
#   - CloudWatchLogsFullAccess
#
# ============================================================================
# Finding Policy ARNs
# ============================================================================
#
# List all AWS managed policies:
#   aws iam list-policies --scope AWS --query 'Policies[*].[PolicyName,Arn]' --output table
#
# Search for specific policy:
#   aws iam list-policies --scope AWS --query 'Policies[?contains(PolicyName, `S3`)].{Name:PolicyName,ARN:Arn}' --output table
#
# Get policy details:
#   aws iam get-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
#
