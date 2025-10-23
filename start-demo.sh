#!/bin/bash
echo "🚀 Starting OrchardLite CMS Demo Environment"
echo "============================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "📦 Building and starting containers..."
docker compose up --build -d

echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if MySQL is ready
echo "🔍 Checking MySQL connection..."
for i in {1..30}; do
    if docker compose exec -T mysql mysqladmin ping -h localhost -u orcharduser -pOrchardPassword123! --silent; then
        echo "✅ MySQL is ready!"
        break
    fi
    echo "⏳ Waiting for MySQL... ($i/30)"
    sleep 2
done

# Check if web application is ready
echo "🔍 Checking web application..."
for i in {1..20}; do
    if curl -s http://localhost:8080 > /dev/null; then
        echo "✅ Web application is ready!"
        break
    fi
    echo "⏳ Waiting for web application... ($i/20)"
    sleep 2
done

echo ""
echo "🎉 OrchardLite CMS Demo is ready!"
echo "=================================="
echo ""
echo "🌐 Application URLs:"
echo "   • Home Page:        http://localhost:8080"
echo "   • Blog:             http://localhost:8080/blog"
echo "   • Admin Dashboard:  http://localhost:8080/admin"
echo "   • Database Info:    http://localhost:8080/admin/databaseinfo"
echo "   • About Page:       http://localhost:8080/about"
echo ""
echo "🗄️  Database Management:"
echo "   • phpMyAdmin:       http://localhost:8081"
echo "   • Username:         orcharduser"
echo "   • Password:         OrchardPassword123!"
echo ""
echo "📊 Sample Data Included:"
echo "   • 4 Users with different roles"
echo "   • 5 Content items (pages and blog posts)"
echo "   • 3 Media items"
echo "   • 8 System settings"
echo "   • 7 Audit log entries"
echo ""
echo "🛑 To stop the demo:"
echo "   docker compose down"
echo ""
echo "🔧 To view logs:"
echo "   docker compose logs -f"
echo ""