from rest_framework import serializers
from .models import DailyReport


class DailyReportSerializer(serializers.ModelSerializer):
    created_by_name = serializers.CharField(source="created_by.name", read_only=True)
    project_name = serializers.CharField(source="project.name", read_only=True)

    class Meta:
        model = DailyReport
        fields = [
            "id", "project", "project_name", "task",
            "report_date", "work_done", "workers_count",
            "materials_used", "equipment_used",
            "problems", "solutions", "weather", "remarks",
            "progress_today", "created_by", "created_by_name", "created_at",
        ]
        read_only_fields = ["id", "created_at", "created_by"]

    def create(self, validated_data):
        validated_data["created_by"] = self.context["request"].user
        return super().create(validated_data)
