-- OrchardLite CMS Sample Data
-- For AWS DMS Migration Workshop

-- Insert default roles
INSERT INTO Roles (RoleName, Description, IsSystemRole) VALUES
('Administrator', 'Full system access', TRUE),
('Editor', 'Can create and edit content', FALSE),
('Author', 'Can create own content', FALSE),
('Subscriber', 'Can view content and comment', FALSE);

-- Insert sample users
INSERT INTO Users (UserName, Email, PasswordHash, FirstName, LastName, IsActive) VALUES
('admin', 'admin@orchardlite.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1234567890abcdefghijklmnopqrstuvwxyz', 'System', 'Administrator', TRUE),
('john.editor', 'john@orchardlite.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1234567890abcdefghijklmnopqrstuvwxyz', 'John', 'Editor', TRUE),
('jane.author', 'jane@orchardlite.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1234567890abcdefghijklmnopqrstuvwxyz', 'Jane', 'Author', TRUE),
('bob.subscriber', 'bob@orchardlite.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1234567890abcdefghijklmnopqrstuvwxyz', 'Bob', 'Subscriber', TRUE);

-- Assign roles to users
INSERT INTO UserRoles (UserId, RoleId) VALUES
(1, 1), -- admin -> Administrator
(2, 2), -- john -> Editor
(3, 3), -- jane -> Author
(4, 4); -- bob -> Subscriber

-- Insert system settings
INSERT INTO Settings (SettingKey, SettingValue, Category, Description, IsSystemSetting) VALUES
('SiteName', 'OrchardLite CMS', 'General', 'The name of the website', FALSE),
('SiteDescription', 'A lightweight CMS for AWS migration workshops', 'General', 'Site description for SEO', FALSE),
('AdminEmail', 'admin@orchardlite.com', 'General', 'Administrator email address', FALSE),
('TimeZone', 'UTC', 'General', 'Default timezone', FALSE),
('Theme', 'Default', 'Appearance', 'Active theme name', FALSE),
('PostsPerPage', '10', 'Content', 'Number of posts per page', FALSE),
('AllowComments', 'true', 'Content', 'Enable comments on content', FALSE),
('DatabaseVersion', '1.0.0', 'System', 'Current database schema version', TRUE);

-- Insert sample content items
INSERT INTO ContentItems (ContentType, Title, Slug, Summary, Body, AuthorId, Status, PublishedDate) VALUES
('Page', 'Welcome to OrchardLite CMS', 'welcome', 
 'Welcome to our lightweight content management system designed for AWS migration workshops.',
 '<h1>Welcome to OrchardLite CMS</h1><p>This is a demonstration content management system built specifically for AWS migration workshops. It showcases a realistic web application with a complex database schema that is perfect for demonstrating AWS Database Migration Service (DMS) capabilities.</p><h2>Features</h2><ul><li>User management with role-based access</li><li>Content management (pages and blog posts)</li><li>Media library</li><li>Admin dashboard</li><li>Audit logging</li></ul><p>This application uses .NET Framework 4.8 with Entity Framework, making it compatible with AWS Transform for .NET for modernization scenarios.</p>',
 1, 'Published', NOW()),

('Page', 'About Us', 'about-us',
 'Learn more about OrchardLite CMS and its purpose in AWS migration workshops.',
 '<h1>About OrchardLite CMS</h1><p>OrchardLite CMS is a scaled-down content management system inspired by the popular Orchard CMS. It has been specifically designed to serve as a realistic legacy application for AWS migration workshops.</p><h2>Technical Architecture</h2><p>The application demonstrates common patterns found in enterprise web applications:</p><ul><li><strong>Database Layer:</strong> MySQL with complex relational schema</li><li><strong>Application Layer:</strong> ASP.NET MVC with Entity Framework</li><li><strong>Presentation Layer:</strong> Responsive web interface</li></ul><h2>Migration Scenarios</h2><p>This application is perfect for demonstrating:</p><ul><li>Database migration using AWS DMS</li><li>Application modernization with AWS Transform for .NET</li><li>Infrastructure migration to AWS</li></ul>',
 1, 'Published', NOW()),

('BlogPost', 'Getting Started with AWS DMS', 'getting-started-aws-dms',
 'A comprehensive guide to migrating databases to AWS using Database Migration Service.',
 '<h1>Getting Started with AWS DMS</h1><p>AWS Database Migration Service (DMS) is a cloud service that makes it easy to migrate relational databases, data warehouses, NoSQL databases, and other types of data stores.</p><h2>Key Benefits</h2><ul><li>Minimal downtime migration</li><li>Continuous data replication</li><li>Support for widely used databases</li><li>Cost-effective solution</li></ul><h2>Migration Process</h2><p>The typical migration process involves:</p><ol><li>Setting up source and target endpoints</li><li>Creating a replication instance</li><li>Configuring migration tasks</li><li>Monitoring the migration progress</li></ol><p>This OrchardLite CMS application serves as an excellent example of a source database that can be migrated to AWS RDS using DMS.</p>',
 2, 'Published', NOW()),

