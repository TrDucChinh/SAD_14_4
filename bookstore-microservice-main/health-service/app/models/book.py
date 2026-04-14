from django.db import models


class BookStatus(models.TextChoices):
    ACTIVE = "active", "Active"
    INACTIVE = "inactive", "Inactive"
    OUT_OF_STOCK = "out_of_stock", "Out of Stock"


class ProductType(models.TextChoices):
    """Product types across 10+ categories"""
    BOOK = "book", "Sách"
    ELECTRONICS = "electronics", "Điện tử"
    AUDIO = "audio", "Âm thanh"
    SOFTWARE = "software", "Phần mềm"
    FURNITURE = "furniture", "Nội thất"
    SPORTS = "sports", "Thể thao"
    TOYS = "toys", "Đồ chơi"
    FASHION = "fashion", "Thời trang"
    HOME = "home", "Nhà cửa"
    GARDENING = "gardening", "Làm vườn"
    HEALTH = "health", "Sức khỏe"


class Book(models.Model):
    title = models.CharField(max_length=500)
    isbn = models.CharField(max_length=20, unique=True, blank=True)
    description = models.TextField(blank=True)
    publication_year = models.IntegerField(null=True, blank=True)
    page_count = models.IntegerField(null=True, blank=True)
    list_price = models.DecimalField(max_digits=10, decimal_places=2)
    sale_price = models.DecimalField(max_digits=10, decimal_places=2)
    stock = models.IntegerField(default=0)
    product_type = models.CharField(max_length=50, choices=ProductType.choices, default=ProductType.BOOK)
    status = models.CharField(max_length=20, choices=BookStatus.choices, default=BookStatus.ACTIVE)
    created_date = models.DateTimeField(auto_now_add=True)
    updated_date = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "books"
        ordering = ["-created_date"]

    def __str__(self):
        return self.title
