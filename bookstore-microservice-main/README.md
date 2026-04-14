# BookStore Microservice

Hệ thống bookstore tách thành 12 microservices (Django) + 1 PostgreSQL service, chạy hoàn toàn bằng Docker Compose.

---

## Yêu cầu

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
- **Các service trực tiếp:**  
  - Customer: http://localhost:8001  
  - Book: http://localhost:8002  
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

Sau khi các service đã chạy, có thể nạp dữ liệu mẫu cho tất cả bảng:

```powershell
# Chạy từ thư mục gốc project
.\scripts\seed_all.ps1

# Xóa dữ liệu cũ rồi seed lại
.\scripts\seed_all.ps1 -Clear
```

Hoặc seed từng service: `docker compose exec customer-service python manage.py seed_mock` (tương tự với `catalog-service`, `book-service`, ...). Thứ tự nên theo: customer → catalog → book → staff → cart → order → pay → ship → manager → comment-rate-service → recommender-ai-service.

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
