from django.urls import path

from .views import ProjectDetailView, ProjectListCreateView, dashboard_view, project_budget_view

urlpatterns = [
    path("projects/", ProjectListCreateView.as_view(), name="project_list"),
    path("projects/<int:pk>/", ProjectDetailView.as_view(), name="project_detail"),
    path("projects/<int:pk>/budget/", project_budget_view, name="project_budget"),
    path("dashboard/", dashboard_view, name="dashboard"),
]
