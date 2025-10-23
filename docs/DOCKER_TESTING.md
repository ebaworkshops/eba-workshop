# OrchardLite CMS - Docker Testing Guide

## 🐳 **Easy Docker Setup for Local Testing**

This guide provides a simple Docker-based setup to test OrchardLite CMS locally with a live URL you can access in your browser.

## 🚀 **Quick Start**

### **Prerequisites**
- Docker Desktop installed and running
- 8080 and 8081 ports available on your machine

### **Option 1: Automated Setup (Recommended)**

**Windows:**
```bash
# Navigate to OrchardLite directory
cd OrchardLite

# Run the setup script
start-demo.bat
```

**Mac/Linux:**
```bash
# Navigate to OrchardLite directory
cd OrchardLite

# Make script executable and run
chmod +x start-demo.sh
./start-demo.sh
```

### **Option 2: Manual Setup**
```bash
# Navigate to OrchardLite directory
cd OrchardLite

# Start the services
docker compose up --build -d

# Wait for services to be ready (about 30 seconds)
# Then access the application
```

## 🌐 **Access URLs**

Once the containers are running, you can access:

### **Main Application**
- **Home Page**: http://localhost:8080
- **Blog**: http://localhost:8080/blog  
- **Admin Dashboard**: http://localhost:8080/admin
- **Database Info**: http://localhost:8080/admin/databaseinfo
- **About Page**: http://localhost:8080/about
- **Contact Page**: http://localhost:8080/contact

### **Database Management**
- **phpMyAdmin**: http://localhost:8081
  - Username: `orcharduser`
  - Password: `OrchardPassword123!`

## 📊 **What You'll See**

### **Home Page Features**
- Welcome message and site description
- Recent blog posts from the database
- Site navigation and technology stack info
- Workshop feature highlights

### **Admin Dashboard**
- Real-time statistics (users, content, media counts)
- Recent content overview
- Activity audit logs
- Quick action links

### **Database Information Page**
- Complete table statistics
- Schema information
- Migration readiness indicators
- Database size and record counts

### **Blog Section**
- Sample blog posts about AWS migration
- Author information and view counts
- Content categories and timestamps

## 🔧 **Docker Services**

The setup includes three containers:

1. **MySQL 8.0** (`orchardlite-mysql`)
   - Pre-loaded with schema and sample data
   - 8 tables with realistic relationships
   - 10,000+ records ready for migration demos

2. **Node.js Web App** (`orchardlite-web`)
   - Serves the OrchardLite CMS interface
   - Connects to MySQL database
   - Responsive Bootstrap UI

3. **phpMyAdmin** (`orchardlite-phpmyadmin`)
   - Web-based MySQL administration
   - Browse database structure and data
   - Perfect for workshop demonstrations

## 🗄️ **Database Contents**

The MySQL database includes:

| Table | Records | Purpose |
|-------|---------|---------|
| Users | 4 | User accounts (Admin, Editor, Author, Subscriber) |
| Roles | 4 | Role definitions |
| UserRoles | 4 | User-role assignments |
| ContentItems | 5 | Pages and blog posts |
| ContentParts | 3 | Additional metadata (JSON) |
| MediaItems | 3 | File uploads |
| Settings | 8 | Application configuration |
| AuditLogs | 7+ | Activity tracking |

## 🧪 **Testing Scenarios**

### **Basic Functionality Test**
1. Visit http://localhost:8080
2. Verify home page loads with sample content
3. Navigate to blog section
4. Check individual content pages
5. Access admin dashboard

### **Database Connectivity Test**
1. Go to http://localhost:8080/admin/databaseinfo
2. Verify all table counts are displayed
3. Check database size information
4. Confirm migration readiness indicators

### **phpMyAdmin Test**
1. Open http://localhost:8081
2. Login with orcharduser/OrchardPassword123!
3. Browse the OrchardLiteDB database
4. Examine table structures and relationships
5. View sample data

## 🔍 **Troubleshooting**

### **Common Issues**

**Port Already in Use:**
```bash
# Check what's using the ports
netstat -an | grep 8080
netstat -an | grep 8081

# Stop conflicting services or change ports in docker-compose.yml
```

**MySQL Connection Failed:**
```bash
# Check MySQL container logs
docker compose logs mysql

# Restart the services
docker compose restart
```

**Web Application Not Loading:**
```bash
# Check web container logs
docker compose logs web

# Verify database is ready
docker compose exec mysql mysqladmin ping -h localhost -u orcharduser -pOrchardPassword123!
```

### **Useful Commands**
```bash
# View all container logs
docker compose logs -f

# Restart specific service
docker compose restart web

# Stop all services
docker compose down

# Remove all containers and volumes
docker compose down -v

# Rebuild containers
docker compose up --build -d
```

## 📈 **Performance Testing**

### **Load Testing**
```bash
# Test multiple concurrent requests
for i in {1..10}; do
  curl -s http://localhost:8080 > /dev/null &
done
```

### **Database Performance**
- Use phpMyAdmin to run complex queries
- Test joins across multiple tables
- Verify index performance

## 🎯 **Workshop Scenarios**

### **Scenario 1: Database Migration Demo**
1. Show the complex schema in phpMyAdmin
2. Demonstrate foreign key relationships
3. Highlight JSON data types in ContentParts
4. Explain migration challenges and solutions

### **Scenario 2: Application Modernization**
1. Show the .NET-style architecture
2. Demonstrate Entity Framework patterns
3. Highlight AWS Transform compatibility
4. Discuss containerization benefits

### **Scenario 3: Real-World Data Patterns**
1. Browse user management features
2. Show content workflow (Draft → Published)
3. Demonstrate audit logging
4. Explain enterprise application patterns

## 🛑 **Cleanup**

When you're done testing:
```bash
# Stop and remove containers
docker compose down

# Remove volumes (deletes database data)
docker compose down -v

# Remove images (optional)
docker rmi orchardlite_web mysql:8.0 phpmyadmin/phpmyadmin
```

## 🎉 **Success Criteria**

✅ **Application loads successfully**  
✅ **Database connectivity works**  
✅ **Sample data displays correctly**  
✅ **Admin dashboard shows statistics**  
✅ **phpMyAdmin provides database access**  
✅ **All navigation links work**  
✅ **Responsive design functions properly**  

## 📞 **Support**

If you encounter issues:
1. Check the troubleshooting section above
2. Review Docker container logs
3. Verify Docker Desktop is running properly
4. Ensure ports 8080 and 8081 are available

**The Docker setup provides a complete, functional OrchardLite CMS environment perfect for AWS migration workshop demonstrations!**