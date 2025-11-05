# Platform Module - Network Security Modernization Requirements

## Introduction

This module focuses on modernizing the network architecture from Phase 1's insecure public-only subnet design to a secure, production-ready network infrastructure. The Platform Module will create the foundational security layer needed for subsequent application and database modernization phases.

## Glossary

- **Platform_Module**: The network security modernization component responsible for creating secure network infrastructure
- **Private_Subnets**: Isolated subnets without direct internet access, accessible only through NAT Gateway
- **NAT_Gateway**: AWS managed service providing outbound internet access for private subnet resources
- **VPC_Endpoints**: Private connections to AWS services without internet routing
- **Security_Groups**: Virtual firewalls controlling inbound and outbound traffic
- **Route_Tables**: Network routing configuration for subnet traffic management
- **Phase1_Infrastructure**: Existing public subnet architecture from the current workshop deployment
- **Aurora_Serverless**: Target database service for future migration (Phase 3)
- **DMS_Service**: AWS Database Migration Service for future database migration tasks
- **ECS_Tasks**: Containerized application workloads to be moved to private subnets

## Requirements

### Requirement 1

**User Story:** As a Platform Engineer, I want to create private subnets in the existing VPC, so that future database and application resources can be deployed securely without direct internet exposure.

#### Acceptance Criteria

1. WHEN the Platform Module is deployed, THE Platform_Module SHALL create two private subnets across different Availability Zones
2. WHEN private subnets are created, THE Platform_Module SHALL ensure each private subnet has a /24 CIDR block that does not conflict with existing public subnets
3. WHEN private subnets are provisioned, THE Platform_Module SHALL create dedicated route tables for private subnet traffic management
4. WHERE private subnets exist, THE Platform_Module SHALL ensure no direct internet gateway routes are configured
5. WHEN private subnets are established, THE Platform_Module SHALL tag all resources with appropriate Platform Module identifiers

### Requirement 2

**User Story:** As a Platform Engineer, I want to implement NAT Gateway connectivity, so that resources in private subnets can access the internet for updates and external API calls while remaining secure from inbound internet traffic.

#### Acceptance Criteria

1. WHEN NAT Gateway is deployed, THE Platform_Module SHALL create NAT Gateway in the existing public subnet
2. WHEN NAT Gateway is configured, THE Platform_Module SHALL allocate and associate an Elastic IP address
3. WHEN private subnet routing is established, THE Platform_Module SHALL configure route tables to direct outbound traffic through NAT Gateway
4. WHERE NAT Gateway exists, THE Platform_Module SHALL ensure high availability by deploying in the primary Availability Zone
5. WHEN NAT Gateway is operational, THE Platform_Module SHALL validate outbound internet connectivity from private subnets

### Requirement 3

**User Story:** As a Platform Engineer, I want to create VPC Endpoints for essential AWS services, so that private subnet resources can access AWS services without internet routing and reduce data transfer costs.

#### Acceptance Criteria

1. WHEN VPC Endpoints are deployed, THE Platform_Module SHALL create VPC Endpoint for S3 service access
2. WHEN VPC Endpoints are configured, THE Platform_Module SHALL create VPC Endpoint for ECR service access for container image pulls
3. WHEN VPC Endpoints are established, THE Platform_Module SHALL create VPC Endpoint for CloudWatch Logs service
4. WHEN database management endpoints are deployed, THE Platform_Module SHALL create VPC Endpoint for RDS API access
5. WHEN credential management endpoints are configured, THE Platform_Module SHALL create VPC Endpoint for Secrets Manager service
6. WHEN encryption endpoints are established, THE Platform_Module SHALL create VPC Endpoint for KMS service
7. WHEN parameter management endpoints are deployed, THE Platform_Module SHALL create VPC Endpoint for Systems Manager service
8. WHERE VPC Endpoints exist, THE Platform_Module SHALL associate endpoints with private subnet route tables
9. WHEN VPC Endpoints are operational, THE Platform_Module SHALL configure appropriate security groups for endpoint access

### Requirement 4

**User Story:** As a Platform Engineer, I want to create security groups for future Aurora Serverless and DMS services, so that database migration and modernization phases have proper network security controls in place.

#### Acceptance Criteria

1. WHEN security groups are created, THE Platform_Module SHALL create dedicated security group for Aurora Serverless database access
2. WHEN database security group is configured, THE Platform_Module SHALL allow inbound MySQL traffic only from application security groups
3. WHEN DMS security group is created, THE Platform_Module SHALL configure appropriate access for database migration tasks
4. WHERE security groups exist, THE Platform_Module SHALL implement least privilege access principles
5. WHEN security groups are established, THE Platform_Module SHALL ensure no public internet access is permitted

### Requirement 5

**User Story:** As a Platform Engineer, I want to prepare ECS security group updates, so that application containers can be migrated to private subnets in future phases while maintaining proper connectivity.

#### Acceptance Criteria

1. WHEN ECS security groups are updated, THE Platform_Module SHALL modify existing ECS security group to allow private subnet communication
2. WHEN private subnet connectivity is configured, THE Platform_Module SHALL ensure ECS tasks can communicate with ALB in public subnets
3. WHERE ECS security groups exist, THE Platform_Module SHALL maintain backward compatibility with Phase 1 deployment
4. WHEN security group rules are applied, THE Platform_Module SHALL validate connectivity between public ALB and private ECS tasks
5. WHEN ECS preparation is complete, THE Platform_Module SHALL document security group changes for future application migration

### Requirement 6

**User Story:** As a Platform Engineer, I want to organize Platform Module resources in a dedicated "Platform" folder structure, so that network infrastructure code is maintainable and separated from Phase 1 application-specific resources.

#### Acceptance Criteria

1. WHEN Platform Module is organized, THE Platform_Module SHALL create dedicated "Platform/" folder in the repository root
2. WHEN Platform folder is established, THE Platform_Module SHALL create CloudFormation template "Platform/network-setup.yaml" for all network resources
3. WHERE Platform folder exists, THE Platform_Module SHALL include "Platform/deploy-platform.sh" script for platform-specific deployment
4. WHEN Platform code organization is complete, THE Platform_Module SHALL create "Platform/README.md" documenting platform infrastructure and deployment process
5. WHEN Platform folder structure is finalized, THE Platform_Module SHALL ensure clear separation between root-level Phase 1 files and Platform/ module files