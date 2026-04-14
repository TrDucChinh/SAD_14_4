#!/bin/sh
# Chạy seed mock data cho tất cả microservices (theo thứ tự phụ thuộc).
# Yêu cầu: Docker Compose đang chạy (docker compose up -d).
# Cách chạy: ./scripts/seed_all.sh   hoặc   sh scripts/seed_all.sh

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Services không phải product (không cần --product-type)
NON_PRODUCT_SERVICES="customer-service catalog-service staff-service cart-service order-service pay-service ship-service manager-service comment-rate-service recommender-ai-service"

# Product services với --product-type tương ứng (Database per Service pattern)
PRODUCT_SERVICES=(
  "book-service:book"
  "electronics-service:electronics"
  "audio-service:audio"
  "software-service:software"
  "furniture-service:furniture"
  "sports-service:sports"
  "toys-service:toys"
  "fashion-service:fashion"
  "home-service:home"
  "gardening-service:gardening"
  "health-service:health"
)

echo "=== Seed mock data (root: $ROOT) ==="

# Seed non-product services
for svc in $NON_PRODUCT_SERVICES; do
  echo ""
  echo "[$svc] Running seed_mock..."
  docker compose exec -T "$svc" python manage.py seed_mock
  echo "[$svc] OK"
done

# Seed product services với product type filter
for svc_pair in "${PRODUCT_SERVICES[@]}"; do
  IFS=':' read -r svc product_type <<< "$svc_pair"
  echo ""
  echo "[$svc] Running seed_mock --product-type=$product_type..."
  docker compose exec -T "$svc" python manage.py seed_mock --product-type="$product_type"
  echo "[$svc] OK"
done

echo ""
echo "=== Hoàn thành seed tất cả services ==="
