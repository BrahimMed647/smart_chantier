from django.conf import settings
from django.db import models


class Expense(models.Model):
    CATEGORY_CHOICES = [
        ("materials", "Matériaux"),
        ("labor", "Main d'œuvre"),
        ("transport", "Transport"),
        ("equipment", "Équipement"),
        ("subcontractor", "Sous-traitant"),
        ("administrative", "Administratif"),
        ("other", "Autre"),
    ]

    project = models.ForeignKey(
        "projects.Project", on_delete=models.CASCADE, related_name="expenses"
    )
    title = models.CharField(max_length=300)
    description = models.TextField(blank=True)
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default="other")
    expense_date = models.DateField()
    receipt = models.FileField(upload_to="receipts/", null=True, blank=True)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name="created_expenses",
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = "Dépense"
        verbose_name_plural = "Dépenses"
        ordering = ["-expense_date"]

    def __str__(self):
        return f"{self.title} — {self.amount} DA ({self.project.name})"
