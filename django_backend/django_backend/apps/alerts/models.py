from django.conf import settings
from django.db import models


class Alert(models.Model):
    LEVEL_CHOICES = [
        ("info", "Info"),
        ("warning", "Attention"),
        ("critical", "Critique"),
    ]
    STATUS_CHOICES = [
        ("unread", "Non lu"),
        ("read", "Lu"),
        ("resolved", "Résolu"),
    ]

    project = models.ForeignKey(
        "projects.Project", on_delete=models.CASCADE, related_name="alerts"
    )
    task = models.ForeignKey(
        "tasks.Task", on_delete=models.SET_NULL, null=True, blank=True, related_name="alerts"
    )
    alert_type = models.CharField(max_length=50)
    level = models.CharField(max_length=10, choices=LEVEL_CHOICES, default="info")
    title = models.CharField(max_length=300)
    message = models.TextField()
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default="unread")
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name="created_alerts",
    )
    created_at = models.DateTimeField(auto_now_add=True)
    resolved_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        verbose_name = "Alerte"
        verbose_name_plural = "Alertes"
        ordering = ["-created_at"]

    def __str__(self):
        return f"[{self.level.upper()}] {self.title}"
