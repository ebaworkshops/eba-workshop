# OrchardLite CMS - AWS Modernization Workshop

## 🚀 Quick Deploy (10 minutes)

### Prerequisites
- AWS CLI installed on your computer
- AWS account with appropriate permissions

### Step-by-Step Deployment

#### Step 1: Clone the Repository
```bash
# Clone the workshop repository
git clone https://git-codecommit.us-west-1.amazonaws.com/v1/repos/dotnet-migration-workshop
cd dotnet-migration-workshop
```

#### Step 2: Configure AWS CLI
If you haven't configured AWS CLI before, run:
```bash
aws configure
```

You'll be prompted to enter:
- **AWS Access Key ID**: `AKIAIOSFODNN7EXAMPLE` (replace with your actual key)
- **AWS Secret Access Key**: `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` (replace with your actual secret)
- **Default region name**: `us-west-1` (or your preferred region)
- **Default output format**: `json` (recommended)

**Note:** Get your actual AWS credentials from:
- AWS Console → IAM → Users → [Your User] → Security credentials → Access keys
- Or from your AWS administrator

#### Step 3: Make Deploy Script Executable
```bash
# Make the deployment script executable
chmod +x deploy.sh
```

#### Step 4: Deploy the Application
```bash
# Run the deployment script
./deploy.sh
```

#### Step 5: Get Your Application URL
After deployment completes (8-10 minutes), get your application URL:
```bash
# Replace 'orchardlite-workshop-*' with your actual stack name from the deployment output
aws cloudformation describe-stacks --stack-name orchardlite-workshop-1234567890 --query 'Stacks[0].Outputs[?OutputKey==`ApplicationURL`].OutputValue' --output text
```

**Example output:**
```
http://OrchardLite-Enterprise-ALB-1234567890.us-west-1.elb.amazonaws.com
```

Copy and paste this URL into your web browser to access the application.

## 📊 What You'll See

### Phase 1 - Current State (Insecure by Design)
- 🔴 **.NET Framework 4.8** - Legacy framework
- 🔴 **RDS MySQL (Public)** - Database in public subnet
- 🔴 **Public Subnets Only** - No network isolation
- 🔴 **Manual CloudFormation** - No CI/CD pipeline
- 🔴 **License Issues** - GPL/AGPL compliance problems

### After Modernization (Workshop Goal)
- 🟢 **.NET 8.0** - Modern framework
- 🟢 **Aurora MySQL (Serverless)** - Modern managed database
- 🟢 **Private Subnets + VPC Endpoints** - Secure network
- 🟢 **CI/CD Pipeline Active** - Full automation
- 🟢 **License Compliant** - Issues resolved

## 🔧 Workshop Flow
1. **Deploy Phase 1** - See current insecure state
2. **AWS Transform** - Modernize .NET Framework → .NET 8
3. **Database Migration** - RDS → Aurora using AWS DMS
4. **Network Security** - Public → Private subnets
5. **DevOps Pipeline** - Manual → CI/CD automation
6. **License Compliance** - Resolve GPL/AGPL issues

## 🎪 Live Status Detection
The application automatically detects and displays:
- Framework version changes
- Database migration progress
- Network security improvements
- Deployment pipeline status
- License compliance status

**The UI updates in real-time as you complete each modernization step!**

## 🧹 Cleanup
```bash
# Delete the stack when done
aws cloudformation delete-stack --stack-name orchardlite-workshop-*
```

## 🆘 Troubleshooting

### Common Issues for Beginners

**❌ "aws: command not found"**
- Install AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

**❌ "Unable to locate credentials"**
- Run `aws configure` and enter your AWS credentials
- Verify credentials work: `aws sts get-caller-identity`

**❌ "Permission denied: ./deploy.sh"**
- Make script executable: `chmod +x deploy.sh`

**❌ "Stack creation failed"**
- Check AWS CLI configuration: `aws configure list`
- Verify you have sufficient AWS permissions (EC2, RDS, ECS, CloudFormation)
- Check if you're in the correct region: `aws configure get region`

**❌ "Application not accessible"**
- Wait 8-10 minutes for full deployment
- Check stack status: `aws cloudformation describe-stacks --stack-name [your-stack-name] --query 'Stacks[0].StackStatus'`
- If status is `CREATE_COMPLETE`, try the application URL again

**❌ "Database connection issues"**
- RDS takes the longest to initialize (5-8 minutes)
- Check CloudFormation events for detailed error messages

---
**Ready to modernize? Run `./deploy.sh` and let's begin!** 🚀