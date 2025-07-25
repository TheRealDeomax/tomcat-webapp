@echo off
echo 🚀 High Availability Tomcat Demo
echo =================================
echo.

echo 📊 Current Status:
docker compose -f docker-compose-ha.yml ps --format "table {{.Service}}	{{.Status}}	{{.Ports}}"
echo.

echo 🌐 Testing Load Balancing (making 10 requests):
echo Each request should be served by a different Tomcat instance
echo.

for /L %%i in (1,1,10) do (
    echo | set /p="Request %%i: "
    curl -s http://localhost/ | findstr "Instance" >nul
    if errorlevel 1 (
        echo ✓ Served by Load Balancer
    ) else (
        echo ✓ Served by Tomcat Instance
    )
    timeout /t 1 /nobreak >nul
)

echo.
echo 🔍 Health Check:
curl -s http://localhost/health
echo.
echo.

echo 📈 Available Endpoints:
echo   • Main App:        http://localhost
echo   • Alternative:     http://localhost:8080
echo   • Manager App:     http://localhost/manager/html
echo   • Host Manager:    http://localhost/host-manager/html
echo   • Health Check:    http://localhost/health
echo.

echo 🔧 Management Commands:
echo   • Start HA:        docker compose -f docker-compose-ha.yml up -d
echo   • Stop HA:         docker compose -f docker-compose-ha.yml down
echo   • View Logs:       docker compose -f docker-compose-ha.yml logs -f
echo   • Scale Test:      Kill a container and watch others continue serving
echo.

echo 💡 Try this: Stop one Tomcat instance and see how others keep serving:
echo    docker stop tomcat-webapp-1
echo    curl http://localhost/  # Still works!
echo    docker start tomcat-webapp-1  # Bring it back
echo.

pause
