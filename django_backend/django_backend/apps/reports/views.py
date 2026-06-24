from rest_framework import generics, permissions
from .models import DailyReport
from .serializers import DailyReportSerializer


class ReportListCreateView(generics.ListCreateAPIView):
    serializer_class = DailyReportSerializer
    permission_classes = [permissions.IsAuthenticated]
    filterset_fields = ["project", "report_date"]
    ordering_fields = ["report_date", "created_at"]

    def get_queryset(self):
        qs = DailyReport.objects.select_related("project", "task", "created_by")
        project_id = self.kwargs.get("project_pk") or self.request.query_params.get("project")
        if project_id:
            qs = qs.filter(project_id=project_id)
        return qs


class ReportDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = DailyReportSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = DailyReport.objects.select_related("project", "task", "created_by")
