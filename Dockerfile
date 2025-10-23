# Use the official ASP.NET Framework runtime image
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

# Set the working directory
WORKDIR /inetpub/wwwroot

# Copy the application files
COPY src/OrchardLite.Web/ .

# Install MySQL Connector/NET
RUN powershell -Command \
    "Invoke-WebRequest -Uri 'https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-8.0.33.msi' -OutFile 'mysql-connector.msi'; \
     Start-Process msiexec.exe -ArgumentList '/i mysql-connector.msi /quiet' -Wait; \
     Remove-Item mysql-connector.msi"

# Copy MySQL DLL to bin directory
RUN powershell -Command \
    "New-Item -ItemType Directory -Force -Path 'bin'; \
     Copy-Item 'C:\\Program Files (x86)\\MySQL\\MySQL Connector Net 8.0.33\\Assemblies\\v4.8\\MySql.Data.dll' 'bin\\MySql.Data.dll' -ErrorAction SilentlyContinue; \
     Copy-Item 'C:\\Program Files\\MySQL\\MySQL Connector Net 8.0.33\\Assemblies\\v4.8\\MySql.Data.dll' 'bin\\MySql.Data.dll' -ErrorAction SilentlyContinue"

# Expose port 80
EXPOSE 80

# The base image already has IIS configured, so the application should run automatically