# OrchardLite CMS - AWS Modernization Workshop

A complete .NET modernization workshop demonstrating migration from legacy .NET Core 3.1 to modern .NET 8 using AWS services.

## Overview

This workshop provides a hands-on experience modernizing a legacy .NET application using:
- **AWS Transform** - Automated code modernization
- **AWS DMS** - Database migration from RDS to Aurora
- **AWS CodePipeline** - CI/CD automation
- **ECS Fargate** - Container orchestration

## Quick Start

### Prerequisites
- AWS Account with appropriate permissions
- AWS CLI configured
- Git installed

### Deploy the Application

```bash
# Clone the repository
git clone https://github.com/vinaykuchibhotla/dotnet-migration-workshop.git
cd dotnet-migration-workshop

# Deploy using CloudFormation
aws cloudformation create-stack \
  --stack-name orchardlite-workshop \
  --template-body file://orchardlite-dotnet-bootstrap.yaml \
  --parameters \
    ParameterKey=DBPassword,ParameterValue=YourSecurePassword123! \
    ParameterKey=AppDBPassword,ParameterValue=YourAppPassword123! \
    ParameterKey=MyIPAddress,ParameterValue=YOUR_IP/32 \
  --capabilities CAPABILITY_IAM \
  --region us-east-1

# Wait for completion (15-20 minutes)
aws cloudformation wait stack-create-complete \
  --stack-name orchardlite-workshop \
  --region us-east-1

# Get application URL
aws cloudformation describe-stacks \
  --stack-name orchardlite-workshop \
  --query 'Stacks[0].Outputs[?OutputKey==`ApplicationURL`].OutputValue' \
  --output text
```

### Access the Application

Open the URL from the output in your browser. You should see the OrchardLite CMS homepage with 100 sample content items.

## What Gets Deployed

The CloudFormation template automatically provisions:

### Infrastructure
- VPC with 2 public subnets across 2 AZs
- Application Load Balancer
- RDS MySQL 8.0 database
- Security groups and networking

### Application Platform
- ECR repository for Docker images
- CodeBuild project (builds from GitHub)
- ECS Fargate cluster and service
- CloudWatch logs

### Application
- .NET Core 3.1 MVC application
- Automatic database initialization
- 100 sample content records
- Bootstrap UI

## Workshop Tasks

### Task 1: Current State Analysis
- Review the deployed .NET Core 3.1 application
- Identify legacy patterns and security issues
- Check `/health` endpoint for system information

### Task 2: AWS Transform Analysis
1. Navigate to AWS Transform console
2. Create transformation project
3. Point to this GitHub repository
4. Analyze the `/OrchardLiteApp` folder
5. Review modernization recommendations

### Task 3: Code Modernization
- AWS Transform upgrades .NET Core 3.1 → .NET 8
- Review generated code changes
- Transform pushes upgraded code to repository

### Task 4: Database Migration (DMS)
- Use templates in `/Database` folder
- Migrate from RDS MySQL to Aurora Serverless
- Follow guide: `/Database/DMS-TASK-START-GUIDE.md`

### Task 5: CI/CD Pipeline
- Use template in `/DevOps` folder
- Create CodePipeline for automated deployments
- Deploy upgraded .NET 8 application

### Task 6: Blue/Green Deployment
- Create new target group for .NET 8
- Test both versions side-by-side
- Swap ALB listener rules
- Decommission .NET Core 3.1

## Application Features

### Current State (Phase 1)
- 🔴 **.NET Core 3.1** (End of Life)
- 🔴 **RDS MySQL** (Single instance)
- 🔴 **Public Subnets** (Security risk)
- 🔴 **Manual Deployments**
- 🔴 **Legacy MySQL Connector**

### After Modernization (Phase 2)
- 🟢 **.NET 8** (Latest LTS)
- 🟢 **Aurora Serverless** (Managed, scalable)
- 🟢 **Private Subnets** (Secure)
- 🟢 **CI/CD Pipeline** (Automated)
- 🟢 **Modern Connectors** (Optimized)

## Project Structure

```
/OrchardLiteApp/          # .NET Core 3.1 application
├── OrchardLite.sln       # Solution file
├── Dockerfile            # Container definition
└── OrchardLite.Web/      # MVC application
    ├── Controllers/      # MVC controllers
    ├── Models/           # Data models
    ├── Views/            # Razor views
    └── Services/         # Database initialization

/Database/                # DMS templates
/DevOps/                  # CodePipeline templates
/Platform/                # Network and infrastructure
/Security/                # IAM and secrets

buildspec.yml             # CodeBuild specification
orchardlite-dotnet-bootstrap.yaml  # Main deployment template
QUICKSTART.md             # Quick reference guide
```

## Cost Estimates

Approximate hourly costs (us-east-1):
- **RDS db.t3.micro:** $0.017/hour
- **ECS Fargate (0.5 vCPU, 1GB):** $0.024/hour
- **ALB:** $0.025/hour
- **Total:** ~$0.07/hour or ~$1.68/day

## Cleanup

```bash
# Delete the CloudFormation stack
aws cloudformation delete-stack --stack-name orchardlite-workshop

# Wait for deletion to complete
aws cloudformation wait stack-delete-complete --stack-name orchardlite-workshop
```

## Troubleshooting

### Stack Creation Fails
- Check CloudFormation Events tab for errors
- Verify AWS CLI is configured correctly
- Ensure you have necessary IAM permissions

### Application Not Accessible
- Wait full 15-20 minutes for deployment
- Check ECS service is running
- Verify security group allows your IP

### Build Failures
- Check CodeBuild logs in CloudWatch
- Verify GitHub repository is accessible
- Ensure buildspec.yml exists in repo root

## Documentation

- **QUICKSTART.md** - Quick reference for common tasks
- **OrchardLiteApp/README.md** - Application-specific documentation
- **Database/DMS-TASK-START-GUIDE.md** - Database migration guide

## Support

For issues or questions:
1. Check CloudFormation Events for errors
2. Review CloudWatch Logs for application logs
3. Verify all prerequisites are met
4. Check security group configurations

## Architecture

```
Internet
    │
    ▼
   ALB
    │
    ├─────────┬─────────┐
    │         │         │
ECS Task  ECS Task   RDS MySQL
(.NET 3.1) (.NET 3.1)  (8.0)
    │         │         │
    └─────────┴─────────┘
              │
            ECR
              ▲
              │
         CodeBuild
              ▲
              │
           GitHub
```

## Next Steps

1. Deploy the application using the Quick Start guide
2. Access the application and explore the UI
3. Run AWS Transform analysis
4. Follow workshop tasks to modernize the application
5. Compare before/after performance and security

---

**Ready to modernize your .NET application? Let's get started!** 🚀
