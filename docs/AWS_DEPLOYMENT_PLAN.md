# 🚀 OrchardLite CMS - AWS Deployment Plan

## 🎯 **Overview**

This document outlines multiple AWS deployment strategies for OrchardLite CMS, perfect for demonstrating various migration scenarios in workshops.

## 📋 **Deployment Scenarios**

### **Scenario 1: Lift & Shift Migration**
- **Target**: EC2 + RDS MySQL
- **Complexity**: Low
- **Timeline**: 1-2 hours
- **Use Case**: Basic cloud migration

### **Scenario 2: Containerized Deployment**
- **Target**: ECS Fargate + RDS MySQL
- **Complexity**: Medium
- **Timeline**: 2-3 hours
- **Use Case**: Modern containerization

### **Scenario 3: Serverless Architecture**
- **Target**: Lambda + Aurora Serverless
- **Complexity**: High
- **Timeline**: 4-6 hours
- **Use Case**: Cloud-native transformation

### **Scenario 4: Database Migration Demo**
- **Target**: DMS Migration (MySQL → Aurora PostgreSQL)
- **Complexity**: Medium
- **Timeline**: 2-4 hours
- **Use Case**: Heterogeneous database migration

---

## 🏗️ **Scenario 1: Lift & Shift Migration**

### **Architecture**
```
Internet → ALB → EC2 (Docker) → RDS MySQL
                ↓
            CloudWatch Logs
```

### **AWS Services**
- **Compute**: EC2 (t3.medium)
- **Database**: RDS MySQL 8.0
- **Load Balancer**: Application Load Balancer
- **Storage**: EBS GP3
- **Monitoring**: CloudWatch
- **Security**: VPC, Security Groups, IAM

### **Step-by-Step Deployment**

#### **Phase 1: Infrastructure Setup (30 minutes)**
1. **Create VPC and Subnets**
   ```bash
   # Create VPC with public/private subnets
   aws ec2 create-vpc --cidr-block 10.0.0.0/16
   aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.1.0/24  # Public
   aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.2.0/24  # Private
   ```

2. **Create Security Groups**
   - Web Server SG: Allow 80, 443, 22
   - Database SG: Allow 3306 from Web Server SG

3. **Create RDS MySQL Instance**
   ```bash
   aws rds create-db-instance \
     --db-instance-identifier orchardlite-mysql \
     --db-instance-class db.t3.micro \
     --engine mysql \
     --engine-version 8.0 \
     --allocated-storage 20 \
     --db-name OrchardLiteDB \
     --master-username orcharduser \
     --master-user-password OrchardPassword123!
   ```

#### **Phase 2: Application Deployment (45 minutes)**
1. **Launch EC2 Instance**
   - AMI: Amazon Linux 2
   - Instance Type: t3.medium
   - Install Docker and Docker Compose

2. **Deploy Application**
   ```bash
   # On EC2 instance
   sudo yum update -y
   sudo yum install -y docker git
   sudo systemctl start docker
   sudo usermod -a -G docker ec2-user
   
   # Install Docker Compose
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   
   # Clone and deploy
   git clone https://github.com/aws-samples/orchardlite-cms.git
   cd orchardlite-cms/OrchardLite
   
   # Update docker-compose.yml with RDS endpoint
   docker compose up -d
   ```

#### **Phase 3: Load Balancer Setup (15 minutes)**
1. **Create Application Load Balancer**
2. **Configure Target Group**
3. **Update Security Groups**

### **Estimated Costs (Monthly)**
- EC2 t3.medium: ~$30
- RDS db.t3.micro: ~$15
- ALB: ~$20
- **Total**: ~$65/month

---

## 🐳 **Scenario 2: Containerized Deployment (ECS Fargate)**

### **Architecture**
```
Internet → ALB → ECS Fargate → RDS MySQL
                      ↓
                 CloudWatch Logs
                      ↓
                    ECR
```

### **AWS Services**
- **Compute**: ECS Fargate
- **Container Registry**: ECR
- **Database**: RDS MySQL 8.0
- **Load Balancer**: Application Load Balancer
- **Monitoring**: CloudWatch
- **Security**: VPC, Security Groups, IAM

### **Step-by-Step Deployment**

