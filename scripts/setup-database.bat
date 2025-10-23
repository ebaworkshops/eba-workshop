@echo off
echo OrchardLite CMS - Database Setup
echo ================================

echo.
echo This script will set up the OrchardLite database for local testing.
echo.
echo Prerequisites:
echo - MySQL Server 8.0 or later installed and running
echo - MySQL command line tools in PATH
echo.

set /p MYSQL_ROOT_PASSWORD="Enter MySQL root password: "

echo.
echo Creating database and user...
mysql -u root -p%MYSQL_ROOT_PASSWORD% < setup-local-database.sql

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create database and user
    pause
    exit /b 1
)

echo.
echo Creating database schema...
mysql -u orcharduser -pOrchardPassword123! OrchardLiteDB < ..\database\schema.sql

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create database schema
    pause
    exit /b 1
)

echo.
echo Loading sample data...
mysql -u orcharduser -pOrchardPassword123! OrchardLiteDB < ..\database\sample-data.sql

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to load sample data
    pause
    exit /b 1
)

echo.
echo ================================
echo Database setup completed successfully!
echo ================================
echo.
echo Database: OrchardLiteDB
echo User: orcharduser
echo Password: OrchardPassword123!
echo.
echo You can now open the solution in Visual Studio and run the application.
echo.
pause