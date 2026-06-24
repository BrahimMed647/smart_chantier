from django.conf import settings
from django.db import models


class Project(models.Model):
    STATUS_CHOICES = [
        ("planned", "Planifié"),
        ("in_progress", "En cours"),
        ("on_hold", "En pause"),
        ("delayed", "En retard"),
        ("completed", "Terminé"),
        ("cancelled", "Annulé"),
    ]

    name = models.CharField(max_length=300)
    description = models.TextField(blank=True)
    location = models.CharField(max_length=300)
    latitude = models.DecimalField(max_digits=10, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=10, decimal_places=6, null=True, blank=True)
    start_date = models.DateField()
    expected_end_date = models.DateField()
    real_end_date = models.DateField(null=True, blank=True)
    initial_budget = models.DecimalField(max_digits=15, decimal_places=2)
    progress = models.PositiveSmallIntegerField(default=0)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="planned")
    organization = models.ForeignKey(
        "accounts.Organization",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="projects",
    )
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name="created_projects",
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = "Projet"
        verbose_name_plural = "Projets"
        ordering = ["-updated_at"]

    def __str__(self):
        return self.name

    @property
    def total_expenses(self):
        return self.expenses.aggregate(total=models.Sum("amount"))["total"] or 0

    @property
    def remaining_budget(self):
        return float(self.initial_budget) - float(self.total_expenses)
