#!/bin/bash

# Platform Module Deployment Script
# Deploys secure network infrastructure for OrchardLite CMS modernization

echo "🏗️  Platform Module - Network Security Infrastructure Deployment"
echo "=============================================================="

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &>/dev/null; then
    echo "❌ AWS CLI not configured. Please run 'aws configure' first."
    exit 1
fi

# Get current region
REGION=$(aws configure get region)
echo "📍 Deploying to region: $REGION"

# Check if existing infrastructure stack exists
echo "🔍 Checking for existing infrastructure..."
EXISTING_STACK=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE --query 'StackSummaries[?contains(StackName, `orchardlite-workshop`)].StackName' --output text)

if [ -z "$EXISTING_STACK" ]; then
    echo "❌ Existing infrastructure not found. Please deploy the base infrastructure first."
    echo "   Run: ./deploy.sh from the repository root"
    exit 1
fi

echo "✅ Found existing stack: $EXISTING_STACK"

echo "📋 Please select the VPC and Public Subnets from the CloudFormation console when deploying."
echo "   The Platform Module will prompt you to select existing resources from dropdowns."

# Create stack name
STACK_NAME="orchardlite-platform-network"
echo "📦 Creating Platform Module stack: $STACK_NAME"

# Deploy the Platform Module
aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body file://network-setup.yaml \
    --capabilities CAPABILITY_IAM \
    --tags Key=Project,Value=OrchardLite Key=Module,Value=Platform Key=Type,Value=NetworkSecurity

if [ $? -eq 0 ]; then
    echo "✅ Platform Module deployment initiated successfully!"
    echo ""
    echo "⏳ Deployment in progress (this takes 3-5 minutes)..."
    echo "   Stack Name: $STACK_NAME"
    echo ""
    echo "🔍 Monitor progress:"
    echo "   aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].StackStatus'"
    echo ""
    echo "🎯 What's being deployed:"
    echo "   • 2 Private subnets (10.0.3.0/24, 10.0.4.0/24)"
    echo "   • NAT Gateway with Elastic IP"
    echo "   • 7 VPC Endpoints (S3, ECR, CloudWatch, RDS, Secrets Manager, KMS, SSM)"
    echo "   • Security groups for Aurora and DMS (placeholders)"
    echo "   • Private route tables and associations"
    echo ""
    echo "📊 Once complete, get resource information:"
    echo "   # Private subnet IDs"
    echo "   aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?contains(OutputKey, \`PrivateSubnet\`)].{Key:OutputKey,Value:OutputValue}' --output table"
    echo ""
    echo "   # VPC endpoint IDs"
    echo "   aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?contains(OutputKey, \`VPCEndpoint\`)].{Key:OutputKey,Value:OutputValue}' --output table"
    echo ""
    echo "   # Security group IDs"
    echo "   aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?contains(OutputKey, \`SecurityGroup\`)].{Key:OutputKey,Value:OutputValue}' --output table"
    echo ""
    echo "🔒 Security Features Enabled:"
    echo "   • Private subnet isolation (no direct internet access)"
    echo "   • Secure outbound connectivity via NAT Gateway"
    echo "   • Private AWS service access via VPC endpoints"
    echo "   • Cost optimization (reduced data transfer charges)"
    echo ""
    echo "🚀 Next Steps:"
    echo "   1. Security Module - Configure detailed security group rules"
    echo "   2. Database Module - Deploy Aurora Serverless in private subnets"
    echo "   3. Application Module - Migrate ECS to private subnets"
    echo "   4. DevOps Module - Implement CI/CD pipeline"
else
    echo "❌ Platform Module deployment failed!"
    echo "Check CloudFormation console for detailed error information."
    exit 1
fi