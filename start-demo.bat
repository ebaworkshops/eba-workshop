@echo off
echo 🚀 Starting OrchardLite CMS Demo Environment
echo ============================================

REM Check if Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Docker is not running. Please start Docker and try again.
    pause
    exit /b 1
)

echo 📦 Building and starting containers...
docker compose up --build -d

echo ⏳ Waiting for services to be ready...
timeout /t 10 /nobreak >nul

echo 🔍 Checking services...
timeout /t 5 /nobreak >nul

echo.
echo 🎉 OrchardLite CMS Demo is ready!
echo ==================================
echo.
echo 🌐 Application URLs:
echo    • Home Page:        http://localhost:8080
echo    • Blog:             http://localhost:8080/blog
echo    • Admin Dashboard:  http://localhost:8080/admin
echo    • Database Info:    http://localhost:8080/admin/databaseinfo
echo    • About Page:       http://localhost:8080/about
echo.
echo 🗄️  Database Management:
echo    • phpMyAdmin:       http://localhost:8081
echo    • Username:         orcharduser
echo    • Password:         OrchardPassword123!
echo.
echo 📊 Sample Data Included:
echo    • 4 Users with different roles
echo    • 5 Content items (pages and blog posts)
echo    • 3 Media items
echo    • 8 System settings
echo    • 7 Audit log entries
echo.
echo 🛑 To stop the demo:
echo    docker compose down
echo.
echo 🔧 To view logs:
echo    docker compose logs -f
echo.
pause