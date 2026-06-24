from django.utils import timezone
from rest_framework import generics, permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

from .models import Alert
from .serializers import AlertSerializer


class AlertListCreateView(generics.ListCreateAPIView):
    serializer_class = AlertSerializer
    permission_classes = [permissions.IsAuthenticated]
    filterset_fields = ["project", "level", "status"]
    ordering_fields = ["created_at", "level"]

    def get_queryset(self):
        qs = Alert.objects.select_related("project", "task", "created_by")
        project_id = self.kwargs.get("project_pk") or self.request.query_params.get("project")
        if project_id:
            qs = qs.filter(project_id=project_id)
        return qs


class AlertDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = AlertSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = Alert.objects.select_related("project", "task", "created_by")


@api_view(["PATCH"])
@permission_classes([permissions.IsAuthenticated])
def resolve_alert(request, pk):
    try:
        alert = Alert.objects.get(pk=pk)
    except Alert.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    alert.status = "resolved"
    alert.resolved_at = timezone.now()
    alert.save()
    return Response(AlertSerializer(alert).data)


@api_view(["PATCH"])
@permission_classes([permissions.IsAuthenticated])
def mark_read(request, pk):
    try:
        alert = Alert.objects.get(pk=pk)
    except Alert.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if alert.status == "unread":
        alert.status = "read"
        alert.save()
    return Response(AlertSerializer(alert).data)
