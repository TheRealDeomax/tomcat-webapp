# Apache Tomcat Docker Container

This Docker setup creates an Apache Tomcat server with management capabilities and an admin user.

## Features

- Apache Tomcat 9.0 with OpenJDK 11
- Admin user configured: `tomcat/tomcat`
- Manager and Host Manager applications enabled
- Accessible from any IP address (not restricted to localhost)
- Custom welcome page

## Admin Credentials

- **Username:** `tomcat`
- **Password:** `tomcat`

## Quick Start

### Using Docker

1. Build the image:
   ```bash
   docker build -t tomcat-webapp .
   ```

2. Run the container:
   ```bash
   docker run -d -p 8080:8080 --name tomcat-webapp tomcat-webapp
   ```

### Using Docker Compose

1. Start the service:
   ```bash
   docker-compose up -d
   ```

2. Stop the service:
   ```bash
   docker-compose down
   ```

## Access Points

- **Main Application:** http://localhost:8080
- **Manager App:** http://localhost:8080/manager/html
- **Host Manager:** http://localhost:8080/host-manager/html

## Security Note

⚠️ **Important:** This configuration is intended for development/testing purposes. The default password and unrestricted access should be changed for production use.

For production:
1. Change the admin password in `tomcat-users.xml`
2. Restrict access in `context.xml` by configuring the RemoteAddrValve
3. Use HTTPS/SSL configuration
4. Consider using environment variables for credentials

## File Structure

- `Dockerfile` - Docker image configuration
- `tomcat-users.xml` - User and role configuration
- `context.xml` - Manager app access configuration
- `index.html` - Custom welcome page
- `docker-compose.yml` - Single instance Docker Compose configuration
- `docker-compose-ha.yml` - High Availability Docker Compose configuration
- `nginx.conf` - Load balancer configuration
- `manage-ha.sh` - HA management script (Linux/macOS)
- `manage-ha.ps1` - HA management script (Windows PowerShell)

## High Availability Setup

For production environments, you can run multiple Tomcat instances behind a load balancer for high availability and better performance.

### Features

- **3 Tomcat instances** running simultaneously
- **Nginx load balancer** distributing traffic
- **Health checks** for automatic failover
- **Auto-restart** if containers fail
- **Round-robin load balancing**

### Quick Start (HA)

#### Using PowerShell (Windows)
```powershell
# Start HA setup
.\manage-ha.ps1 start

# Check status
.\manage-ha.ps1 status

# Check health
.\manage-ha.ps1 health

# Stop HA setup
.\manage-ha.ps1 stop
```

#### Using Bash (Linux/macOS)
```bash
# Make script executable
chmod +x manage-ha.sh

# Start HA setup
./manage-ha.sh start

# Check status
./manage-ha.sh status

# Check health
./manage-ha.sh health

# Stop HA setup
./manage-ha.sh stop
```

#### Manual Docker Compose
```bash
# Start HA setup
docker compose -f docker-compose-ha.yml up -d --build

# Stop HA setup
docker compose -f docker-compose-ha.yml down
```

### HA Access Points

When running the HA setup:

- **Load Balanced App**: http://localhost (port 80)
- **Load Balanced App**: http://localhost:8080 (port 8080)
- **Manager App**: http://localhost/manager/html
- **Host Manager**: http://localhost/host-manager/html
- **Health Check**: http://localhost/health
- **Nginx Status**: http://localhost/nginx_status (restricted access)

### Benefits

1. **High Availability**: If one Tomcat instance fails, others continue serving
2. **Load Distribution**: Traffic is distributed across multiple instances
3. **Zero Downtime**: Rolling updates possible
4. **Scalability**: Easy to add more instances
5. **Health Monitoring**: Automatic health checks and failover
6. **Shared Storage**: All instances share the same file upload storage

### Shared Volume Configuration

The HA setup uses a shared Docker volume (`shared-uploads`) that is mounted to `/usr/local/tomcat/webapps/file-upload/uploads/` in all Tomcat instances. This means:

- **Consistent File Access**: Files uploaded to any instance are immediately available from all instances
- **Load Balancer Friendly**: Users can upload to one server and download from another
- **Data Persistence**: Files survive container restarts and scaling operations
- **Simplified Management**: Single storage location for all uploaded files

## Sample Applications

This setup includes several sample WAR applications for testing:

### 🌍 Hello World App
- **URL**: http://localhost/hello-world/
- **Features**: Basic web app with JSP pages, server info display
- **Test JSP**: http://localhost/hello-world/test.jsp

### 🚀 API Demo App  
- **URL**: http://localhost/api-demo/
- **Features**: REST API endpoints returning JSON
- **Endpoints**:
  - `/api-demo/api/time` - Current server time
  - `/api-demo/api/info` - Server information
  - `/api-demo/api/random` - Random data generator
  - `/api-demo/api/headers` - Request headers

### 📁 File Upload Demo
- **URL**: http://localhost/file-upload/
- **Features**: Drag & drop file upload with progress, persistent file storage
- **Limits**: 10MB per file, 20MB total
- **Storage**: Files saved to shared volume accessible by all Tomcat instances
- **Management**: View uploaded files at http://localhost/file-upload/files.jsp
- **Actions**: Download and delete uploaded files
- **Shared Storage**: Files uploaded to any instance are visible from all instances

### Deployment Commands

```powershell
# Deploy sample apps to running containers
.\deploy-apps.bat

# Download additional sample WARs
.\download-sample-wars.bat

# Manual deployment to specific container
docker cp yourapp.war tomcat-webapp-1:/usr/local/tomcat/webapps/
```
