-- OrchardLite CMS - Local Database Setup Script
-- Run this script to set up the database for local testing

-- Create database
CREATE DATABASE IF NOT EXISTS OrchardLiteDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user (adjust host as needed)
CREATE USER IF NOT EXISTS 'orcharduser'@'localhost' IDENTIFIED BY 'OrchardPassword123!';
CREATE USER IF NOT EXISTS 'orcharduser'@'%' IDENTIFIED BY 'OrchardPassword123!';

-- Grant permissions
GRANT ALL PRIVILEGES ON OrchardLiteDB.* TO 'orcharduser'@'localhost';
GRANT ALL PRIVILEGES ON OrchardLiteDB.* TO 'orcharduser'@'%';

-- Flush privileges
FLUSH PRIVILEGES;

-- Show confirmation
SELECT 'Database OrchardLiteDB created successfully!' as Status;
SELECT 'User orcharduser created with full permissions' as Status;
SELECT 'Ready to run schema.sql and sample-data.sql' as Status;