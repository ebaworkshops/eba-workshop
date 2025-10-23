-- OrchardLite CMS Database Schema
-- Designed for AWS DMS Migration Workshop
-- Compatible with MySQL and AWS RDS

-- Drop existing tables if they exist
DROP TABLE IF EXISTS AuditLogs;
DROP TABLE IF EXISTS MediaItems;
DROP TABLE IF EXISTS ContentParts;
DROP TABLE IF EXISTS ContentItems;
DROP TABLE IF EXISTS UserRoles;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Settings;

-- Users table
CREATE TABLE Users (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(255) NOT NULL UNIQUE,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(500) NOT NULL,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LastLoginDate TIMESTAMP NULL,
    INDEX idx_username (UserName),
    INDEX idx_email (Email),
    INDEX idx_active (IsActive)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Roles table
CREATE TABLE Roles (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    RoleName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    IsSystemRole BOOLEAN DEFAULT FALSE,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_rolename (RoleName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- UserRoles junction table
CREATE TABLE UserRoles (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT NOT NULL,
    RoleId INT NOT NULL,
    AssignedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (RoleId) REFERENCES Roles(Id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_role (UserId, RoleId),
    INDEX idx_user (UserId),
    INDEX idx_role (RoleId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ContentItems table (pages, blog posts, etc.)
CREATE TABLE ContentItems (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ContentType VARCHAR(100) NOT NULL,
    Title VARCHAR(500) NOT NULL,
    Slug VARCHAR(500) NOT NULL,
    Summary TEXT,
    Body LONGTEXT,
    AuthorId INT NOT NULL,
    Status ENUM('Draft', 'Published', 'Archived') DEFAULT 'Draft',
    PublishedDate TIMESTAMP NULL,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ViewCount INT DEFAULT 0,
    IsDeleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (AuthorId) REFERENCES Users(Id),
    INDEX idx_contenttype (ContentType),
    INDEX idx_slug (Slug),
    INDEX idx_author (AuthorId),
    INDEX idx_status (Status),
    INDEX idx_published (PublishedDate),
    INDEX idx_created (CreatedDate),
    FULLTEXT idx_content (Title, Summary, Body)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ContentParts table (additional content metadata)
CREATE TABLE ContentParts (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ContentItemId INT NOT NULL,
    PartType VARCHAR(100) NOT NULL,
    PartName VARCHAR(100) NOT NULL,
    PartData JSON,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ContentItemId) REFERENCES ContentItems(Id) ON DELETE CASCADE,
    INDEX idx_contentitem (ContentItemId),
    INDEX idx_parttype (PartType),
    INDEX idx_partname (PartName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- MediaItems table
CREATE TABLE MediaItems (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    FileName VARCHAR(255) NOT NULL,
    OriginalFileName VARCHAR(255) NOT NULL,
    ContentType VARCHAR(100) NOT NULL,
    FileSize BIGINT NOT NULL,
    FilePath VARCHAR(1000) NOT NULL,
    AltText VARCHAR(500),
    Caption TEXT,
    UploadedById INT NOT NULL,
    UploadedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsDeleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (UploadedById) REFERENCES Users(Id),
    INDEX idx_filename (FileName),
    INDEX idx_contenttype (ContentType),
    INDEX idx_uploader (UploadedById),
    INDEX idx_uploaded (UploadedDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Settings table
CREATE TABLE Settings (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SettingKey VARCHAR(255) NOT NULL UNIQUE,
    SettingValue LONGTEXT,
    Category VARCHAR(100) DEFAULT 'General',
    Description TEXT,
    IsSystemSetting BOOLEAN DEFAULT FALSE,
    ModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_key (SettingKey),
    INDEX idx_category (Category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- AuditLogs table
CREATE TABLE AuditLogs (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT NULL,
    Action VARCHAR(100) NOT NULL,
    EntityType VARCHAR(100),
    EntityId INT,
    Details JSON,
    IpAddress VARCHAR(45),
    UserAgent TEXT,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE SET NULL,
    INDEX idx_user (UserId),
    INDEX idx_action (Action),
    INDEX idx_entity (EntityType, EntityId),
    INDEX idx_created (CreatedDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;