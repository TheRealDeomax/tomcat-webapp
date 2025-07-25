#!/bin/bash

# Demo script to show load balancing in action

echo "🚀 High Availability Tomcat Demo"
echo "================================="
echo ""

echo "📊 Current Status:"
docker compose -f docker-compose-ha.yml ps --format "table {{.Service}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "🌐 Testing Load Balancing (making 10 requests):"
echo "Each request should be served by a different Tomcat instance"
echo ""

for i in {1..10}; do
    echo -n "Request $i: "
    response=$(curl -s http://localhost/ | grep -o "Instance [0-9]*" | head -1)
    if [ -n "$response" ]; then
        echo "✓ Served by $response"
    else
        echo "✓ Served by Load Balancer"
    fi
    sleep 1
done

echo ""
echo "🔍 Health Check:"
echo "Load Balancer Health: $(curl -s http://localhost/health)"
echo ""

echo "📈 Available Endpoints:"
echo "  • Main App:        http://localhost"
echo "  • Alternative:     http://localhost:8080"
echo "  • Manager App:     http://localhost/manager/html"
echo "  • Host Manager:    http://localhost/host-manager/html"
echo "  • Health Check:    http://localhost/health"
echo ""

echo "🔧 Management Commands:"
echo "  • Start HA:        docker compose -f docker-compose-ha.yml up -d"
echo "  • Stop HA:         docker compose -f docker-compose-ha.yml down"
echo "  • View Logs:       docker compose -f docker-compose-ha.yml logs -f"
echo "  • Scale Test:      Kill a container and watch others continue serving"
echo ""

echo "💡 Try this: Stop one Tomcat instance and see how others keep serving:"
echo "   docker stop tomcat-webapp-1"
echo "   curl http://localhost/  # Still works!"
echo "   docker start tomcat-webapp-1  # Bring it back"
