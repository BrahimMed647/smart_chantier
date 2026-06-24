from rest_framework import serializers
from .models import Task


class TaskSerializer(serializers.ModelSerializer):
    assigned_to_name = serializers.CharField(source="assigned_to.name", read_only=True)
    created_by_name = serializers.CharField(source="created_by.name", read_only=True)
    is_overdue = serializers.SerializerMethodField()

    class Meta:
        model = Task
        fields = [
            "id", "project", "title", "description",
            "start_date", "end_date", "progress", "priority", "status",
            "assigned_to", "assigned_to_name",
            "created_by", "created_by_name",
            "is_overdue", "created_at", "updated_at",
        ]
        read_only_fields = ["id", "created_at", "updated_at", "created_by"]

    def get_is_overdue(self, obj):
        from datetime import date
        return (
            obj.end_date < date.today()
            and obj.status not in ("done", "cancelled")
        )

    def create(self, validated_data):
        validated_data["created_by"] = self.context["request"].user
        return super().create(validated_data)
