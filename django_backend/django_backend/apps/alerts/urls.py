from django.urls import path
from .views import AlertDetailView, AlertListCreateView, mark_read, resolve_alert

urlpatterns = [
    path("alerts/", AlertListCreateView.as_view(), name="alert_list"),
    path("alerts/<int:pk>/", AlertDetailView.as_view(), name="alert_detail"),
    path("alerts/<int:pk>/resolve/", resolve_alert, name="alert_resolve"),
    path("alerts/<int:pk>/read/", mark_read, name="alert_read"),
    path("projects/<int:project_pk>/alerts/", AlertListCreateView.as_view(), name="project_alert_list"),
]
