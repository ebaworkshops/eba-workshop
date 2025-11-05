# Platform Module - Network Security Modernization Design

## Overview

The Platform Module transforms the Phase 1 insecure public-only network architecture into a production-ready, secure network infrastructure. This design establishes the foundational security layer required for subsequent application and database modernization phases while maintaining compatibility with existing Phase 1 resources.

**Important:** All Platform Module resources will be deployed within the existing VPC created during Phase 1 deployment. No new VPC will be created.

## Resources to be Deployed

The Platform Module CloudFormation template (`Platform/network-setup.yaml`) will deploy the following resources in the existing Phase 1 VPC:

### Network Infrastructure (6 resources)
1. **AWS::EC2::Subnet** - Private Subnet 1 (10.0.3.0/24, AZ-a)
2. **AWS::EC2::Subnet** - Private Subnet 2 (10.0.4.0/24, AZ-b)  
3. **AWS::EC2::RouteTable** - Private Route Table 1
4. **AWS::EC2::RouteTable** - Private Route Table 2
5. **AWS::EC2::SubnetRouteTableAssociation** - Private Subnet 1 Association
6. **AWS::EC2::SubnetRouteTableAssociation** - Private Subnet 2 Association

### NAT Gateway Infrastructure (3 resources)
7. **AWS::EC2::EIP** - Elastic IP for NAT Gateway
8. **AWS::EC2::NatGateway** - NAT Gateway in Public Subnet 1
9. **AWS::EC2::Route** - Default route (0.0.0.0/0) to NAT Gateway for private subnets

### VPC Endpoints (7 resources)
10. **AWS::EC2::VPCEndpoint** - S3 Gateway Endpoint
11. **AWS::EC2::VPCEndpoint** - ECR Interface Endpoint  
12. **AWS::EC2::VPCEndpoint** - CloudWatch Logs Interface Endpoint
13. **AWS::EC2::VPCEndpoint** - RDS Interface Endpoint (for RDS API management)
14. **AWS::EC2::VPCEndpoint** - Secrets Manager Interface Endpoint (for database credentials)
15. **AWS::EC2::VPCEndpoint** - KMS Interface Endpoint (for encryption key management)
16. **AWS::EC2::VPCEndpoint** - Systems Manager Interface Endpoint (for parameter store)

### Security Groups (3 resources)
17. **AWS::EC2::SecurityGroup** - Platform Aurora Security Group (placeholder)
18. **AWS::EC2::SecurityGroup** - Platform DMS Security Group (placeholder)
19. **AWS::EC2::SecurityGroup** - Platform VPC Endpoint Security Group (basic rules)

### Route Table Associations for VPC Endpoints (2 resources)
20. **AWS::EC2::VPCEndpointRouteTableAssociation** - S3 Endpoint to Private Route Table 1
21. **AWS::EC2::VPCEndpointRouteTableAssociation** - S3 Endpoint to Private Route Table 2

**Total Resources:** 21 new resources deployed in existing Phase 1 VPC

## Architecture

### Current State (Phase 1)
```
┌─────────────────────────────────────────────────────────────┐
│                    VPC (10.0.0.0/16)                       │
│                                                             │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │ Public Subnet 1 │    │ Public Subnet 2 │                │
│  │  10.0.1.0/24    │    │  10.0.2.0/24    │                │
│  │                 │    │                 │                │
│  │ ┌─────────────┐ │    │ ┌─────────────┐ │                │
│  │ │ ECS Tasks   │ │    │ │     ALB     │ │                │
│  │ │ RDS MySQL   │ │    │ │             │ │                │
│  │ └─────────────┘ │    │ └─────────────┘ │                │
│  └─────────────────┘    └─────────────────┘                │
│           │                       │                        │
│           └───────────────────────┼────────────────────────│
│                                   │                        │
└───────────────────────────────────┼────────────────────────┘
                                    │
                            Internet Gateway
```

