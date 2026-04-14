# BookStore Microservices - System Verification Script (PowerShell)
# Tests if all 22 services are running and accessible

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  BookStore Microservices - System Verification" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Test container function
function Test-Container {
    param(
        [string]$name,
        [int]$port,
        [string]$path = "/"
    )
    
    try {
        $container = docker ps -a --filter "name=$name" --format "{{.Names}},{{.State}}" 2>&1
        if ($container) {
            $parts = $container -split ","
            $containerName = $parts[0]
            $state = $parts[1]
            
            if ($state -eq "running") {
                Write-Host "  ✓ $name (port $port) - RUNNING" -ForegroundColor Green
            } else {
                Write-Host "  ⏸ $name (port $port) - STOPPED" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  ✗ $name (port $port) - NOT FOUND" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ? $name (port $port) - ERROR" -ForegroundColor Red
    }
}

# Test API function
function Test-API {
    param(
        [string]$name,
        [string]$url
    )
    
    try {
        $response = Invoke-WebRequest -Uri $url -TimeoutSec 3 -ErrorAction SilentlyContinue
        Write-Host "  ✓ $name (HTTP 200)" -ForegroundColor Green
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.Value__
        if ($statusCode) {
            if ($statusCode -eq 404 -or $statusCode -eq 400) {
                Write-Host "  ✓ $name (HTTP $statusCode - Service responding)" -ForegroundColor Green
            } else {
                Write-Host "  ⚠ $name (HTTP $statusCode)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  ⏳ $name (Connection timeout - service starting)" -ForegroundColor Yellow
        }
    }
}

Write-Host "Checking Container Status..." -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# PostgreSQL
Test-Container "bookstore-postgres" 5432

Write-Host ""
Write-Host "Product Services (11):" -ForegroundColor Yellow
Test-Container "bookstore-book-service-1" 8002
Test-Container "bookstore-electronics-service-1" 8102
Test-Container "bookstore-audio-service-1" 8103
Test-Container "bookstore-software-service-1" 8104
Test-Container "bookstore-furniture-service-1" 8105
Test-Container "bookstore-sports-service-1" 8106
Test-Container "bookstore-toys-service-1" 8107
Test-Container "bookstore-fashion-service-1" 8108
Test-Container "bookstore-home-service-1" 8109
Test-Container "bookstore-gardening-service-1" 8110
Test-Container "bookstore-health-service-1" 8111

Write-Host ""
Write-Host "Supporting Services (10):" -ForegroundColor Yellow
Test-Container "bookstore-api-gateway-1" 8000
Test-Container "bookstore-customer-service-1" 8001
Test-Container "bookstore-cart-service-1" 8003
Test-Container "bookstore-staff-service-1" 8004
Test-Container "bookstore-manager-service-1" 8005
Test-Container "bookstore-catalog-service-1" 8006
Test-Container "bookstore-order-service-1" 8007
Test-Container "bookstore-pay-service-1" 8008
Test-Container "bookstore-ship-service-1" 8009
Test-Container "bookstore-comment-rate-service-1" 8010
Test-Container "bookstore-recommender-ai-service-1" 8011

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "Database Status" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Checking PostgreSQL databases..." -ForegroundColor Yellow
try {
    $dbList = docker compose exec postgres psql -U postgres -l 2>&1
    $productDbs = $dbList | Where-Object { $_ -match "_db" }
    $count = ($productDbs | Measure-Object).Count
    
    if ($count -ge 21) {
        Write-Host "  ✓ All 21 databases found in PostgreSQL" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Found $count databases (expected 21)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠ Database check inconclusive" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "Network Status" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Testing API Endpoints..." -ForegroundColor Yellow
Test-API "API Gateway" "http://localhost:8000/"
Test-API "Book Service" "http://localhost:8002/books/"
Test-API "Electronics Service" "http://localhost:8102/books/"
Test-API "Customer Service" "http://localhost:8001/"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "Quick Start Commands" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Start all services:"
Write-Host "   docker compose up -d" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Seed all product data:"
Write-Host "   .\scripts\seed_all.ps1 -Clear" -ForegroundColor Gray
Write-Host ""
Write-Host "3. View logs:"
Write-Host "   docker compose logs -f" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Stop all services:"
Write-Host "   docker compose down" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Access web interface:"
Write-Host "   http://localhost:8000" -ForegroundColor Cyan
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "For more information, see DEPLOYMENT_STATUS.md" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
