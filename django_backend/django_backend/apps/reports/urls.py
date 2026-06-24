from django.urls import path
from .views import ReportDetailView, ReportListCreateView

urlpatterns = [
    path("reports/", ReportListCreateView.as_view(), name="report_list"),
    path("reports/<int:pk>/", ReportDetailView.as_view(), name="report_detail"),
    path("projects/<int:project_pk>/reports/", ReportListCreateView.as_view(), name="project_report_list"),
]
