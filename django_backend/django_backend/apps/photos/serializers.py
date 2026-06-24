from rest_framework import serializers
from .models import SitePhoto


class SitePhotoSerializer(serializers.ModelSerializer):
    uploaded_by_name = serializers.CharField(source="uploaded_by.name", read_only=True)
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = SitePhoto
        fields = [
            "id", "project", "report", "image", "image_url",
            "description", "photo_type", "taken_at",
            "latitude", "longitude",
            "uploaded_by", "uploaded_by_name", "created_at",
        ]
        read_only_fields = ["id", "created_at", "uploaded_by"]

    def get_image_url(self, obj):
        request = self.context.get("request")
        if obj.image and request:
            return request.build_absolute_uri(obj.image.url)
        return None

    def create(self, validated_data):
        validated_data["uploaded_by"] = self.context["request"].user
        return super().create(validated_data)
