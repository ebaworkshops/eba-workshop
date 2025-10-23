# 🚀 Phase 1: Legacy Setup Deployment Guide

## 🎯 **Overview**

Phase 1 creates the **legacy environment** that serves as the foundation for the complete AWS migration workshop. This setup demonstrates a realistic legacy application ready for transformation.

## 🏗️ **What Phase 1 Includes**

### **Legacy Application Stack**
- **.NET Framework 4.8** application in public subnet (AWS Transform ready)
- **MySQL 8.0 on EC2** in private subnet (DMS source ready)
- **Direct IP access** for simplicity
- **SSM Session Manager** for secure instance access

### **Migration Readiness Features**
- **Binary logging enabled** on MySQL for DMS
- **UI indicators** showing legacy status and data source
- **Minimal IAM roles** for Phase 1 operations only
- **Simple networking** focused on current phase

## 🚀 **Quick Deployment**

### **Prerequisites**
1. **AWS CLI configured** with appropriate permissions
2. **SSM permissions** for instance access (no SSH keys needed)
3. **Port 8080** available for direct web access

### **Deploy Command**
```bash
cd OrchardLite/aws
./deploy.sh --scenario phase1-legacy
```

### **Example**
```bash
# Deploy to us-east-1 (default)
./deploy.sh --scenario phase1-legacy

# Deploy to different region
./deploy.sh --scenario phase1-legacy --region us-west-2

# Custom stack name
./deploy.sh --scenario phase1-legacy --stack-name my-orchardlite-legacy
```

## ⏱️ **Deployment Timeline**

| Phase | Duration | Description |
|-------|----------|-------------|
| **Infrastructure** | 3 minutes | VPC, subnets, security groups |
| **Database Setup** | 5 minutes | MySQL installation and configuration |
| **Application Deployment** | 8 minutes | Docker setup and application start |
| **Instance Initialization** | 4 minutes | Final startup and health checks |
| **Total** | **~20 minutes** | Complete legacy environment |

## 🌐 **What You'll See**

### **Application Interface**
- **Legacy badges** showing ".NET Framework 4.8" and "MySQL on EC2"
- **Migration readiness indicators** in the UI
- **Database connection status** with source information
- **System information panel** showing current phase
- **Migration path roadmap** for workshop progression

### **Key UI Elements**
```
┌─────────────────────────────────────────────────┐
│ 🍃 OrchardLite CMS    [.NET Framework 4.8] [MySQL on EC2] │
├─────────────────────────────────────────────────┤
│ ⚠️  Legacy Application - Phase 1                │
│ This is the legacy version running .NET         │
│ Framework 4.8 with MySQL on EC2. Ready for     │
│ AWS migration workshop!                         │
├─────────────────────────────────────────────────┤
│ ✅ Database Connected                           │
│ Source: 10.0.x.x (MySQL on EC2)               │
│ Total Content Items: 5                         │
└─────────────────────────────────────────────────┘
```

## 📊 **Database Configuration**

### **MySQL Setup**
- **Version**: MySQL 8.0
- **Location**: EC2 instance in private subnet
- **Binary Logging**: Enabled for DMS
- **User**: `orcharduser` with full privileges
- **Schema**: Complete OrchardLite schema loaded
- **Sample Data**: Realistic content for demonstration

### **DMS Readiness**
```sql
-- Binary logging configuration
log-bin=mysql-bin
server-id=1
binlog-format=ROW

-- User permissions for DMS
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'orcharduser'@'%';
```

## 🔍 **Verification Steps**

### **1. Check Application Health**
```bash
# Get the application URL from stack outputs
aws cloudformation describe-stacks \
  --stack-name orchardlite-cms \
  --query 'Stacks[0].Outputs[?OutputKey==`ApplicationURL`].OutputValue' \
  --output text

# Test health endpoint
curl http://YOUR_ALB_DNS/health
```

