from django.contrib import admin
from .models import SitePhoto


@admin.register(SitePhoto)
class SitePhotoAdmin(admin.ModelAdmin):
    list_display = ["project", "photo_type", "taken_at", "uploaded_by"]
    list_filter = ["photo_type", "project"]
