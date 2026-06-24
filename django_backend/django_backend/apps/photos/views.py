from rest_framework import generics, permissions
from .models import SitePhoto
from .serializers import SitePhotoSerializer


class PhotoListCreateView(generics.ListCreateAPIView):
    serializer_class = SitePhotoSerializer
    permission_classes = [permissions.IsAuthenticated]
    filterset_fields = ["project", "photo_type", "report"]

    def get_queryset(self):
        qs = SitePhoto.objects.select_related("project", "report", "uploaded_by")
        project_id = self.kwargs.get("project_pk") or self.request.query_params.get("project")
        if project_id:
            qs = qs.filter(project_id=project_id)
        return qs


class PhotoDetailView(generics.RetrieveDestroyAPIView):
    serializer_class = SitePhotoSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = SitePhoto.objects.select_related("project", "report", "uploaded_by")
