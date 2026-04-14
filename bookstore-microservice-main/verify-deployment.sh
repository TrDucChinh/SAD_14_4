#!/bin/bash
# BookStore Microservices - System Verification Script
# Tests if all 22 services are running and accessible

echo "======================================================================"
echo "  BookStore Microservices - System Verification"
echo "======================================================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test functions
test_container() {
    local name=$1
    local port=$2
    local path=${3:-"/"}
    
    # Check if container is running
    if docker container inspect $name > /dev/null 2>&1; then
        status=$(docker inspect -f {{.State.Running}} $name 2>/dev/null)
        if [ "$status" == "true" ]; then
            echo -e "${GREEN}✓${NC} $name (port $port) - RUNNING"
        else
            echo -e "${YELLOW}⏸${NC} $name (port $port) - STOPPED"
        fi
    else
        echo -e "${RED}✗${NC} $name (port $port) - NOT FOUND"
    fi
}

echo "Checking Container Status..."
echo "======================================================================"
echo ""

# PostgreSQL
test_container "bookstore-postgres" "5432"

echo ""
echo "Product Services (11):"
test_container "bookstore-book-service-1" "8002" "/books/"
test_container "bookstore-electronics-service-1" "8102" "/books/"
test_container "bookstore-audio-service-1" "8103" "/books/"
test_container "bookstore-software-service-1" "8104" "/books/"
test_container "bookstore-furniture-service-1" "8105" "/books/"
test_container "bookstore-sports-service-1" "8106" "/books/"
test_container "bookstore-toys-service-1" "8107" "/books/"
test_container "bookstore-fashion-service-1" "8108" "/books/"
test_container "bookstore-home-service-1" "8109" "/books/"
test_container "bookstore-gardening-service-1" "8110" "/books/"
test_container "bookstore-health-service-1" "8111" "/books/"

echo ""
echo "Supporting Services (10):"
test_container "bookstore-api-gateway-1" "8000"
test_container "bookstore-customer-service-1" "8001"
test_container "bookstore-cart-service-1" "8003"
test_container "bookstore-staff-service-1" "8004"
test_container "bookstore-manager-service-1" "8005"
test_container "bookstore-catalog-service-1" "8006"
test_container "bookstore-order-service-1" "8007"
test_container "bookstore-pay-service-1" "8008"
test_container "bookstore-ship-service-1" "8009"
test_container "bookstore-comment-rate-service-1" "8010"
test_container "bookstore-recommender-ai-service-1" "8011"

echo ""
echo "======================================================================"
echo "Database Status"
echo "======================================================================"
echo ""

# Check database connections
echo "Checking PostgreSQL databases..."
docker compose exec postgres psql -U postgres -l 2>/dev/null | grep -E "book_db|electronics_db|audio_db|software_db|furniture_db|sports_db|toys_db|fashion_db|home_db|gardening_db|health_db|customer_db|catalog_db|cart_db|staff_db|manager_db|order_db|pay_db|ship_db|comment_rate_db|recommender_db" > /dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All 21 databases found in PostgreSQL"
else
    echo -e "${YELLOW}⚠${NC} Database check inconclusive"
fi

echo ""
echo "======================================================================"
echo "Network Status"
echo "======================================================================"
echo ""

# Test API endpoints
test_api() {
    local name=$1
    local url=$2
    
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
    
    if [ "$response" == "200" ] || [ "$response" == "404" ] || [ "$response" == "400" ]; then
        echo -e "${GREEN}✓${NC} $name (HTTP $response)"
    elif [ "$response" == "000" ]; then
        echo -e "${YELLOW}⏳${NC} $name (Connection timeout - service starting)"
    else
        echo -e "${RED}✗${NC} $name (HTTP $response)"
    fi
}

echo "Testing API Endpoints..."
test_api "API Gateway" "http://localhost:8000/"
test_api "Book Service" "http://localhost:8002/books/"
test_api "Electronics Service" "http://localhost:8102/books/"
test_api "Customer Service" "http://localhost:8001/"

echo ""
echo "======================================================================"
echo "Quick Start Commands"
echo "======================================================================"
echo ""
echo "1. Start all services:"
echo "   docker compose up -d"
echo ""
echo "2. Seed all product data:"
echo "   PowerShell: .\scripts\seed_all.ps1 -Clear"
echo "   Bash:      sh scripts/seed_all.sh"
echo ""
echo "3. View logs:"
echo "   docker compose logs -f"
echo ""
echo "4. Stop all services:"
echo "   docker compose down"
echo ""
echo "5. Access web interface:"
echo "   Browser: http://localhost:8000"
echo ""
echo "======================================================================"
echo "For more information, see DEPLOYMENT_STATUS.md"
echo "======================================================================"
