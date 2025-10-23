# OrchardLite CMS

A lightweight Content Management System designed specifically for AWS migration workshops. OrchardLite demonstrates a realistic legacy .NET Framework application with a complex database schema, perfect for showcasing AWS Database Migration Service (DMS) and AWS Transform for .NET capabilities.

## 🎯 Purpose

OrchardLite CMS serves as a demonstration application for:
- **AWS Database Migration Service (DMS)** workshops
- **AWS Transform for .NET** modernization scenarios
- **Legacy application migration** to AWS cloud
- **Real-world enterprise application** patterns

## 🏗️ Architecture

### Technology Stack
- **.NET Framework 4.8** (AWS Transform compatible)
- **ASP.NET MVC 5.2.7** (Modern web framework)
- **Entity Framework 6.4.4** (ORM with MySQL support)
- **MySQL 8.0** (Source database for DMS migration)
- **Bootstrap 4** (Responsive UI framework)

### Database Schema
The application includes a comprehensive database schema with 8 tables:

1. **Users** - User accounts and authentication
2. **Roles** - Role-based access control
3. **UserRoles** - Many-to-many user-role relationships
4. **ContentItems** - Pages, blog posts, and other content
5. **ContentParts** - Additional content metadata (JSON)
6. **MediaItems** - File uploads and media library
7. **Settings** - Application configuration
8. **AuditLogs** - Activity tracking and audit trail

## 🚀 Features

### Content Management
- **Pages & Blog Posts** - Full content creation and editing
- **Rich Text Editor** - HTML content with media embedding
- **Content Status** - Draft, Published, Archived workflow
- **SEO Optimization** - Meta tags and URL slugs
- **Content Search** - Full-text search across content

### User Management
- **Role-Based Access** - Administrator, Editor, Author, Subscriber
- **User Authentication** - Forms-based authentication
- **User Profiles** - Extended user information
- **Activity Tracking** - Comprehensive audit logging

### Media Library
- **File Uploads** - Images, documents, and media files
- **Media Organization** - Categorized media management
- **Image Processing** - Automatic thumbnail generation
- **File Type Support** - Multiple MIME type handling

### Admin Dashboard
- **System Overview** - Key metrics and statistics
- **Content Management** - CRUD operations for all content
- **User Administration** - User and role management
- **Database Insights** - Real-time database statistics
- **Audit Trail** - Complete activity logging

## 📊 Sample Data

The application includes comprehensive sample data:
- **4 User Accounts** with different roles
- **5 Content Items** (pages and blog posts)
- **3 Media Items** with realistic file information
- **System Settings** for application configuration
- **Audit Logs** showing realistic user activity

## 🔧 Setup Instructions

### 🐳 **Docker Setup (Recommended)**

The easiest way to get OrchardLite CMS running is with Docker:

**Windows:**
```bash
cd OrchardLite
start-demo.bat
```

**Mac/Linux:**
```bash
cd OrchardLite
chmod +x start-demo.sh
./start-demo.sh
```

**Manual Docker Setup:**
```bash
cd OrchardLite
docker compose up --build -d
```

**Access URLs:**
- **Application**: http://localhost:8080
- **Admin Dashboard**: http://localhost:8080/admin
- **Database Info**: http://localhost:8080/admin/databaseinfo
- **phpMyAdmin**: http://localhost:8081

### 🔧 **Manual Setup**

### Prerequisites
- Visual Studio 2019 or later
- .NET Framework 4.8
- MySQL Server 8.0 or later
- IIS Express (included with Visual Studio)

### Database Setup
1. Create MySQL database:
   ```sql
   CREATE DATABASE OrchardLiteDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'orcharduser'@'localhost' IDENTIFIED BY 'OrchardPassword123!';
   GRANT ALL PRIVILEGES ON OrchardLiteDB.* TO 'orcharduser'@'localhost';
   FLUSH PRIVILEGES;
   ```

2. Run database scripts:
   ```bash
   mysql -u orcharduser -p OrchardLiteDB < database/schema.sql
   mysql -u orcharduser -p OrchardLiteDB < database/sample-data.sql
   ```

