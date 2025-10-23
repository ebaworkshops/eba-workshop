# OrchardLite CMS - Phase 1 Stable

## 🎯 **Overview**

Phase 1 Prestage setup for OrchardLite CMS modernization workshop. This creates a stable baseline with .NET Framework 4.8 application running on ECS Fargate with RDS MySQL database.

## 🏗️ **Architecture**

```
Internet → ALB → ECS Fargate (.NET 4.8) → RDS MySQL 8.0
```

## 🚀 **Quick Deployment**

```bash
# Deploy Phase 1
./aws/deploy-phase1.sh

# Check status
./aws/deploy-phase1.sh status

# Delete when done
./aws/deploy-phase1.sh delete
```

## ✅ **What Gets Deployed**

- **ECS Fargate Cluster** with .NET Framework 4.8 application
- **RDS MySQL 8.0** database with automatic initialization
- **Application Load Balancer** with health checks
- **VPC** with public/private/database subnets
- **Security Groups** and IAM roles
- **CloudWatch Logs** for monitoring
- **Sample Data** (3 content items automatically created)

## 📊 **Expected Results**

- **Application URL**: Accessible via ALB DNS name
- **Health Endpoint**: `/health` returns JSON status
- **Database Records**: 3 sample content items
- **Framework Version**: .NET Framework 4.8 displayed in UI
- **Platform**: ECS Fargate shown in system info

## 🔧 **Files Included**

- `cloudformation/phase1-stable.yaml` - Main CloudFormation template
- `deploy-phase1.sh` - Deployment script with validation and health checks

## ⏱️ **Deployment Time**

- **Total Time**: 8-12 minutes
- **RDS Creation**: 6-8 minutes
- **ECS Service**: 2-3 minutes
- **Application Startup**: 1-2 minutes

## 🎯 **Success Criteria**

✅ Application accessible via browser
✅ Health endpoint returns HTTP 200
✅ Database shows 3 content items
✅ .NET Framework 4.8 version displayed
✅ ECS Fargate platform information shown
✅ No manual steps required

## 🧪 **Testing Multiple Deployments**

The template is designed for reliable, repeatable deployments:

```bash
# Test deployment 1
./aws/deploy-phase1.sh
# Test the application, then clean up
./aws/deploy-phase1.sh delete

# Test deployment 2 (after cleanup)
./aws/deploy-phase1.sh
# Verify everything works identically
```

## 📋 **Next Steps**

After Phase 1 is stable and tested:
1. **Phase 2**: Assessment & Planning
2. **Phase 3**: Database Migration
3. **Phase 4**: Application Modernization + CI/CD

---

**Ready to deploy? Run `./aws/deploy-phase1.sh` to get started!**