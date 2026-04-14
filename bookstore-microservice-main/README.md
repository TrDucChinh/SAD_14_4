# BookStore Microservice

Hệ thống bán hàng đa loại sản phẩm tách thành **22 microservices**: 11 product services (Database per Service) + 10 supporting services + 1 API Gateway + 1 PostgreSQL, chạy hoàn toàn bằng Docker Compose.

**Hỗ trợ 11 loại sản phẩm:** 📚 Sách | 💻 Điện tử | 🎵 Âm thanh | ⚙️ Phần mềm | 🛋️ Nội thất | 🏃 Thể thao | 🎮 Đồ chơi | 👕 Thời trang | 🏠 Nhà cửa | 🌱 Làm vườn | 💊 Sức khỏe

---

## Kiến trúc Microservices (Database per Service)

## Kiến trúc Microservices (Database per Service)

### Product Services (11 services)
Mỗi loại sản phẩm có một microservice riêng với database riêng:

| Service | Port | Database | Mô tả |
|---------|------|----------|-------|
| **book-service** | 8002 | book_db | Sách |
| **electronics-service** | 8102 | electronics_db | Thiết bị điện tử |
| **audio-service** | 8103 | audio_db | Thiết bị âm thanh |
| **software-service** | 8104 | software_db | Phần mềm |
| **furniture-service** | 8105 | furniture_db | Nội thất |
| **sports-service** | 8106 | sports_db | Thể thao |
| **toys-service** | 8107 | toys_db | Đồ chơi |
| **fashion-service** | 8108 | fashion_db | Thời trang |
| **home-service** | 8109 | home_db | Nhà cửa |
| **gardening-service** | 8110 | gardening_db | Làm vườn |
| **health-service** | 8111 | health_db | Sức khỏe |

### Supporting Services (10 services)

| Service | Port | Database | Mô tả |
|---------|------|----------|-------|
| **api-gateway** | 8000 | postgres | Proxy & routing |
| **customer-service** | 8001 | customer_db | Quản lý khách hàng |
| **cart-service** | 8003 | cart_db | Giỏ hàng |
| **staff-service** | 8004 | staff_db | Quản lý nhân viên |
| **manager-service** | 8005 | manager_db | Quản lý |
| **catalog-service** | 8006 | catalog_db | Danh mục |
| **order-service** | 8007 | order_db | Đơn hàng |
| **pay-service** | 8008 | pay_db | Thanh toán |
| **ship-service** | 8009 | ship_db | Vận chuyển |
| **comment-rate-service** | 8010 | comment_rate_db | Bình luận & đánh giá |
| **recommender-ai-service** | 8011 | recommender_db | Gợi ý & AI |

---

## Các loại sản phẩm được hỗ trợ

Hệ thống hỗ trợ 11 loại sản phẩm khác nhau trong một cơ sở dữ liệu thống nhất:

| Loại | Giá trị | Mô tả |
|------|--------|-------|
| Sách | `book` | Sách in và sách kỹ thuật số |
| Điện tử | `electronics` | Thiết bị điện tử, máy tính, phụ kiện |
| Âm thanh | `audio` | Loa, tai nghe, thiết bị âm thanh |
| Phần mềm | `software` | Phần mềm, ứng dụng, giấy phép |
| Nội thất | `furniture` | Bàn, ghế, tủ, đồ dùng nội thất |
| Thể thao | `sports` | Dụng cụ thể thao, quần áo thể thao |
| Đồ chơi | `toys` | Đồ chơi, trò chơi, đồ chơi giáo dục |
| Thời trang | `fashion` | Quần áo, giày, phụ kiện thời trang |
| Nhà cửa | `home` | Đồ dùng nhà cửa, trang trí, vật dụng |
| Làm vườn | `gardening` | Dụng cụ làm vườn, hạt giống, phân bón |
| Sức khỏe | `health` | Sản phẩm chăm sóc sức khỏe, vitamin |

Khách hàng có thể duyệt tất cả sản phẩm ở `/products/` và lọc theo loại sản phẩm.

---

- **Docker Desktop** (Windows/Mac) hoặc Docker + Docker Compose

---

## Cách chạy

### Bước 1: Cấu hình biến môi trường

```powershell
# Nếu chưa có file .env, copy từ mẫu:
copy .env.example .env

# Mở .env và chỉnh password DB nếu cần:
# POSTGRES_PASSWORD=<mật khẩu postgres container>
```

**Lưu ý:** Trong `.env` không được có comment (`#`) trên cùng dòng với giá trị (ví dụ: `KEY=value   # comment` sẽ sai).

---

### Bước 2: Build và chạy Docker

---

