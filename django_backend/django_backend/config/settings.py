import os
from datetime import timedelta
from pathlib import Path

import dj_database_url
from dotenv import load_dotenv

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent

# ---------------------------------------------------------------------------
# SECURITY
# ---------------------------------------------------------------------------
SECRET_KEY = os.environ.get("SECRET_KEY", "django-insecure-dev-key-CHANGE-IN-PRODUCTION")

# In production (Railway), set DEBUG=False in environment variables.
# The default is True so local development works out of the box.
DEBUG = os.environ.get("DEBUG", "True") == "True"

# Railway automatically provides RAILWAY_PUBLIC_DOMAIN.
# We read it here so we can add it everywhere it is needed.
RAILWAY_PUBLIC_DOMAIN = os.environ.get("RAILWAY_PUBLIC_DOMAIN", "")

# ALLOWED_HOSTS — which domain names Django accepts.
# We start with the value from the env var (comma-separated list),
# then we also add the Railway domain automatically if it is set.
_allowed = os.environ.get("ALLOWED_HOSTS", "localhost,127.0.0.1")
ALLOWED_HOSTS = [h.strip() for h in _allowed.split(",") if h.strip()]
if RAILWAY_PUBLIC_DOMAIN and RAILWAY_PUBLIC_DOMAIN not in ALLOWED_HOSTS:
    ALLOWED_HOSTS.append(RAILWAY_PUBLIC_DOMAIN)
# During development with DEBUG=True, also allow everything.
if DEBUG:
    ALLOWED_HOSTS = ["*"]

# CSRF — which origins can send forms / API requests with cookies.
_csrf = os.environ.get("CSRF_TRUSTED_ORIGINS", "http://localhost:8000,http://127.0.0.1:8000")
CSRF_TRUSTED_ORIGINS = [o.strip() for o in _csrf.split(",") if o.strip()]
if RAILWAY_PUBLIC_DOMAIN:
    railway_https = f"https://{RAILWAY_PUBLIC_DOMAIN}"
    if railway_https not in CSRF_TRUSTED_ORIGINS:
        CSRF_TRUSTED_ORIGINS.append(railway_https)

# ---------------------------------------------------------------------------
# APPLICATION
# ---------------------------------------------------------------------------
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",
    "rest_framework_simplejwt",
    "corsheaders",
    "django_filters",
    "apps.accounts",
    "apps.projects",
    "apps.tasks",
    "apps.reports",
    "apps.expenses",
    "apps.alerts",
    "apps.photos",
]

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "config.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "config.wsgi.application"

# ---------------------------------------------------------------------------
# DATABASE
# ---------------------------------------------------------------------------
# Railway provides DATABASE_URL automatically when you add a PostgreSQL
# service. Locally we fall back to SQLite so you don't need PostgreSQL
# installed on your machine.
DATABASE_URL = os.environ.get("DATABASE_URL", f"sqlite:///{BASE_DIR}/db.sqlite3")
DATABASES = {
    "default": dj_database_url.parse(
        DATABASE_URL,
        conn_max_age=600,
        conn_health_checks=True,
    )
}

AUTH_USER_MODEL = "accounts.User"

# ---------------------------------------------------------------------------
# AUTHENTICATION
# ---------------------------------------------------------------------------
AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(hours=24),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=30),
    "ROTATE_REFRESH_TOKENS": True,
    "BLACKLIST_AFTER_ROTATION": False,
    "AUTH_HEADER_TYPES": ("Bearer",),
    "USER_ID_FIELD": "id",
    "USER_ID_CLAIM": "user_id",
}

# ---------------------------------------------------------------------------
# INTERNATIONALISATION
# ---------------------------------------------------------------------------
LANGUAGE_CODE = "fr-fr"
TIME_ZONE = "Africa/Algiers"
USE_I18N = True
USE_TZ = True

# ---------------------------------------------------------------------------
# STATIC & MEDIA FILES
# ---------------------------------------------------------------------------
STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "staticfiles"
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"

# WhiteNoise serves the Flutter web build from the root URL with
# automatic Gzip compression and long-lived cache headers.
# This reduces main.dart.js from 3 MB to ~800 KB on first load,
# and subsequent visits load instantly from browser cache.
WHITENOISE_ROOT = BASE_DIR / "flutter_web"
WHITENOISE_MAX_AGE = 31536000  # 1 year cache for versioned assets

MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# ---------------------------------------------------------------------------
# REST FRAMEWORK
# ---------------------------------------------------------------------------
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.IsAuthenticated",
    ],
    "DEFAULT_FILTER_BACKENDS": [
        "django_filters.rest_framework.DjangoFilterBackend",
        "rest_framework.filters.SearchFilter",
        "rest_framework.filters.OrderingFilter",
    ],
    "DEFAULT_RENDERER_CLASSES": [
        "rest_framework.renderers.JSONRenderer",
    ],
}

# ---------------------------------------------------------------------------
# CORS (Cross-Origin Resource Sharing)
# Allows the Flutter app and browser to call our API.
# ---------------------------------------------------------------------------
if DEBUG:
    CORS_ALLOW_ALL_ORIGINS = True
else:
    CORS_ALLOW_ALL_ORIGINS = False
    _cors = os.environ.get(
        "CORS_ALLOWED_ORIGINS",
        "http://localhost:3000,http://127.0.0.1:3000",
    )
    CORS_ALLOWED_ORIGINS = [o.strip() for o in _cors.split(",") if o.strip()]
    if RAILWAY_PUBLIC_DOMAIN:
        railway_https = f"https://{RAILWAY_PUBLIC_DOMAIN}"
        if railway_https not in CORS_ALLOWED_ORIGINS:
            CORS_ALLOWED_ORIGINS.append(railway_https)

CORS_ALLOW_CREDENTIALS = True
CORS_ALLOW_HEADERS = [
    "accept",
    "accept-encoding",
    "authorization",
    "content-type",
    "dnt",
    "origin",
    "user-agent",
    "x-csrftoken",
    "x-requested-with",
]