### Target State (After Platform Module)
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           VPC (10.0.0.0/16)                                │
│                                                                             │
│  ┌─────────────────┐    ┌─────────────────┐                                │
│  │ Public Subnet 1 │    │ Public Subnet 2 │                                │
│  │  10.0.1.0/24    │    │  10.0.2.0/24    │                                │
│  │                 │    │                 │                                │
│  │ ┌─────────────┐ │    │ ┌─────────────┐ │                                │
│  │ │     ALB     │ │    │ │ NAT Gateway │ │                                │
│  │ │             │ │    │ │             │ │                                │
│  │ └─────────────┘ │    │ └─────────────┘ │                                │
│  └─────────────────┘    └─────────────────┘                                │
│           │                       │                                        │
│           └───────────────────────┼────────────────────────────────────────│
│                                   │                                        │
│  ┌─────────────────┐    ┌─────────────────┐                                │
│  │Private Subnet 1 │    │Private Subnet 2 │                                │
│  │  10.0.3.0/24    │    │  10.0.4.0/24    │                                │
│  │                 │    │                 │                                │
│  │ ┌─────────────┐ │    │ ┌─────────────┐ │                                │
│  │ │ ECS Tasks   │ │    │ │Aurora Server│ │                                │
│  │ │ DMS Tasks   │ │    │ │    less     │ │                                │
│  │ └─────────────┘ │    │ └─────────────┘ │                                │
│  └─────────────────┘    └─────────────────┘                                │
│           │                       │                                        │
│           └───────────────────────┼────────────────────────────────────────│
│                                   │                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        VPC Endpoints                                │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────────────┐                    │   │
│  │  │   S3    │  │   ECR   │  │ CloudWatch Logs │                    │   │
│  │  └─────────┘  └─────────┘  └─────────────────┘                    │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                            Internet Gateway
```

## Components and Interfaces

### 1. Private Subnets
**Purpose:** Secure network isolation for application and database resources

**Configuration:**
- **Private Subnet 1:** 10.0.3.0/24 (AZ-a)
- **Private Subnet 2:** 10.0.4.0/24 (AZ-b)
- **Route Tables:** Custom route tables with NAT Gateway routing
- **Internet Access:** Outbound only via NAT Gateway

**Interfaces:**
- Input: VPC ID from Phase 1 infrastructure
- Output: Private subnet IDs for future resource deployment

### 2. NAT Gateway
**Purpose:** Secure outbound internet connectivity for private subnet resources

**Configuration:**
- **Deployment:** Public Subnet 1 (primary AZ)
- **Elastic IP:** Dedicated static IP address
- **Routing:** Default route (0.0.0.0/0) for private subnets

**Interfaces:**
- Input: Public subnet ID, Elastic IP allocation
- Output: NAT Gateway ID for route table configuration

### 3. VPC Endpoints
**Purpose:** Private AWS service access without internet routing

**S3 VPC Endpoint (Gateway):**
- **Type:** Gateway endpoint
- **Services:** S3 API access
- **Route Tables:** Associated with private subnet route tables

**ECR VPC Endpoint (Interface):**
- **Type:** Interface endpoint
- **Services:** ECR API and Docker registry
- **Security Groups:** Allow HTTPS from private subnets

**CloudWatch Logs VPC Endpoint (Interface):**
- **Type:** Interface endpoint
- **Services:** CloudWatch Logs API
- **Security Groups:** Allow HTTPS from ECS tasks

**RDS VPC Endpoint (Interface):**
- **Type:** Interface endpoint
- **Services:** RDS API for database management
- **Security Groups:** Allow HTTPS from management tools and automation

**Secrets Manager VPC Endpoint (Interface):**
- **Type:** Interface endpoint
- **Services:** Secrets Manager API for credential management
- **Security Groups:** Allow HTTPS from applications and DMS

**KMS VPC Endpoint (Interface):**
- **Type:** Interface endpoint
- **Services:** KMS API for encryption key management
- **Security Groups:** Allow HTTPS from Aurora, DMS, and applications

**Systems Manager VPC Endpoint (Interface):**
- **Type:** Interface endpoint
- **Services:** SSM Parameter Store API
- **Security Groups:** Allow HTTPS from applications and automation

**Interfaces:**
- Input: VPC ID, private subnet IDs, security group IDs
- Output: VPC endpoint IDs and DNS names

### 4. Security Groups

**Note:** Detailed security group configurations including ports, protocols, and access rules will be handled by the Security Module. The Platform Module focuses on network infrastructure foundation.

**Platform Module Security Group Scope:**
- Create placeholder security groups for future Aurora Serverless resources
- Create placeholder security groups for future DMS resources  
- Create basic VPC Endpoint security group for AWS service access
- Security Module will define specific ingress/egress rules, ports, and protocols

## Data Models

### Network Configuration Model
```yaml
NetworkConfig:
  VPC:
    ID: !Ref ExistingVPC
    CIDR: 10.0.0.0/16
  
  PrivateSubnets:
    Subnet1:
      CIDR: 10.0.3.0/24
      AvailabilityZone: !Select [0, !GetAZs ""]
    Subnet2:
      CIDR: 10.0.4.0/24
      AvailabilityZone: !Select [1, !GetAZs ""]
  
  NATGateway:
    PublicSubnet: !Ref ExistingPublicSubnet1
    ElasticIP: !Ref NATGatewayEIP
  
  VPCEndpoints:
    S3:
      Type: Gateway
      ServiceName: com.amazonaws.region.s3
    ECR:
      Type: Interface
      ServiceName: com.amazonaws.region.ecr.dkr
    CloudWatchLogs:
      Type: Interface
      ServiceName: com.amazonaws.region.logs
