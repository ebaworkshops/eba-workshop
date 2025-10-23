#!/bin/bash
echo "🗄️ OrchardLite CMS - Local Database Test"
echo "========================================"

# Check if MySQL is available
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL client not found. Please install MySQL or use Docker setup."
    echo ""
    echo "Install options:"
    echo "• macOS: brew install mysql"
    echo "• Ubuntu: sudo apt-get install mysql-client"
    echo "• Or use Docker setup when Docker Desktop is running"
    exit 1
fi

echo "📋 This script will help you set up the OrchardLite database locally"
echo ""
echo "Prerequisites:"
echo "• MySQL server running locally"
echo "• MySQL credentials ready"
echo ""

read -p "Enter MySQL host (default: localhost): " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -p "Enter MySQL username (default: root): " DB_USER
DB_USER=${DB_USER:-root}

read -s -p "Enter MySQL password: " DB_PASSWORD
echo ""

read -p "Enter MySQL port (default: 3306): " DB_PORT
DB_PORT=${DB_PORT:-3306}

echo ""
echo "🔍 Testing MySQL connection..."

if mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; then
    echo "✅ MySQL connection successful!"
else
    echo "❌ MySQL connection failed. Please check your credentials."
    exit 1
fi

echo ""
echo "📊 Creating OrchardLite database and user..."

# Create database and user
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" << EOF
CREATE DATABASE IF NOT EXISTS OrchardLiteDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'orcharduser'@'%' IDENTIFIED BY 'OrchardPassword123!';
GRANT ALL PRIVILEGES ON OrchardLiteDB.* TO 'orcharduser'@'%';
FLUSH PRIVILEGES;
EOF

echo "✅ Database and user created!"

echo ""
echo "🏗️ Creating database schema..."
if mysql -h "$DB_HOST" -P "$DB_PORT" -u orcharduser -pOrchardPassword123! OrchardLiteDB < database/schema.sql; then
    echo "✅ Schema created successfully!"
else
    echo "❌ Schema creation failed!"
    exit 1
fi

echo ""
echo "📝 Loading sample data..."
if mysql -h "$DB_HOST" -P "$DB_PORT" -u orcharduser -pOrchardPassword123! OrchardLiteDB < database/sample-data.sql; then
    echo "✅ Sample data loaded successfully!"
else
    echo "❌ Sample data loading failed!"
    exit 1
fi

echo ""
echo "🎉 OrchardLite database setup complete!"
echo "======================================"
echo ""
echo "Database Details:"
echo "• Host: $DB_HOST"
echo "• Port: $DB_PORT"
echo "• Database: OrchardLiteDB"
echo "• Username: orcharduser"
echo "• Password: OrchardPassword123!"
echo ""
echo "📊 Database Statistics:"
mysql -h "$DB_HOST" -P "$DB_PORT" -u orcharduser -pOrchardPassword123! OrchardLiteDB -e "
SELECT 
    TABLE_NAME as 'Table',
    TABLE_ROWS as 'Rows'
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'OrchardLiteDB' 
ORDER BY TABLE_NAME;
"

echo ""
echo "🔧 Next Steps:"
echo "1. Update your .NET application's connection string to:"
echo "   Server=$DB_HOST;Database=OrchardLiteDB;Uid=orcharduser;Pwd=OrchardPassword123!;Port=$DB_PORT;CharSet=utf8mb4;"
echo ""
echo "2. Or wait for Docker Desktop to start and use:"
echo "   ./start-demo.sh"
echo ""