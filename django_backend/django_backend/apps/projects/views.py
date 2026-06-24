from django.db.models import Count, Q, Sum
from rest_framework import generics, permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

from .models import Project
from .serializers import ProjectListSerializer, ProjectSerializer


class ProjectListCreateView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    filterset_fields = ["status", "organization"]
    search_fields = ["name", "location", "description"]
    ordering_fields = ["created_at", "updated_at", "progress", "status"]

    def get_serializer_class(self):
        if self.request.method == "GET":
            return ProjectListSerializer
        return ProjectSerializer

    def get_queryset(self):
        return Project.objects.select_related(
            "created_by", "organization"
        ).prefetch_related("expenses").filter(
            Q(organization=self.request.user.organization)
            | Q(created_by=self.request.user)
        ).distinct()


class ProjectDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = ProjectSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Project.objects.select_related(
            "created_by", "organization"
        ).prefetch_related("expenses")


@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def project_budget_view(request, pk):
    try:
        project = Project.objects.prefetch_related("expenses").get(pk=pk)
    except Project.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    from apps.expenses.models import Expense
    expenses = Expense.objects.filter(project=project)
    by_category = {}
    for exp in expenses:
        by_category[exp.category] = by_category.get(exp.category, 0) + float(exp.amount)

    total_expenses = sum(by_category.values())
    budget = float(project.initial_budget)

    return Response({
        "initial_budget": budget,
        "total_expenses": total_expenses,
        "remaining": budget - total_expenses,
        "budget_percentage": round((total_expenses / budget * 100) if budget > 0 else 0),
        "by_category": by_category,
    })


@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def dashboard_view(request):
    user = request.user
    base_qs = Project.objects.filter(
        Q(organization=user.organization) | Q(created_by=user)
    ).distinct()

    projects_stats = base_qs.aggregate(
        total=Count("id"),
        in_progress=Count("id", filter=Q(status="in_progress")),
        delayed=Count("id", filter=Q(status="delayed")),
        completed=Count("id", filter=Q(status="completed")),
        planned=Count("id", filter=Q(status="planned")),
    )

    from apps.tasks.models import Task
    from apps.alerts.models import Alert

    tasks_stats = Task.objects.filter(project__in=base_qs).aggregate(
        total=Count("id"),
        done=Count("id", filter=Q(status="done")),
        in_progress=Count("id", filter=Q(status="in_progress")),
        delayed=Count("id", filter=Q(status="delayed")),
    )

    unread_alerts = Alert.objects.filter(
        project__in=base_qs,
        status__in=["unread", "read"],
    ).count()

    total_budget = base_qs.aggregate(total=Sum("initial_budget"))["total"] or 0
    from apps.expenses.models import Expense
    total_expenses = Expense.objects.filter(project__in=base_qs).aggregate(
        total=Sum("amount")
    )["total"] or 0

    return Response({
        "projects": projects_stats,
        "tasks": tasks_stats,
        "unread_alerts": unread_alerts,
        "budget": {
            "total": float(total_budget),
            "total_expenses": float(total_expenses),
            "remaining": float(total_budget) - float(total_expenses),
        },
    })
