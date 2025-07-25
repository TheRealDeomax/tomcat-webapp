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
- `docker-compose.yml` - Docker Compose configuration
