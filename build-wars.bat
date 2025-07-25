@echo off
echo 🏗️ Building WAR files from sample applications...
echo ==================================================

set WARS_DIR=sample-wars
set BUILD_DIR=build

:: Create build directory
if not exist %BUILD_DIR% mkdir %BUILD_DIR%

:: Function to create WAR file (simulated with labels and goto)
goto :build_wars

:create_war
set app_name=%1
set app_dir=%WARS_DIR%\%app_name%

if exist "%app_dir%" (
    echo 📦 Building %app_name%.war...
    cd "%app_dir%"
    jar -cf "..\..\%BUILD_DIR%\%app_name%.war" *
    cd ..\..
    echo ✅ Created %BUILD_DIR%\%app_name%.war
) else (
    echo ❌ Directory %app_dir% not found
)
goto :eof

:build_wars
call :create_war hello-world
call :create_war api-demo
call :create_war file-upload

echo.
echo 📊 Build Summary:
echo ==================
dir %BUILD_DIR%\*.war 2>nul || echo No WAR files found

echo.
echo 🚀 Deployment Instructions:
echo ============================
echo 1. Copy WAR files to your Tomcat webapps directory
echo 2. Or use the Manager App to deploy them:
echo    - Go to http://localhost/manager/html
echo    - Login with tomcat/tomcat
echo    - Use 'Deploy' section to upload WAR files
echo.
echo 3. Access the applications:
echo    - Hello World: http://localhost/hello-world/
echo    - API Demo:    http://localhost/api-demo/
echo    - File Upload: http://localhost/file-upload/

pause
