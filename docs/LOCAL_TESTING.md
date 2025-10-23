# OrchardLite CMS - Local Testing Guide

This guide will help you set up and test OrchardLite CMS locally before deploying to AWS.

## Prerequisites

### Required Software
- **Visual Studio 2019 or later** (Community Edition is fine)
- **.NET Framework 4.8** (should be included with Visual Studio)
- **MySQL Server 8.0 or later**
- **MySQL Workbench** (optional, for database management)

### Alternative: Docker MySQL
If you prefer not to install MySQL locally, you can use Docker:

```bash
docker run --name orchardlite-mysql -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=OrchardLiteDB -e MYSQL_USER=orcharduser -e MYSQL_PASSWORD=OrchardPassword123! -p 3306:3306 -d mysql:8.0
```

## Setup Instructions

### 1. Database Setup

#### Option A: Local MySQL Installation
1. Install MySQL Server 8.0
2. Create database and user:
   ```sql
   CREATE DATABASE OrchardLiteDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'orcharduser'@'localhost' IDENTIFIED BY 'OrchardPassword123!';
   GRANT ALL PRIVILEGES ON OrchardLiteDB.* TO 'orcharduser'@'localhost';
   FLUSH PRIVILEGES;
   ```

#### Option B: Docker MySQL
Use the Docker command above, then connect to create the database:
```bash
docker exec -it orchardlite-mysql mysql -u root -p
# Enter password: rootpassword
# Database and user are already created by Docker environment variables
```

### 2. Run Database Scripts

Navigate to the `OrchardLite/database/` directory and run:

```bash
# Create schema
mysql -u orcharduser -p OrchardLiteDB < schema.sql

# Load sample data
mysql -u orcharduser -p OrchardLiteDB < sample-data.sql
```

**Password:** `OrchardPassword123!`

### 3. Open Project in Visual Studio

1. Open `OrchardLite/src/OrchardLite.Web/OrchardLite.Web.csproj` in Visual Studio
2. Restore NuGet packages (should happen automatically)
3. Build the solution (Ctrl+Shift+B)

### 4. Update Connection String (if needed)

Check `Web.config` and update the connection string if your MySQL setup is different:

```xml
<connectionStrings>
  <add name="DefaultConnection" 
       connectionString="Server=localhost;Database=OrchardLiteDB;Uid=orcharduser;Pwd=OrchardPassword123!;Port=3306;CharSet=utf8mb4;" 
       providerName="MySql.Data.MySqlClient" />
</connectionStrings>
```

### 5. Run the Application

1. Press F5 or click "Start" in Visual Studio
2. The application should open in your browser at `http://localhost:xxxxx/`

## Testing Checklist

### ✅ Basic Functionality
- [ ] Home page loads successfully
- [ ] Navigation menu works
- [ ] About page displays correctly
- [ ] Contact page loads

### ✅ Content Management
- [ ] Blog page shows sample posts
- [ ] Individual content pages load (click on blog post titles)
- [ ] Search functionality works
- [ ] Pages section displays static pages

### ✅ Admin Dashboard
- [ ] Admin dashboard loads (`/admin`)
- [ ] Statistics display correctly
- [ ] Recent content shows sample data
- [ ] Recent activity shows audit logs

### ✅ Database Connectivity
- [ ] Database info page shows table counts (`/admin/databaseinfo`)
- [ ] Content displays from database (not hardcoded)
- [ ] User information displays correctly
- [ ] Media items show in admin

### ✅ Error Handling
- [ ] Invalid URLs show error page
- [ ] Database connection errors are handled gracefully

## Sample Data Verification

After setup, you should see:
- **4 users** (admin, john.editor, jane.author, bob.subscriber)
- **5 content items** (Welcome page, About page, 2 blog posts, Contact page)
- **3 media items** (logo, hero image, architecture diagram)
- **8 system settings**
- **7 audit log entries**

## Common Issues and Solutions

### Issue: "MySQL.Data.MySqlClient not found"
**Solution:** Ensure MySQL Connector/NET is installed via NuGet:
```
Install-Package MySql.Data.EntityFramework -Version 8.0.33
```

### Issue: "Cannot connect to MySQL server"
**Solutions:**
1. Check MySQL service is running
2. Verify connection string parameters
3. Ensure user has proper permissions
4. Check firewall settings

### Issue: "Entity Framework model errors"
**Solution:** 
1. Clean and rebuild solution
2. Check that all model classes are properly configured
3. Verify database schema matches Entity Framework models

### Issue: "Bootstrap/CSS not loading"
**Solution:**
1. Ensure NuGet packages are restored
2. Check that bundling is configured correctly
3. Verify Content folder contains CSS files

## Performance Testing

### Database Performance
Test with larger datasets:
```sql
-- Generate more sample data for testing
INSERT INTO ContentItems (ContentType, Title, Slug, Summary, Body, AuthorId, Status, PublishedDate)
SELECT 
    'BlogPost',
    CONCAT('Test Post ', n),
    CONCAT('test-post-', n),
    CONCAT('Summary for test post ', n),
    CONCAT('<p>This is test content for post number ', n, '</p>'),
    1,
    'Published',
    NOW()
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + 1 n
    FROM 
    (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    CROSS JOIN (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
) numbers
WHERE n <= 1000;
```

### Load Testing
- Test with multiple concurrent users
- Monitor database connection pooling
- Check memory usage during heavy loads

## Next Steps

Once local testing is complete:

1. **Create AMI-ready version** for AWS deployment
2. **Test with larger datasets** (10,000+ records)
3. **Prepare CloudFormation templates** for automated deployment
4. **Document migration scenarios** for workshop use

## Troubleshooting

If you encounter issues:

1. Check the Visual Studio Output window for detailed error messages
2. Review the Event Viewer for application errors
3. Enable detailed Entity Framework logging in Web.config
4. Use MySQL Workbench to verify database connectivity and data

## Support

For technical support during local testing:
- Check the project README.md
- Review the database schema documentation
- Contact the workshop team for assistance