```

### Security Group Model
```yaml
SecurityGroups:
  Aurora:
    GroupName: Platform-Aurora-SG
    IngressRules:
      - IpProtocol: tcp
        FromPort: 3306
        ToPort: 3306
        SourceSecurityGroupId: !Ref ECSSecurityGroup
  
  DMS:
    GroupName: Platform-DMS-SG
    IngressRules:
      - IpProtocol: tcp
        FromPort: 3306
        ToPort: 3306
        SourceSecurityGroupId: !Ref AuroraSecurityGroup
    EgressRules:
      - IpProtocol: tcp
        FromPort: 3306
        ToPort: 3306
        DestinationSecurityGroupId: !Ref AuroraSecurityGroup
```

## Error Handling

### Network Connectivity Validation
- **CIDR Conflict Detection:** Validate private subnet CIDRs don't overlap with existing subnets
- **Route Table Validation:** Ensure NAT Gateway routes are properly configured
- **VPC Endpoint Connectivity:** Test AWS service access through endpoints

### Security Group Validation
- **Rule Conflicts:** Check for overlapping or conflicting security group rules
- **Connectivity Testing:** Validate communication paths between security groups
- **Least Privilege Verification:** Ensure no unnecessary ports or protocols are allowed

### Deployment Rollback Strategy
- **CloudFormation Stack Protection:** Use stack policies to prevent accidental resource deletion
- **Incremental Deployment:** Deploy resources in stages to isolate potential issues
- **Dependency Management:** Ensure proper resource dependencies and creation order

## Testing Strategy

### Unit Testing
- **CloudFormation Template Validation:** Syntax and parameter validation
- **Security Group Rule Testing:** Verify rule configurations match requirements
- **CIDR Block Validation:** Test subnet CIDR calculations and conflicts

### Integration Testing
- **Cross-Stack Communication:** Test connectivity between Phase 1 and Platform resources
- **VPC Endpoint Functionality:** Validate AWS service access through endpoints
- **NAT Gateway Connectivity:** Test outbound internet access from private subnets

### Security Testing
- **Network Isolation Verification:** Confirm private subnets have no direct internet access
- **Security Group Compliance:** Validate least privilege access principles
- **VPC Endpoint Security:** Test encrypted communication to AWS services

### Performance Testing
- **NAT Gateway Throughput:** Measure network performance through NAT Gateway
- **VPC Endpoint Latency:** Compare endpoint vs internet routing performance
- **DNS Resolution Testing:** Validate VPC endpoint DNS resolution

## Implementation Phases

### Phase 1: Core Network Infrastructure
1. Create private subnets with route tables
2. Deploy NAT Gateway with Elastic IP
3. Configure routing for private subnet internet access

### Phase 2: VPC Endpoints
1. Deploy S3 Gateway endpoint
2. Create ECR Interface endpoint
3. Implement CloudWatch Logs endpoint

### Phase 3: Security Groups
1. Create Aurora Serverless security group
2. Implement DMS security group
3. Update ECS security group for private subnet compatibility

### Phase 4: Validation and Documentation
1. Test all network connectivity paths
2. Validate security group rules
3. Update documentation and deployment guides