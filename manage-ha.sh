#!/bin/bash

# High Availability Tomcat Management Script

set -e

COMPOSE_FILE="docker-compose-ha.yml"
PROJECT_NAME="tomcat-ha"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 {start|stop|restart|status|scale|logs|health}"
    echo ""
    echo "Commands:"
    echo "  start    - Start all services"
    echo "  stop     - Stop all services"
    echo "  restart  - Restart all services"
    echo "  status   - Show service status"
    echo "  scale    - Scale Tomcat instances (usage: $0 scale 5)"
    echo "  logs     - Show logs (usage: $0 logs [service_name])"
    echo "  health   - Check health of all services"
    echo ""
}

start_services() {
    echo -e "${GREEN}Starting High Availability Tomcat Setup...${NC}"
    docker compose -f $COMPOSE_FILE -p $PROJECT_NAME up -d --build
    echo -e "${GREEN}Services started successfully!${NC}"
    echo ""
    echo "Access points:"
    echo "  - Load Balanced App: http://localhost"
    echo "  - Direct Access:     http://localhost:8080"
    echo "  - Manager App:       http://localhost/manager/html"
    echo "  - Host Manager:      http://localhost/host-manager/html"
    echo "  - Health Check:      http://localhost/health"
}

stop_services() {
    echo -e "${YELLOW}Stopping High Availability Tomcat Setup...${NC}"
    docker compose -f $COMPOSE_FILE -p $PROJECT_NAME down
    echo -e "${GREEN}Services stopped successfully!${NC}"
}

restart_services() {
    echo -e "${YELLOW}Restarting High Availability Tomcat Setup...${NC}"
    stop_services
    start_services
}

show_status() {
    echo -e "${BLUE}Service Status:${NC}"
    docker compose -f $COMPOSE_FILE -p $PROJECT_NAME ps
    echo ""
    echo -e "${BLUE}Container Health:${NC}"
    docker ps --filter "label=com.docker.compose.project=$PROJECT_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

scale_tomcat() {
    local replicas=${1:-3}
    echo -e "${BLUE}Scaling Tomcat to $replicas instances...${NC}"
    
    # Note: This is a simplified example. For true scaling, you'd need to modify the compose file
    # or use Docker Swarm mode for automatic scaling
    echo -e "${YELLOW}Note: Manual scaling requires modifying docker-compose-ha.yml${NC}"
    echo "Current setup supports 3 fixed instances (tomcat1, tomcat2, tomcat3)"
}

show_logs() {
    local service=${1:-""}
    if [ -z "$service" ]; then
        echo -e "${BLUE}Showing logs for all services:${NC}"
        docker compose -f $COMPOSE_FILE -p $PROJECT_NAME logs -f
    else
        echo -e "${BLUE}Showing logs for $service:${NC}"
        docker compose -f $COMPOSE_FILE -p $PROJECT_NAME logs -f $service
    fi
}

check_health() {
    echo -e "${BLUE}Health Check Status:${NC}"
    echo ""
    
    # Check Nginx load balancer
    echo -n "Load Balancer (Nginx): "
    if curl -s http://localhost/health > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Healthy${NC}"
    else
        echo -e "${RED}✗ Unhealthy${NC}"
    fi
    
    # Check individual Tomcat instances
    for i in {1..3}; do
        container_name="tomcat-webapp-$i"
        echo -n "Tomcat Instance $i: "
        
        if docker exec $container_name curl -s http://localhost:8080/ > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Healthy${NC}"
        else
            if docker ps | grep -q $container_name; then
                echo -e "${YELLOW}⚠ Running but not responding${NC}"
            else
                echo -e "${RED}✗ Not running${NC}"
            fi
        fi
    done
    
    echo ""
    echo -e "${BLUE}Load Balancer Backend Status:${NC}"
    # Try to get Nginx upstream status (if available)
    curl -s http://localhost/nginx_status 2>/dev/null || echo "Nginx status not available"
}

# Main script logic
case "${1:-""}" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    status)
        show_status
        ;;
    scale)
        scale_tomcat $2
        ;;
    logs)
        show_logs $2
        ;;
    health)
        check_health
        ;;
    *)
        print_usage
        exit 1
        ;;
esac
