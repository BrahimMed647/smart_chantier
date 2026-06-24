from django.contrib import admin
from .models import Alert


@admin.register(Alert)
class AlertAdmin(admin.ModelAdmin):
    list_display = ["title", "project", "level", "status", "created_at"]
    list_filter = ["level", "status", "project"]
    search_fields = ["title", "message", "project__name"]
