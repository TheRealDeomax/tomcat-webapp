@echo off
echo 🔐 Generating SSL Certificate for Development
echo =============================================

REM Create ssl directory
if not exist ssl mkdir ssl

REM Generate private key (requires OpenSSL)
openssl genrsa -out ssl/nginx.key 2048

REM Generate certificate signing request
openssl req -new -key ssl/nginx.key -out ssl/nginx.csr -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"

REM Generate self-signed certificate
openssl x509 -req -days 365 -in ssl/nginx.csr -signkey ssl/nginx.key -out ssl/nginx.crt

echo ✅ SSL Certificate generated in ssl\ directory
echo 📄 Certificate: ssl\nginx.crt
echo 🔑 Private Key: ssl\nginx.key
echo.
echo ⚠️  This is a self-signed certificate for development only!
echo 🌐 Access your site at: https://localhost
echo.
pause