('BlogPost', 'Modernizing .NET Applications with AWS', 'modernizing-dotnet-aws',
 'Learn how to modernize legacy .NET Framework applications for the cloud.',
 '<h1>Modernizing .NET Applications with AWS</h1><p>Legacy .NET Framework applications can be successfully modernized and migrated to AWS using various tools and services.</p><h2>AWS Transform for .NET</h2><p>AWS Transform for .NET helps automate the process of upgrading and modernizing .NET applications by:</p><ul><li>Analyzing application dependencies</li><li>Upgrading to newer .NET versions</li><li>Containerizing applications</li><li>Optimizing for cloud deployment</li></ul><h2>Migration Strategies</h2><p>Common strategies include:</p><ul><li><strong>Rehost:</strong> Lift and shift to EC2</li><li><strong>Replatform:</strong> Move to managed services like RDS</li><li><strong>Refactor:</strong> Modernize to .NET Core/5+</li><li><strong>Containerize:</strong> Deploy using ECS or EKS</li></ul>',
 3, 'Published', NOW()),

('Page', 'Contact Us', 'contact',
 'Get in touch with our team for support and questions.',
 '<h1>Contact Us</h1><p>We would love to hear from you! Whether you have questions about OrchardLite CMS or need assistance with your AWS migration workshop, our team is here to help.</p><h2>Workshop Support</h2><p>For technical support during AWS migration workshops:</p><ul><li>Email: workshop-support@example.com</li><li>Documentation: Available in the /docs folder</li><li>GitHub Issues: Report bugs and feature requests</li></ul><h2>General Information</h2><p>For general inquiries about the OrchardLite CMS project:</p><ul><li>Email: info@orchardlite.com</li><li>Website: https://github.com/aws-samples/orchardlite-cms</li></ul>',
 1, 'Published', NOW());

-- Insert sample media items
INSERT INTO MediaItems (FileName, OriginalFileName, ContentType, FileSize, FilePath, AltText, Caption, UploadedById) VALUES
('logo.png', 'orchardlite-logo.png', 'image/png', 15420, '/media/images/logo.png', 'OrchardLite CMS Logo', 'The official OrchardLite CMS logo', 1),
('hero-image.jpg', 'aws-migration-hero.jpg', 'image/jpeg', 245680, '/media/images/hero-image.jpg', 'AWS Migration Workshop', 'Hero image for AWS migration workshop content', 1),
('architecture-diagram.png', 'cms-architecture.png', 'image/png', 89340, '/media/images/architecture-diagram.png', 'CMS Architecture Diagram', 'Technical architecture diagram of OrchardLite CMS', 2);

-- Insert sample content parts (metadata)
INSERT INTO ContentParts (ContentItemId, PartType, PartName, PartData) VALUES
(1, 'SEO', 'MetaTags', '{"title": "Welcome to OrchardLite CMS", "description": "A lightweight CMS for AWS migration workshops", "keywords": "CMS, AWS, migration, workshop"}'),
(2, 'SEO', 'MetaTags', '{"title": "About OrchardLite CMS", "description": "Learn about our AWS migration workshop CMS", "keywords": "about, CMS, AWS, migration"}'),
(3, 'SEO', 'MetaTags', '{"title": "Getting Started with AWS DMS", "description": "Guide to AWS Database Migration Service", "keywords": "AWS, DMS, database, migration"}'),
(1, 'Navigation', 'MenuSettings', '{"showInMainMenu": true, "menuOrder": 1, "parentId": null}'),
(2, 'Navigation', 'MenuSettings', '{"showInMainMenu": true, "menuOrder": 2, "parentId": null}'),
(5, 'Navigation', 'MenuSettings', '{"showInMainMenu": true, "menuOrder": 3, "parentId": null}');

-- Insert sample audit logs
INSERT INTO AuditLogs (UserId, Action, EntityType, EntityId, Details, IpAddress) VALUES
(1, 'CREATE', 'ContentItem', 1, '{"title": "Welcome to OrchardLite CMS", "contentType": "Page"}', '192.168.1.100'),
(1, 'CREATE', 'ContentItem', 2, '{"title": "About Us", "contentType": "Page"}', '192.168.1.100'),
(2, 'CREATE', 'ContentItem', 3, '{"title": "Getting Started with AWS DMS", "contentType": "BlogPost"}', '192.168.1.101'),
(3, 'CREATE', 'ContentItem', 4, '{"title": "Modernizing .NET Applications with AWS", "contentType": "BlogPost"}', '192.168.1.102'),
(1, 'LOGIN', 'User', 1, '{"loginMethod": "password", "success": true}', '192.168.1.100'),
(2, 'LOGIN', 'User', 2, '{"loginMethod": "password", "success": true}', '192.168.1.101'),
(3, 'LOGIN', 'User', 3, '{"loginMethod": "password", "success": true}', '192.168.1.102');