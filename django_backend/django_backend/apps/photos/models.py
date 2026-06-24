from django.conf import settings
from django.db import models


class SitePhoto(models.Model):
    PHOTO_TYPE_CHOICES = [
        ("progress", "Avancement"),
        ("problem", "Problème"),
        ("material", "Matériel"),
        ("security", "Sécurité"),
        ("other", "Autre"),
    ]

    project = models.ForeignKey(
        "projects.Project", on_delete=models.CASCADE, related_name="photos"
    )
    report = models.ForeignKey(
        "reports.DailyReport", on_delete=models.SET_NULL, null=True, blank=True, related_name="photos"
    )
    image = models.ImageField(upload_to="site_photos/%Y/%m/")
    description = models.TextField(blank=True)
    photo_type = models.CharField(max_length=20, choices=PHOTO_TYPE_CHOICES, default="other")
    taken_at = models.DateTimeField()
    latitude = models.DecimalField(max_digits=10, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=10, decimal_places=6, null=True, blank=True)
    uploaded_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name="uploaded_photos",
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = "Photo de chantier"
        verbose_name_plural = "Photos de chantier"
        ordering = ["-taken_at"]

    def __str__(self):
        return f"Photo {self.photo_type} — {self.project.name} ({self.taken_at.date()})"
