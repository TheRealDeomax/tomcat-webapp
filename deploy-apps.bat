@echo off
echo 🚀 Deploying Sample Applications to Tomcat
echo ============================================

:: Check if containers are running
docker ps | findstr tomcat-webapp >nul
if errorlevel 1 (
    echo ❌ Tomcat containers are not running
    echo Please start them first with:
    echo    docker compose -f docker-compose-ha.yml up -d
    echo    OR
    echo    docker compose up -d
    pause
    exit /b 1
)

echo 📁 Copying applications to running Tomcat containers...

:: Copy to all three Tomcat instances in HA setup
for /L %%i in (1,1,3) do (
    echo 📦 Deploying to tomcat-webapp-%%i...
    
    docker cp sample-wars\hello-world tomcat-webapp-%%i:/usr/local/tomcat/webapps/
    docker cp sample-wars\api-demo tomcat-webapp-%%i:/usr/local/tomcat/webapps/
    docker cp sample-wars\file-upload tomcat-webapp-%%i:/usr/local/tomcat/webapps/
    
    echo ✅ Deployed to tomcat-webapp-%%i
)

echo.
echo ✅ All applications deployed successfully!
echo.
echo 🌐 Access your applications:
echo ==============================
echo - Hello World:  http://localhost/hello-world/
echo - API Demo:     http://localhost/api-demo/
echo - File Upload:  http://localhost/file-upload/
echo.
echo 🔧 Manager App: http://localhost/manager/html (tomcat/tomcat)
echo.

pause
