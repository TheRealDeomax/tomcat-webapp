#!/bin/bash
# Generate SSL certificate for development

echo "🔐 Generating SSL Certificate for Development"
echo "============================================="

# Create ssl directory
mkdir -p ssl

# Generate private key
openssl genrsa -out ssl/nginx.key 2048

# Generate certificate signing request
openssl req -new -key ssl/nginx.key -out ssl/nginx.csr -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"

# Generate self-signed certificate
openssl x509 -req -days 365 -in ssl/nginx.csr -signkey ssl/nginx.key -out ssl/nginx.crt

# Set permissions
chmod 600 ssl/nginx.key
chmod 644 ssl/nginx.crt

echo "✅ SSL Certificate generated in ssl/ directory"
echo "📄 Certificate: ssl/nginx.crt"
echo "🔑 Private Key: ssl/nginx.key"
echo ""
echo "⚠️  This is a self-signed certificate for development only!"
echo "🌐 Access your site at: https://localhost"
