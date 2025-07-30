#!/usr/bin/env pwsh

Write-Host "🔐 Setting up HTTPS for Tomcat Load Balancer" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Check if OpenSSL is available
$openssl = Get-Command openssl -ErrorAction SilentlyContinue
if (-not $openssl) {
    Write-Host "❌ OpenSSL not found!" -ForegroundColor Red
    Write-Host "📥 Please install OpenSSL:" -ForegroundColor Yellow
    Write-Host "   - Windows: Download from https://slproweb.com/products/Win32OpenSSL.html" -ForegroundColor Yellow
    Write-Host "   - Or use Chocolatey: choco install openssl" -ForegroundColor Yellow
    Write-Host "   - Or use Scoop: scoop install openssl" -ForegroundColor Yellow
    exit 1
}

# Create SSL directory
if (-not (Test-Path "ssl")) {
    New-Item -ItemType Directory -Path "ssl" | Out-Null
    Write-Host "📁 Created ssl/ directory" -ForegroundColor Green
}

# Generate private key
Write-Host "🔑 Generating private key..." -ForegroundColor Cyan
& openssl genrsa -out ssl/nginx.key 2048

# Generate certificate signing request
Write-Host "📝 Generating certificate signing request..." -ForegroundColor Cyan
& openssl req -new -key ssl/nginx.key -out ssl/nginx.csr -subj "/C=US/ST=Development/L=Local/O=Tomcat-Demo/OU=IT/CN=localhost"

# Generate self-signed certificate
Write-Host "📄 Generating self-signed certificate..." -ForegroundColor Cyan
& openssl x509 -req -days 365 -in ssl/nginx.csr -signkey ssl/nginx.key -out ssl/nginx.crt

# Clean up CSR file
Remove-Item ssl/nginx.csr -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "✅ SSL Certificate generated successfully!" -ForegroundColor Green
Write-Host "📄 Certificate: ssl/nginx.crt" -ForegroundColor White
Write-Host "🔑 Private Key: ssl/nginx.key" -ForegroundColor White
Write-Host ""

# Start SSL-enabled setup
Write-Host "🚀 Starting HTTPS-enabled Tomcat cluster..." -ForegroundColor Cyan
Write-Host "⏹️  Stopping current setup..." -ForegroundColor Yellow
& docker compose -f docker-compose-ha.yml down

Write-Host "🔧 Starting SSL setup..." -ForegroundColor Yellow
& docker compose -f docker-compose-ssl.yml up -d --build

Write-Host ""
Write-Host "🎉 HTTPS Setup Complete!" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green
Write-Host "🔒 HTTPS (Secure):   https://localhost" -ForegroundColor Green
Write-Host "🌐 HTTP (Redirects): http://localhost" -ForegroundColor Yellow
Write-Host "🔧 Legacy HTTP:      http://localhost:8080" -ForegroundColor White
Write-Host "👤 Manager App:      https://localhost/manager/html" -ForegroundColor Cyan
Write-Host "📁 File Upload:      https://localhost/file-upload/" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  Note: You'll see a security warning because this is a self-signed certificate." -ForegroundColor Yellow
Write-Host "   Click 'Advanced' then 'Proceed to localhost (unsafe)' to continue." -ForegroundColor Yellow
Write-Host ""
Write-Host "🏢 For production, use Let's Encrypt or a commercial certificate." -ForegroundColor Magenta