### Application Setup
1. Open `OrchardLite.sln` in Visual Studio
2. Restore NuGet packages
3. Update connection string in `Web.config` if needed
4. Build and run the application

### Default Login
- **Username**: admin
- **Password**: admin123 (Note: Use proper password hashing in production)

## 🌐 Application URLs

- **Home Page**: `/`
- **Blog**: `/blog`
- **Content**: `/content/{slug}`
- **Admin Dashboard**: `/admin`
- **Search**: `/search?q={query}`

## 📈 Migration Scenarios

### AWS DMS Migration
Perfect source application for demonstrating:
- **Homogeneous Migration**: MySQL to Amazon RDS for MySQL
- **Heterogeneous Migration**: MySQL to Amazon Aurora PostgreSQL
- **Continuous Replication**: Ongoing data synchronization
- **Schema Conversion**: Using AWS SCT for complex migrations

### AWS Transform for .NET
Ideal candidate for modernization:
- **.NET Framework to .NET 6+**: Modern runtime migration
- **Containerization**: Docker and Amazon ECS deployment
- **Cloud-Native Patterns**: Microservices decomposition
- **Managed Services**: RDS, ElastiCache, CloudFront integration

## 🔍 Database Migration Features

### Complex Relationships
- Foreign key constraints
- Many-to-many relationships
- JSON data types (ContentParts)
- Full-text search indexes
- Composite indexes for performance

### Data Patterns
- **Hierarchical Data**: Content with parts and metadata
- **Audit Trails**: Temporal data with user tracking
- **File References**: Media items with file system integration
- **Configuration Data**: Key-value settings storage
- **User-Generated Content**: Blog posts, comments, uploads

### Migration Challenges
- **JSON Columns**: Modern MySQL JSON data type
- **Full-Text Indexes**: Search optimization
- **ENUM Types**: Status and type constraints
- **Timestamp Handling**: UTC vs local time zones
- **Character Sets**: UTF-8 MB4 for emoji support

## 📚 Workshop Scenarios

### Scenario 1: Basic DMS Migration
1. Set up source MySQL database
2. Create target RDS MySQL instance
3. Configure DMS replication instance
4. Create migration task
5. Monitor migration progress
6. Validate data integrity

### Scenario 2: Heterogeneous Migration
1. Use AWS SCT to convert schema
2. Migrate MySQL to PostgreSQL
3. Update application connection strings
4. Test application functionality
5. Performance optimization

### Scenario 3: Application Modernization
1. Analyze application with AWS Transform
2. Upgrade to .NET 6
3. Containerize the application
4. Deploy to Amazon ECS
5. Integrate with AWS services

## 🛠️ Development Notes

### Entity Framework Configuration
- **Code First**: Models define database schema
- **MySQL Provider**: MySql.Data.EntityFramework
- **Connection Pooling**: Optimized for cloud deployment
- **Lazy Loading**: Disabled for better performance

### Security Considerations
- **SQL Injection**: Parameterized queries via EF
- **XSS Protection**: HTML encoding in views
- **CSRF Protection**: Anti-forgery tokens
- **Authentication**: Forms-based with secure cookies

### Performance Optimizations
- **Database Indexes**: Strategic indexing for common queries
- **Caching**: Output caching for static content
- **Bundling**: CSS and JavaScript optimization
- **Image Optimization**: Responsive image handling

## 📋 TODO for Production

- [ ] Implement proper password hashing (BCrypt)
- [ ] Add comprehensive input validation
- [ ] Implement HTTPS enforcement
- [ ] Add comprehensive error handling
- [ ] Implement proper logging framework
- [ ] Add unit and integration tests
- [ ] Implement caching strategy
- [ ] Add API endpoints for headless CMS
- [ ] Implement content versioning
- [ ] Add multi-language support

## 🤝 Contributing

This is a demonstration application for AWS workshops. For improvements or bug fixes:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For workshop support or questions:
- **Email**: workshop-support@example.com
- **Documentation**: See `/docs` folder
- **Issues**: GitHub Issues for bug reports

---

**OrchardLite CMS** - Demonstrating real-world legacy application migration to AWS Cloud.