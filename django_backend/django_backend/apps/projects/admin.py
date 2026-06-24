from django.contrib import admin
from .models import Project


@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    list_display = ["name", "location", "status", "progress", "initial_budget", "created_by"]
    list_filter = ["status", "organization"]
    search_fields = ["name", "location"]
    ordering = ["-updated_at"]
