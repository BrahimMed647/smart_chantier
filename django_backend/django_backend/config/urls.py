from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.http import JsonResponse
from django.urls import include, path
from rest_framework_simplejwt.views import TokenRefreshView


# Vue simple pour verifier que l'API fonctionne
def health_check(request):
    return JsonResponse({
        "status": "ok",
        "message": "Smart Chantier API is running",
        "version": "1.0.0",
    })


urlpatterns = [
    # Page de verification de sante (Railway l'utilise pour verifier le deploiement)
    path("", health_check, name="health_check"),
    path("health/", health_check, name="health"),

    # Interface d'administration Django
    path("admin/", admin.site.urls),

    # Authentification JWT
    path("api/auth/refresh/", TokenRefreshView.as_view(), name="token_refresh"),

    # Routes de chaque application
    path("api/", include("apps.accounts.urls")),
    path("api/", include("apps.projects.urls")),
    path("api/", include("apps.tasks.urls")),
    path("api/", include("apps.reports.urls")),
    path("api/", include("apps.expenses.urls")),
    path("api/", include("apps.alerts.urls")),
    path("api/", include("apps.photos.urls")),
]

# Servir les fichiers media (photos) en production aussi
# Note: en production serieuse, on utiliserait S3 ou Cloudinary
# Pour ce projet, Django sert directement les fichiers
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
