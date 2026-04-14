from pathlib import Path
import os

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.environ.get("SECRET_KEY", "api-gateway-dev-key")
DEBUG = True
ALLOWED_HOSTS = ["*"]

INSTALLED_APPS = [
    "django.contrib.contenttypes",
    "django.contrib.auth",
    "django.contrib.sessions",
    "django.contrib.staticfiles",
    "gateway",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "gateway.middleware.JWTAuthMiddleware",
]

ROOT_URLCONF = "api_gateway.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                "django.template.context_processors.csrf",
            ],
        },
    },
]

# Session storage (cache/memory-based — no disk path needed for the gateway)
SESSION_ENGINE = "django.contrib.sessions.backends.cache"
SESSION_COOKIE_AGE = 86400 * 7   # 7 days
SESSION_COOKIE_HTTPONLY = True

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "db.sqlite3",
    }
}

STATIC_URL = "/static/"
STATICFILES_DIRS = [BASE_DIR / "static"]
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# ── JWT ────────────────────────────────────────────────────────────────────────
JWT_SECRET_KEY = os.environ.get("JWT_SECRET_KEY", "bookstore-jwt-secret-dev")

# ── Service URLs ───────────────────────────────────────────────────────────────
SERVICE_URLS = {
    "customer":    os.environ.get("CUSTOMER_SERVICE_URL",    "http://customer-service:8000"),
    "book":        os.environ.get("BOOK_SERVICE_URL",        "http://book-service:8000"),
    "electronics": os.environ.get("ELECTRONICS_SERVICE_URL", "http://electronics-service:8000"),
    "audio":       os.environ.get("AUDIO_SERVICE_URL",       "http://audio-service:8000"),
    "software":    os.environ.get("SOFTWARE_SERVICE_URL",    "http://software-service:8000"),
    "furniture":   os.environ.get("FURNITURE_SERVICE_URL",   "http://furniture-service:8000"),
    "sports":      os.environ.get("SPORTS_SERVICE_URL",      "http://sports-service:8000"),
    "toys":        os.environ.get("TOYS_SERVICE_URL",        "http://toys-service:8000"),
    "fashion":     os.environ.get("FASHION_SERVICE_URL",     "http://fashion-service:8000"),
    "home":        os.environ.get("HOME_SERVICE_URL",        "http://home-service:8000"),
    "gardening":   os.environ.get("GARDENING_SERVICE_URL",   "http://gardening-service:8000"),
    "health":      os.environ.get("HEALTH_SERVICE_URL",      "http://health-service:8000"),
    "catalog":     os.environ.get("CATALOG_SERVICE_URL",     "http://catalog-service:8000"),
    "cart":        os.environ.get("CART_SERVICE_URL",        "http://cart-service:8000"),
    "order":       os.environ.get("ORDER_SERVICE_URL",       "http://order-service:8000"),
    "pay":         os.environ.get("PAY_SERVICE_URL",         "http://pay-service:8000"),
    "ship":        os.environ.get("SHIP_SERVICE_URL",        "http://ship-service:8000"),
    "comment":     os.environ.get("COMMENT_RATE_URL",        "http://comment-rate-service:8000"),
    "recommender": os.environ.get("RECOMMENDER_URL",         "http://recommender-ai-service:8000"),
    "staff":       os.environ.get("STAFF_SERVICE_URL",       "http://staff-service:8000"),
    "manager":     os.environ.get("MANAGER_SERVICE_URL",     "http://manager-service:8000"),
}

# Map product_type to service key for routing
PRODUCT_TYPE_SERVICE_MAP = {
    "book":       "book",
    "electronics": "electronics",
    "audio":       "audio",
    "software":    "software",
    "furniture":   "furniture",
    "sports":      "sports",
    "toys":        "toys",
    "fashion":     "fashion",
    "home":        "home",
    "gardening":   "gardening",
    "health":      "health",
}
