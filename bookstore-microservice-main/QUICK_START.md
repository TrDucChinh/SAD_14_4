# 🚀 BookStore Microservices - Quick Start Guide

## TL;DR - Get Started in 10 Minutes

### 1. Start Everything (First Time)
```bash
# Navigate to project directory
cd C:\Users\admin\Desktop\Academy\Ky 2\Kien_truc_thiet_ke_phan_mem\bookstore-microservice-main\bookstore-microservice-main

# Start all 22 services
docker compose up -d --build

# Wait 2-3 minutes for services to initialize

# Seed all product data
.\scripts\seed_all.ps1 -Clear
```

### 2. Access the System
- **Web Gateway:** http://localhost:8000
- **Products Page:** http://localhost:8000/products/
- **Book Service:** http://localhost:8002/books/
- **Electronics Service:** http://localhost:8102/books/

### 3. Test Status
```bash
# Verify all services are running
.\verify-deployment.ps1

# View logs if needed
docker compose logs -f
```

### 4. Stop Services
```bash
# Stop all services but keep data
docker compose stop

# Stop and remove everything including data
docker compose down -v
```

---

## Service Architecture

### 11 Product Services
Each product type has its own independent service with its own database:

```
Book Service        → port 8002  → book_db
Electronics         → port 8102  → electronics_db
Audio               → port 8103  → audio_db
Software            → port 8104  → software_db
Furniture           → port 8105  → furniture_db
Sports              → port 8106  → sports_db
Toys                → port 8107  → toys_db
Fashion             → port 8108  → fashion_db
Home                → port 8109  → home_db
Gardening           → port 8110  → gardening_db
Health              → port 8111  → health_db
```

### 10 Supporting Services
```
API Gateway                 → port 8000
Customer Service            → port 8001
Cart Service                → port 8003
Staff Service               → port 8004
Manager Service             → port 8005
Catalog Service             → port 8006
Order Service               → port 8007
Payment Service             → port 8008
Shipping Service            → port 8009
Comments & Ratings          → port 8010
Recommender AI              → port 8011
```

---

## Common Commands

### Check Services Status
```powershell
# See all running containers
docker compose ps

# Count running services
docker ps --filter "label=com.docker.compose.project" --format "{{.Names}}" | Measure-Object

# Check specific service
docker compose ps book-service
```

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f book-service
docker compose logs -f electronics-service
docker compose logs -f api-gateway

# Last 50 lines
docker compose logs --tail=50

# Follow logs
docker compose logs -f --tail=10
```

### Manage Services
```bash
# Start services
docker compose up -d

# Start with rebuild
docker compose up -d --build

# Rebuild without starting
docker compose build

# Stop services
docker compose stop

# Restart specific service
docker compose restart book-service

# Hard restart everything
docker compose down -v
docker compose up -d
```

### Seed Data
```bash
# Seed all services with clearing existing data
.\scripts\seed_all.ps1 -Clear

# Seed all services without clearing
.\scripts\seed_all.ps1

# Seed specific service
docker compose exec book-service python manage.py seed_mock --product-type=book

# Seed and clear specific service
docker compose exec book-service python manage.py seed_mock --product-type=book --clear
```

### Database Operations
```bash
# Connect to PostgreSQL
docker compose exec postgres psql -U postgres

# List all databases
docker compose exec postgres psql -U postgres -l

# Check books in specific database
docker compose exec postgres psql -U postgres -d electronics_db -c "SELECT COUNT(*) FROM books;"

# View specific product data
docker compose exec postgres psql -U postgres -d electronics_db -c "SELECT title, product_type, sale_price FROM books LIMIT 5;"
```

### API Testing
```bash
# Get all books from book service
curl http://localhost:8002/books/

# Get electronics from electronics service
curl http://localhost:8102/books/

# Get products by type via gateway
curl "http://localhost:8000/products/?type=electronics"

# Create a new product (if permissions allow)
curl -X POST http://localhost:8002/books/ \
  -H "Content-Type: application/json" \
  -d '{"title": "Test", "sale_price": 99.99, "product_type": "book"}'
```

---

## Test Accounts

After running the seed scripts, these accounts are available:

### Customers
```
Username: customer1  | Password: password123
Username: customer2  | Password: password123
Username: customer3  | Password: password123
```

### Staff
```
Username: staff1     | Password: password123
Username: staff2     | Password: password123
```

### Managers
```
Username: manager1   | Password: password123
```

---

## Troubleshooting

### Services Won't Start?
```bash
# Clean everything and rebuild
docker compose down -v --remove-orphans
docker compose build --no-cache
docker compose up -d

