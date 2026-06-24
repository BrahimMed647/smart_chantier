from django.contrib import admin
from .models import Task


@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    list_display = ["title", "project", "status", "priority", "progress", "end_date"]
    list_filter = ["status", "priority"]
    search_fields = ["title", "project__name"]
