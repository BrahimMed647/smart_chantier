from django.db.models import Sum
from rest_framework import serializers

from .models import Project


class ProjectSerializer(serializers.ModelSerializer):
    total_expenses = serializers.SerializerMethodField()
    remaining_budget = serializers.SerializerMethodField()
    budget_percentage = serializers.SerializerMethodField()
    created_by_name = serializers.CharField(source="created_by.name", read_only=True)
    organization_name = serializers.CharField(source="organization.name", read_only=True)

    class Meta:
        model = Project
        fields = [
            "id", "name", "description", "location", "latitude", "longitude",
            "start_date", "expected_end_date", "real_end_date",
            "initial_budget", "progress", "status",
            "organization", "organization_name",
            "created_by", "created_by_name",
            "total_expenses", "remaining_budget", "budget_percentage",
            "created_at", "updated_at",
        ]
        read_only_fields = ["id", "created_at", "updated_at", "created_by"]

    def get_total_expenses(self, obj):
        return float(obj.expenses.aggregate(total=Sum("amount"))["total"] or 0)

    def get_remaining_budget(self, obj):
        return float(obj.initial_budget) - self.get_total_expenses(obj)

    def get_budget_percentage(self, obj):
        budget = float(obj.initial_budget)
        if budget == 0:
            return 0
        return round((self.get_total_expenses(obj) / budget) * 100)

    def create(self, validated_data):
        validated_data["created_by"] = self.context["request"].user
        return super().create(validated_data)


class ProjectListSerializer(serializers.ModelSerializer):
    total_expenses = serializers.SerializerMethodField()
    remaining_budget = serializers.SerializerMethodField()
    budget_percentage = serializers.SerializerMethodField()
    created_by_name = serializers.CharField(source="created_by.name", read_only=True)
    organization_name = serializers.CharField(source="organization.name", read_only=True)

    class Meta:
        model = Project
        fields = [
            "id", "name", "description", "location", "latitude", "longitude",
            "start_date", "expected_end_date", "real_end_date",
            "initial_budget", "progress", "status",
            "organization", "organization_name",
            "created_by", "created_by_name",
            "total_expenses", "remaining_budget", "budget_percentage",
            "created_at", "updated_at",
        ]

    def get_total_expenses(self, obj):
        return float(obj.expenses.aggregate(total=Sum("amount"))["total"] or 0)

    def get_remaining_budget(self, obj):
        return float(obj.initial_budget) - self.get_total_expenses(obj)

    def get_budget_percentage(self, obj):
        budget = float(obj.initial_budget)
        if budget == 0:
            return 0
        return round((self.get_total_expenses(obj) / budget) * 100)