### **2. Verify Database Connection**
```bash
# Get database server IP
aws cloudformation describe-stacks \
  --stack-name orchardlite-cms \
  --query 'Stacks[0].Outputs[?OutputKey==`DatabaseServerIP`].OutputValue' \
  --output text

# Test MySQL connection (from web server)
mysql -h DATABASE_IP -u orcharduser -p OrchardLiteDB
```

### **3. Check Migration Readiness**
```bash
# Verify binary logging
mysql -h DATABASE_IP -u orcharduser -p -e "SHOW VARIABLES LIKE 'log_bin';"

# Check replication user
mysql -h DATABASE_IP -u orcharduser -p -e "SELECT User, Host FROM mysql.user WHERE User='orcharduser';"
```

## 📈 **Monitoring and Logs**

### **Application Logs**
```bash
# SSH to instance and check logs
ssh -i YOUR_KEY.pem ec2-user@INSTANCE_IP
sudo docker logs orchardlite-web

# Check system logs
sudo tail -f /var/log/messages
```

## 💰 **Cost Estimation**

| Resource | Type | Monthly Cost |
|----------|------|-------------|
| Web Server | t3.medium | ~$30 |
| Database Server | t3.small | ~$15 |
| Load Balancer | ALB | ~$20 |
| Data Transfer | Minimal | ~$5 |
| **Total** | | **~$70/month** |

## 🔧 **Troubleshooting**

### **Common Issues**

**Application not loading:**
```bash
# Check instance status
aws ec2 describe-instances --filters "Name=tag:Name,Values=OrchardLite-Legacy-WebServer"

# Check target group health
aws elbv2 describe-target-health --target-group-arn TARGET_GROUP_ARN
```

**Database connection failed:**
```bash
# Check database server status
aws ec2 describe-instances --filters "Name=tag:Name,Values=OrchardLite-Legacy-Database-Server"

# SSH to database server and check MySQL
ssh -i YOUR_KEY.pem ec2-user@DATABASE_PUBLIC_IP
sudo systemctl status mysqld
```

**Load balancer health checks failing:**
```bash
# Check security groups
aws ec2 describe-security-groups --filters "Name=tag:Name,Values=OrchardLite-Legacy-*"

# Test direct instance access
curl http://INSTANCE_IP:8080/health
```

## 🎯 **Workshop Scenarios**

### **Scenario 1: Legacy Assessment**
1. **Show the legacy application** running on EC2
2. **Highlight technical debt** (.NET Framework 4.8)
3. **Demonstrate database challenges** (MySQL on EC2)
4. **Discuss migration drivers** (cost, scalability, maintenance)

### **Scenario 2: Migration Planning**
1. **AWS Transform analysis** of the .NET application
2. **Database migration strategy** with DMS
3. **Infrastructure modernization** options
4. **Timeline and resource planning**

### **Scenario 3: Risk Assessment**
1. **Downtime considerations** for migration
2. **Data consistency** during transition
3. **Rollback strategies** if issues occur
4. **Testing and validation** approaches

## 🚀 **Next Phases**

After Phase 1 is complete, you can proceed with:

### **Phase 2: AWS Transform Analysis**
- Run AWS Transform for .NET on the codebase
- Generate modernization recommendations
- Create transformation roadmap

### **Phase 3: Database Migration**
- Set up DMS replication instance
- Configure source and target endpoints
- Execute database migration

### **Phase 4: Application Modernization**
- Deploy transformed .NET application
- Implement CI/CD with CodePipeline
- Integrate with modern AWS services

## 🛑 **Cleanup**

When you're done with Phase 1:
```bash
./deploy.sh --cleanup --stack-name orchardlite-cms --region us-east-1
```

## 📞 **Support**

If you encounter issues:
1. Check the troubleshooting section above
2. Review CloudWatch logs for detailed error information
3. Verify all prerequisites are met
4. Ensure proper IAM permissions

**Phase 1 provides the perfect foundation for demonstrating the complete AWS migration journey!**