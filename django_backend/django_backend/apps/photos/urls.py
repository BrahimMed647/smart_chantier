from django.urls import path
from .views import PhotoDetailView, PhotoListCreateView

urlpatterns = [
    path("photos/", PhotoListCreateView.as_view(), name="photo_list"),
    path("photos/<int:pk>/", PhotoDetailView.as_view(), name="photo_detail"),
    path("projects/<int:project_pk>/photos/", PhotoListCreateView.as_view(), name="project_photo_list"),
]