#### **Phase 1: Container Preparation (30 minutes)**
1. **Create ECR Repository**
   ```bash
   aws ecr create-repository --repository-name orchardlite-cms
   ```

2. **Build and Push Container**
   ```bash
   # Build container
   docker build -f Dockerfile.simple -t orchardlite-cms .
   
   # Tag and push to ECR
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
   docker tag orchardlite-cms:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/orchardlite-cms:latest
   docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/orchardlite-cms:latest
   ```

#### **Phase 2: ECS Setup (45 minutes)**
1. **Create ECS Cluster**
   ```bash
   aws ecs create-cluster --cluster-name orchardlite-cluster
   ```

2. **Create Task Definition**
   ```json
   {
     "family": "orchardlite-task",
     "networkMode": "awsvpc",
     "requiresCompatibilities": ["FARGATE"],
     "cpu": "256",
     "memory": "512",
     "executionRoleArn": "arn:aws:iam::123456789012:role/ecsTaskExecutionRole",
     "containerDefinitions": [
       {
         "name": "orchardlite-web",
         "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/orchardlite-cms:latest",
         "portMappings": [
           {
             "containerPort": 3000,
             "protocol": "tcp"
           }
         ],
         "environment": [
           {
             "name": "DB_HOST",
             "value": "orchardlite-mysql.cluster-xxx.us-east-1.rds.amazonaws.com"
           }
         ],
         "logConfiguration": {
           "logDriver": "awslogs",
           "options": {
             "awslogs-group": "/ecs/orchardlite",
             "awslogs-region": "us-east-1",
             "awslogs-stream-prefix": "ecs"
           }
         }
       }
     ]
   }
   ```

3. **Create ECS Service**
   ```bash
   aws ecs create-service \
     --cluster orchardlite-cluster \
     --service-name orchardlite-service \
     --task-definition orchardlite-task \
     --desired-count 2 \
     --launch-type FARGATE
   ```

### **Estimated Costs (Monthly)**
- ECS Fargate (2 tasks): ~$25
- RDS db.t3.micro: ~$15
- ALB: ~$20
- ECR: ~$1
- **Total**: ~$61/month

---

## ⚡ **Scenario 3: Serverless Architecture**

### **Architecture**
```
Internet → API Gateway → Lambda → Aurora Serverless v2
                          ↓
                    CloudWatch Logs
```

### **AWS Services**
- **Compute**: Lambda
- **API**: API Gateway
- **Database**: Aurora Serverless v2 (MySQL)
- **Storage**: S3 (static assets)
- **CDN**: CloudFront
- **Monitoring**: CloudWatch

### **Step-by-Step Deployment**

#### **Phase 1: Database Setup (30 minutes)**
1. **Create Aurora Serverless v2 Cluster**
   ```bash
   aws rds create-db-cluster \
     --db-cluster-identifier orchardlite-aurora \
     --engine aurora-mysql \
     --engine-version 8.0.mysql_aurora.3.02.0 \
     --master-username orcharduser \
     --master-user-password OrchardPassword123! \
     --serverless-v2-scaling-configuration MinCapacity=0.5,MaxCapacity=2
   ```

#### **Phase 2: Lambda Function (60 minutes)**
1. **Create Lambda Deployment Package**
   ```bash
   # Create serverless version of the app
   npm install serverless-http
   # Modify server.js to work with Lambda
   ```

2. **Deploy Lambda Function**
   ```bash
   aws lambda create-function \
     --function-name orchardlite-api \
     --runtime nodejs18.x \
     --role arn:aws:iam::123456789012:role/lambda-execution-role \
     --handler index.handler \
     --zip-file fileb://function.zip
   ```

#### **Phase 3: API Gateway (30 minutes)**
1. **Create REST API**
2. **Configure Proxy Integration**
3. **Deploy API**

### **Estimated Costs (Monthly)**
- Lambda (1M requests): ~$5
- Aurora Serverless v2: ~$30
- API Gateway: ~$10
- S3 + CloudFront: ~$5
- **Total**: ~$50/month

---

## 🔄 **Scenario 4: Database Migration Demo (DMS)**

### **Architecture**
```
Source: Local MySQL → DMS → Target: Aurora PostgreSQL
                       ↓
                 Migration Logs
```

### **Migration Steps**