Mở terminal (PowerShell hoặc CMD) tại thư mục dự án:

```powershell
cd d:\Study\Nam4_Ky2\KTVHTPM\bookstore-microservice

# Build images (lần đầu hoặc khi đổi code)
docker compose build

# Chạy tất cả services (nền)
docker compose up -d
```

Lần đầu chạy có thể mất vài phút để build images. PostgreSQL sẽ tự khởi tạo các database trong `postgres/init.sql` ở lần tạo volume đầu tiên. Sau khi DB sẵn sàng, Django trong mỗi container sẽ tự chạy `makemigrations` và `migrate`.

Nếu đã chạy trước đó và muốn khởi tạo DB từ đầu:

```powershell
docker compose down -v
docker compose up -d --build
```

---

### Bước 3: Kiểm tra

- **API Gateway (web + proxy):** http://localhost:8000  

**Product Services:**  
  - Book: http://localhost:8002  
  - Electronics: http://localhost:8102  
  - Audio: http://localhost:8103  
  - Software: http://localhost:8104  
  - Furniture: http://localhost:8105  
  - Sports: http://localhost:8106  
  - Toys: http://localhost:8107  
  - Fashion: http://localhost:8108  
  - Home: http://localhost:8109  
  - Gardening: http://localhost:8110  
  - Health: http://localhost:8111  

**Supporting Services:**  
  - Customer: http://localhost:8001  
  - Cart: http://localhost:8003  
  - Staff: http://localhost:8004  
  - Manager: http://localhost:8005  
  - Catalog: http://localhost:8006  
  - Order: http://localhost:8007  
  - Pay: http://localhost:8008  
  - Ship: http://localhost:8009  
  - Comment/Rate: http://localhost:8010  
  - Recommender: http://localhost:8011  

---

## Mock data (dữ liệu mẫu)

Sau khi các service đã chạy, có thể nạp dữ liệu mẫu cho tất cả bảng. **Database per Service** nghĩa là mỗi product service chỉ seed dữ liệu của loại sản phẩm của nó:

### Cách 1: Seed tất cả services (khuyên dùng)

```powershell
# Chạy từ thư mục gốc project
.\scripts\seed_all.ps1

# Xóa dữ liệu cũ rồi seed lại từ đầu
.\scripts\seed_all.ps1 -Clear
```

Hoặc trên Linux/macOS:

```bash
sh scripts/seed_all.sh
```

**Kết quả:**
- Tất cả supporting services (customer, catalog, staff, ...) sẽ seed dữ liệu vào database riêng
- Mỗi product service sẽ chỉ seed sản phẩm loại của nó (vd: electronics-service → electronics_db, audio-service → audio_db)

### Cách 2: Seed từng service thủ công

**Seed supporting services:**
```powershell
docker compose exec customer-service python manage.py seed_mock
docker compose exec catalog-service python manage.py seed_mock
docker compose exec staff-service python manage.py seed_mock
# ... tương tự với các service khác
```

**Seed product services (với --product-type):**
```powershell
docker compose exec book-service python manage.py seed_mock --product-type=book
docker compose exec electronics-service python manage.py seed_mock --product-type=electronics
docker compose exec audio-service python manage.py seed_mock --product-type=audio
docker compose exec software-service python manage.py seed_mock --product-type=software
docker compose exec furniture-service python manage.py seed_mock --product-type=furniture
docker compose exec sports-service python manage.py seed_mock --product-type=sports
docker compose exec toys-service python manage.py seed_mock --product-type=toys
docker compose exec fashion-service python manage.py seed_mock --product-type=fashion
docker compose exec home-service python manage.py seed_mock --product-type=home
docker compose exec gardening-service python manage.py seed_mock --product-type=gardening
docker compose exec health-service python manage.py seed_mock --product-type=health
```

**Tài khoản mẫu sau khi seed:**
- Khách hàng: `customer1` / `password123` (customer2, customer3 tương tự)
- Nhân viên: `staff1`, `staff2` / `password123`
- Quản lý: `manager1` / `password123`

---

## Lệnh hữu ích

```powershell
# Xem log tất cả services
docker compose logs -f

# Xem log một service (ví dụ customer-service)
docker compose logs -f customer-service

# Dừng tất cả
docker compose down

# Dừng và xóa volumes (nếu có)
docker compose down -v
```

---

## Nếu Docker không kết nối được PostgreSQL

- Kiểm tra container DB đã chạy chưa: `docker compose ps postgres`
- Xem log DB: `docker compose logs -f postgres`
- Trong `.env`, giữ `DB_HOST=postgres` để các service trỏ đúng hostname nội bộ Docker network.
