# Platform Module - Network Security Infrastructure

## Overview

The Platform Module provides secure network infrastructure foundation for the OrchardLite CMS modernization workshop. This module transforms the Phase 1 public-only subnet architecture into a production-ready, secure network setup.

## Architecture

### Resources Deployed (19 total)

#### Network Infrastructure
- 2 Private Subnets (10.0.3.0/24, 10.0.4.0/24)
- 2 Private Route Tables
- 1 NAT Gateway with Elastic IP
- Route table associations and routing

#### VPC Endpoints (7 endpoints)
- S3 Gateway Endpoint
- ECR Interface Endpoint
- CloudWatch Logs Interface Endpoint
- RDS Interface Endpoint
- Secrets Manager Interface Endpoint
- KMS Interface Endpoint
- Systems Manager Interface Endpoint

#### Security Groups
- VPC Endpoint Security Group (for AWS service access)

## Deployment

### Prerequisites
- Phase 1 infrastructure must be deployed
- AWS CLI configured with appropriate permissions
- VPC ID from Phase 1 deployment

### Deploy Platform Module
```bash
# From the Platform/ directory
./deploy-platform.sh
```

### Get Platform Resources
```bash
# Get private subnet IDs
aws cloudformation describe-stacks --stack-name orchardlite-platform-network --query 'Stacks[0].Outputs[?OutputKey==`PrivateSubnet1Id`].OutputValue' --output text

# Get VPC endpoint IDs
aws cloudformation describe-stacks --stack-name orchardlite-platform-network --query 'Stacks[0].Outputs[?contains(OutputKey, `VPCEndpoint`)].{Key:OutputKey,Value:OutputValue}' --output table
```

## Network Security Features

### Private Subnet Isolation
- No direct internet access
- Outbound connectivity via NAT Gateway
- Isolated from public subnet resources

### VPC Endpoints Benefits
- Private AWS service access
- Reduced data transfer costs
- Enhanced security (no internet routing)
- Improved performance

### Security Groups
- Least privilege access principles
- Prepared for Aurora Serverless deployment
- Ready for DMS migration tasks
- VPC endpoint access controls

## Next Steps

After Platform Module deployment:
1. **Security Module** - Configure detailed security group rules
2. **Database Module** - Deploy Aurora Serverless in private subnets
3. **Application Module** - Migrate ECS to private subnets
4. **DevOps Module** - Implement CI/CD pipeline

## Troubleshooting

### Common Issues
- **VPC not found**: Ensure Phase 1 is deployed first
- **CIDR conflicts**: Verify private subnet CIDRs don't overlap
- **NAT Gateway costs**: Monitor usage for cost optimization
- **VPC endpoint connectivity**: Check security group rules

### Validation Commands
```bash
# Test private subnet isolation
aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=<private-subnet-id>"

# Verify VPC endpoints
aws ec2 describe-vpc-endpoints --filters "Name=vpc-id,Values=<vpc-id>"

# Check NAT Gateway status
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=<vpc-id>"
```