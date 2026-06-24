from django.conf import settings
from django.db import models


class DailyReport(models.Model):
    project = models.ForeignKey(
        "projects.Project", on_delete=models.CASCADE, related_name="reports"
    )
    task = models.ForeignKey(
        "tasks.Task", on_delete=models.SET_NULL, null=True, blank=True, related_name="reports"
    )
    report_date = models.DateField()
    work_done = models.TextField()
    workers_count = models.PositiveSmallIntegerField(default=0)
    materials_used = models.TextField(blank=True, default="—")
    equipment_used = models.TextField(blank=True, default="—")
    problems = models.TextField(blank=True, default="Aucun")
    solutions = models.TextField(blank=True, default="RAS")
    weather = models.CharField(max_length=100, blank=True)
    remarks = models.TextField(blank=True)
    progress_today = models.PositiveSmallIntegerField(default=0)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name="created_reports",
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = "Rapport journalier"
        verbose_name_plural = "Rapports journaliers"
        ordering = ["-report_date"]

    def __str__(self):
        return f"Rapport {self.report_date} — {self.project.name}"