# Wait 3-5 minutes and check again
docker compose ps
```

### Database Connection Error?
```bash
# Check PostgreSQL is running
docker compose ps postgres

# Check logs
docker compose logs postgres

# Verify environment variables
docker compose config | grep DB_
```

### Service Keeps Crashing?
```bash
# View detailed error logs
docker compose logs -f --tail=100 <service-name>

# Rebuild without cache
docker compose build --no-cache <service-name>
docker compose up -d <service-name>
```

### Port Already in Use?
```bash
# Find what's using the port (e.g., 8000)
netstat -ano | findstr :8000

# Kill the process
taskkill /PID <PID> /F

# Or change the port in docker-compose.yml or .env
# Change PORT_GATEWAY=8000 to PORT_GATEWAY=8001
```

### Data Not Appearing After Seed?
```bash
# Check if seed actually ran
docker compose logs -f book-service | grep -i "created\|seed"

# Verify data exists in database
docker compose exec postgres psql -U postgres -d book_db -c "SELECT COUNT(*) FROM books;"

# Manually seed again
docker compose exec book-service python manage.py seed_mock --product-type=book --clear
```

---

## Understanding the Architecture

### Database per Service Pattern
Each microservice has its own independent database. This means:
- ✅ Services are completely independent
- ✅ Services can scale independently
- ✅ Data is isolated and safe
- ✅ Each service uses only its database

### Example Flow
```
User Request:
  GET /products/?type=electronics

API Gateway (port 8000):
  ↓ Sees type=electronics
  ↓ Routes to electronics-service
  
Electronics Service (port 8102):
  ↓ Queries electronics_db
  ↓ Returns only electronics products
  
Response:
  Array of 8 electronics products
```

### File Organization
```
bookstore-microservice-main/
│
├── docker-compose.yml          # All 22 services defined
├── .env                         # Environment variables (create from .env.example)
├── .env.example                 # Template for .env
│
├── api-gateway/                 # Gateway service
│   ├── app/
│   ├── gateway/
│   └── api_gateway/
│
├── book-service/                # Template service (copied for each product)
│   ├── app/
│   ├── book_service/
│   ├── Dockerfile
│   ├── manage.py
│   └── requirements.txt
│
├── electronics-service/         # Specific product service (copy of book-service)
├── audio-service/
├── software-service/
│ ... (more product services)
│
├── customer-service/            # Supporting services
├── catalog-service/
├── order-service/
│ ... (more supporting services)
│
├── postgres/                    # PostgreSQL configuration
│   └── init.sql                 # Creates all 21 databases
│
├── scripts/
│   ├── seed_all.ps1            # PowerShell seed script
│   ├── seed_all.sh             # Bash seed script
│   └── (database schemas)
│
├── docs/
├── README.md                    # Full documentation
├── DEPLOYMENT_STATUS.md         # Current deployment status
├── verify-deployment.ps1        # Verification script
└── QUICK_START.md               # This file
```

---

## Performance Tips

### Optimize Memory Usage
```bash
# Limit memory per service in docker-compose.yml
services:
  book-service:
    deploy:
      resources:
        limits:
          memory: 512M
```

### Faster Startup
```bash
# Build images locally first to avoid repeating
docker compose build

# Then just start
docker compose up -d

# Services start faster without rebuild
```

### Better Logs
```bash
# Only show errors
docker compose logs --tail=0 2>&1 | grep -i error

# Follow specific service with timestamps
docker compose logs -f --timestamps book-service
```

---

## Next Steps

1. ✅ Start services: `docker compose up -d`
2. ✅ Seed data: `.\scripts\seed_all.ps1 -Clear`
3. ✅ Open browser: http://localhost:8000
4. ✅ Test products: http://localhost:8000/products/
5. ✅ Try different types: Add `?type=electronics` to URL

---

## Support & Documentation

- **Full Guide:** See DEPLOYMENT_STATUS.md
- **Architecture:** See README.md
- **Verification:** Run .\verify-deployment.ps1
- **Logs:** `docker compose logs -f`

---

**Happy Microservicing! 🚀**

*Last Updated: April 14, 2026 | Version: 1.0*
