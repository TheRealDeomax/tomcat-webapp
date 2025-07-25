# Use the official Tomcat image as base
FROM tomcat:9.0-jdk11-openjdk

# Maintainer information
LABEL maintainer="your-email@example.com"

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Remove default webapps to clean up
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy custom tomcat-users.xml with admin user configuration
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

# Re-enable the manager and host-manager webapps
RUN cp -r /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/
RUN cp -r /usr/local/tomcat/webapps.dist/host-manager /usr/local/tomcat/webapps/

# Copy context.xml to allow access to both manager and host-manager from any IP
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
COPY context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml

# Create a sample ROOT webapp
RUN mkdir -p /usr/local/tomcat/webapps/ROOT
COPY index.html /usr/local/tomcat/webapps/ROOT/

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