#### **Phase 1: Source Database Setup (15 minutes)**
1. **Prepare Source MySQL**
   - Enable binary logging
   - Create replication user
   - Configure security groups

#### **Phase 2: Target Database Setup (20 minutes)**
1. **Create Aurora PostgreSQL Cluster**
   ```bash
   aws rds create-db-cluster \
     --db-cluster-identifier orchardlite-postgres \
     --engine aurora-postgresql \
     --master-username orcharduser \
     --master-user-password OrchardPassword123!
   ```

#### **Phase 3: Schema Conversion (45 minutes)**
1. **Use AWS SCT (Schema Conversion Tool)**
   - Convert MySQL schema to PostgreSQL
   - Handle data type differences
   - Resolve compatibility issues

#### **Phase 4: DMS Migration (60 minutes)**
1. **Create DMS Replication Instance**
   ```bash
   aws dms create-replication-instance \
     --replication-instance-identifier orchardlite-dms \
     --replication-instance-class dms.t3.micro
   ```

2. **Create Source and Target Endpoints**
   ```bash
   # Source endpoint (MySQL)
   aws dms create-endpoint \
     --endpoint-identifier orchardlite-source \
     --endpoint-type source \
     --engine-name mysql
   
   # Target endpoint (PostgreSQL)
   aws dms create-endpoint \
     --endpoint-identifier orchardlite-target \
     --endpoint-type target \
     --engine-name postgres
   ```

3. **Create Migration Task**
   ```bash
   aws dms create-replication-task \
     --replication-task-identifier orchardlite-migration \
     --source-endpoint-arn arn:aws:dms:us-east-1:123456789012:endpoint:source \
     --target-endpoint-arn arn:aws:dms:us-east-1:123456789012:endpoint:target \
     --replication-instance-arn arn:aws:dms:us-east-1:123456789012:rep:instance \
     --migration-type full-load-and-cdc
   ```

### **Migration Challenges to Demonstrate**
- **Data Type Mapping**: MySQL JSON → PostgreSQL JSONB
- **Auto-increment**: MySQL AUTO_INCREMENT → PostgreSQL SERIAL
- **Character Sets**: UTF8MB4 handling
- **Index Conversion**: Full-text search differences
- **Application Updates**: Connection string changes

---

## 🛠️ **Infrastructure as Code (IaC)**

### **CloudFormation Templates**

I'll create CloudFormation templates for each scenario:

1. **`cf-lift-and-shift.yaml`** - EC2 + RDS deployment
2. **`cf-ecs-fargate.yaml`** - ECS Fargate deployment
3. **`cf-serverless.yaml`** - Lambda + Aurora Serverless
4. **`cf-dms-migration.yaml`** - DMS migration setup

### **Terraform Alternative**

For teams preferring Terraform:
1. **`terraform/ec2-rds/`** - Lift & shift
2. **`terraform/ecs-fargate/`** - Container deployment
3. **`terraform/serverless/`** - Serverless architecture
4. **`terraform/dms/`** - Database migration

---

## 📊 **Cost Comparison**

| Scenario | Monthly Cost | Complexity | Migration Value |
|----------|-------------|------------|-----------------|
| Lift & Shift | ~$65 | Low | Basic cloud adoption |
| ECS Fargate | ~$61 | Medium | Containerization |
| Serverless | ~$50 | High | Cloud-native transformation |
| DMS Migration | ~$40 | Medium | Database modernization |

---

## 🎯 **Workshop Recommendations**

### **For Beginners**
1. Start with **Lift & Shift** (Scenario 1)
2. Demonstrate basic AWS services
3. Show cost optimization opportunities

### **For Intermediate**
1. **ECS Fargate** (Scenario 2) for containerization
2. **DMS Migration** (Scenario 4) for database modernization
3. Compare costs and benefits

### **For Advanced**
1. **Serverless Architecture** (Scenario 3)
2. Complete application transformation
3. Advanced monitoring and optimization

---

## 📋 **Next Steps**

1. **Choose your deployment scenario**
2. **Review the detailed implementation guides**
3. **Prepare AWS account and permissions**
4. **Follow the step-by-step deployment**
5. **Test and validate the deployment**

**Each scenario provides hands-on experience with different AWS migration patterns, making OrchardLite CMS perfect for comprehensive migration workshops!**