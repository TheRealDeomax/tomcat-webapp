#!/bin/bash

# Build WAR files from sample applications

echo "🏗️  Building WAR files from sample applications..."
echo "=================================================="

WARS_DIR="sample-wars"
BUILD_DIR="build"

# Create build directory
mkdir -p $BUILD_DIR

# Function to create WAR file
create_war() {
    local app_name=$1
    local app_dir="$WARS_DIR/$app_name"
    
    if [ -d "$app_dir" ]; then
        echo "📦 Building $app_name.war..."
        cd "$app_dir"
        jar -cf "../../$BUILD_DIR/$app_name.war" *
        cd ../..
        echo "✅ Created $BUILD_DIR/$app_name.war"
    else
        echo "❌ Directory $app_dir not found"
    fi
}

# Build all WAR files
create_war "hello-world"
create_war "api-demo"
create_war "file-upload"

echo ""
echo "📊 Build Summary:"
echo "=================="
ls -la $BUILD_DIR/*.war 2>/dev/null || echo "No WAR files found"

echo ""
echo "🚀 Deployment Instructions:"
echo "============================"
echo "1. Copy WAR files to your Tomcat webapps directory"
echo "2. Or use the Manager App to deploy them:"
echo "   - Go to http://localhost/manager/html"
echo "   - Login with tomcat/tomcat"
echo "   - Use 'Deploy' section to upload WAR files"
echo ""
echo "3. Access the applications:"
echo "   - Hello World: http://localhost/hello-world/"
echo "   - API Demo:    http://localhost/api-demo/"
echo "   - File Upload: http://localhost/file-upload/"
