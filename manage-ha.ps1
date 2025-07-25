# High Availability Tomcat Management Script for Windows PowerShell

param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "restart", "status", "logs", "health", "help")]
    [string]$Action = "help",
    
    [Parameter(Position=1)]
    [string]$Service = ""
)

$COMPOSE_FILE = "docker-compose-ha.yml"
$PROJECT_NAME = "tomcat-ha"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Show-Usage {
    Write-ColorOutput "Usage: .\manage-ha.ps1 {start|stop|restart|status|logs|health}" "Yellow"
    Write-Host ""
    Write-ColorOutput "Commands:" "Cyan"
    Write-Host "  start    - Start all services"
    Write-Host "  stop     - Stop all services"
    Write-Host "  restart  - Restart all services"
    Write-Host "  status   - Show service status"
    Write-Host "  logs     - Show logs (usage: .\manage-ha.ps1 logs [service_name])"
    Write-Host "  health   - Check health of all services"
    Write-Host ""
}

function Start-Services {
    Write-ColorOutput "Starting High Availability Tomcat Setup..." "Green"
    docker compose -f $COMPOSE_FILE -p $PROJECT_NAME up -d --build
    Write-ColorOutput "Services started successfully!" "Green"
    Write-Host ""
    Write-ColorOutput "Access points:" "Cyan"
    Write-Host "  - Load Balanced App: http://localhost"
    Write-Host "  - Direct Access:     http://localhost:8080"
    Write-Host "  - Manager App:       http://localhost/manager/html"
    Write-Host "  - Host Manager:      http://localhost/host-manager/html"
    Write-Host "  - Health Check:      http://localhost/health"
}

function Stop-Services {
    Write-ColorOutput "Stopping High Availability Tomcat Setup..." "Yellow"
    docker compose -f $COMPOSE_FILE -p $PROJECT_NAME down
    Write-ColorOutput "Services stopped successfully!" "Green"
}

function Restart-Services {
    Write-ColorOutput "Restarting High Availability Tomcat Setup..." "Yellow"
    Stop-Services
    Start-Services
}

function Show-Status {
    Write-ColorOutput "Service Status:" "Cyan"
    docker compose -f $COMPOSE_FILE -p $PROJECT_NAME ps
    Write-Host ""
    Write-ColorOutput "Container Health:" "Cyan"
    docker ps --filter "label=com.docker.compose.project=$PROJECT_NAME" --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}"
}

function Show-Logs {
    param([string]$ServiceName)
    
    if ([string]::IsNullOrEmpty($ServiceName)) {
        Write-ColorOutput "Showing logs for all services:" "Cyan"
        docker compose -f $COMPOSE_FILE -p $PROJECT_NAME logs -f
    } else {
        Write-ColorOutput "Showing logs for ${ServiceName}" "Cyan"
        docker compose -f $COMPOSE_FILE -p $PROJECT_NAME logs -f $ServiceName
    }
}

function Test-Health {
    Write-ColorOutput "Health Check Status:" "Cyan"
    Write-Host ""
    
    # Check Nginx load balancer
    Write-Host "Load Balancer (Nginx): " -NoNewline
    try {
        $response = Invoke-WebRequest -Uri "http://localhost/health" -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-ColorOutput "✓ Healthy" "Green"
        } else {
            Write-ColorOutput "✗ Unhealthy" "Red"
        }
    } catch {
        Write-ColorOutput "✗ Unhealthy" "Red"
    }
    
    # Check individual Tomcat instances
    for ($i = 1; $i -le 3; $i++) {
        $containerName = "tomcat-webapp-$i"
        Write-Host "Tomcat Instance ${i}: " -NoNewline
        
        try {
            docker exec $containerName curl -s http://localhost:8080/ 2>$null | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "✓ Healthy" "Green"
            } else {
                # Check if container is running
                $isRunning = docker ps --format "{{.Names}}" | Select-String -Pattern $containerName
                if ($isRunning) {
                    Write-ColorOutput "⚠ Running but not responding" "Yellow"
                } else {
                    Write-ColorOutput "✗ Not running" "Red"
                }
            }
        } catch {
            Write-ColorOutput "✗ Error checking" "Red"
        }
    }
    
    Write-Host ""
    Write-ColorOutput "Load Balancer Backend Status:" "Cyan"
    try {
        $nginxStatus = Invoke-WebRequest -Uri "http://localhost/nginx_status" -UseBasicParsing -TimeoutSec 5
        Write-Host $nginxStatus.Content
    } catch {
        Write-Host "Nginx status not available"
    }
}

# Main script logic
switch ($Action.ToLower()) {
    "start" {
        Start-Services
    }
    "stop" {
        Stop-Services
    }
    "restart" {
        Restart-Services
    }
    "status" {
        Show-Status
    }
    "logs" {
        Show-Logs $Service
    }
    "health" {
        Test-Health
    }
    default {
        Show-Usage
        exit 1
    }
}
