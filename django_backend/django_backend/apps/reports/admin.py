from django.contrib import admin
from .models import DailyReport


@admin.register(DailyReport)
class DailyReportAdmin(admin.ModelAdmin):
    list_display = ["report_date", "project", "workers_count", "progress_today", "weather"]
    list_filter = ["project", "report_date"]
    search_fields = ["project__name", "work_done"]
    ordering = ["-report_date"]
