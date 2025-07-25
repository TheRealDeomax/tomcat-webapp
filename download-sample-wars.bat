@echo off
echo 📦 Downloading Popular WAR Files for Testing
echo =============================================

set DOWNLOAD_DIR=downloaded-wars
if not exist %DOWNLOAD_DIR% mkdir %DOWNLOAD_DIR%

echo.
echo 🌐 Popular WAR files you can download and test:
echo ===============================================
echo.
echo 1. 📊 Sample WAR from Apache Tomcat:
echo    https://tomcat.apache.org/tomcat-9.0-doc/appdev/sample/
echo.
echo 2. 🔍 Jenkins WAR (if you want to run Jenkins):
echo    https://get.jenkins.io/war-stable/latest/jenkins.war
echo.
echo 3. 📈 Sample Spring Boot WAR applications:
echo    https://github.com/spring-projects/spring-boot/tree/main/spring-boot-samples
echo.
echo 4. 🎯 Simple Web Applications:
echo    https://github.com/javaee/tutorial-examples
echo.
echo 💡 To test with your own WAR files:
echo ===================================
echo 1. Place your WAR file in the downloads folder
echo 2. Copy it to Tomcat: docker cp yourapp.war tomcat-webapp-1:/usr/local/tomcat/webapps/
echo 3. Or use the Manager App at http://localhost/manager/html
echo.
echo 🏗️ Currently Available Sample Apps:
echo ===================================
echo - Hello World:  http://localhost/hello-world/
echo - API Demo:     http://localhost/api-demo/
echo - File Upload:  http://localhost/file-upload/
echo.

:: Simple example downloads (if curl is available)
where curl >nul 2>nul
if %errorlevel% == 0 (
    echo 📥 Downloading sample WAR file...
    curl -L -o "%DOWNLOAD_DIR%\sample.war" "https://tomcat.apache.org/tomcat-9.0-doc/appdev/sample/sample.war" 2>nul
    if exist "%DOWNLOAD_DIR%\sample.war" (
        echo ✅ Downloaded sample.war
        echo 📋 To deploy: docker cp %DOWNLOAD_DIR%\sample.war tomcat-webapp-1:/usr/local/tomcat/webapps/
    ) else (
        echo ℹ️ Note: Download may have failed or URL changed
    )
) else (
    echo ℹ️ curl not available - manual download required
)

echo.
pause
