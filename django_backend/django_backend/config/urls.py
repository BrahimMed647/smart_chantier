from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.http import JsonResponse, FileResponse, HttpResponse
from django.urls import include, path
from django.views.static import serve
from rest_framework_simplejwt.views import TokenRefreshView
import os


def health_check(request):
    return JsonResponse({
        "status": "ok",
        "message": "Smart Chantier API is running",
        "version": "1.0.0",
    })


def flutter_app(request, path=""):
    """
    SPA catch-all: serves index.html for any non-API, non-file route.
    Actual Flutter static files (main.dart.js, canvaskit, etc.) are served
    by WhiteNoise with Gzip compression and long-lived cache headers.
    """
    flutter_web_dir = os.path.join(settings.BASE_DIR, "flutter_web")
    index_path = os.path.join(flutter_web_dir, "index.html")
    if os.path.isfile(index_path):
        with open(index_path, "rb") as f:
            return HttpResponse(f.read(), content_type="text/html")

    return HttpResponse(
        """
        <html><body style="font-family:sans-serif;text-align:center;padding:60px">
        <h1>Smart Chantier</h1>
        <p>API is running. Flutter web app not deployed yet.</p>
        <p><a href="/health/">Health Check</a></p>
        </body></html>
        """,
        content_type="text/html",
    )


urlpatterns = [
    # Health check for Railway
    path("health/", health_check, name="health"),

    # Django admin
    path("admin/", admin.site.urls),

    # JWT auth refresh
    path("api/auth/refresh/", TokenRefreshView.as_view(), name="token_refresh"),

    # App API routes
    path("api/", include("apps.accounts.urls")),
    path("api/", include("apps.projects.urls")),
    path("api/", include("apps.tasks.urls")),
    path("api/", include("apps.reports.urls")),
    path("api/", include("apps.expenses.urls")),
    path("api/", include("apps.alerts.urls")),
    path("api/", include("apps.photos.urls")),

    # Flutter web app — serves at / and catches all non-API routes
    path("", flutter_app, name="flutter_root"),
    path("<path:path>", flutter_app, name="flutter_app"),
]

# Serve media files (uploaded photos)
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
