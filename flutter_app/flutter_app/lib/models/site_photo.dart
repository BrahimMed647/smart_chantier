class SitePhoto {
  final int id;
  final int project;
  final int? report;
  final String? imageUrl;
  final String description;
  final String photoType;
  final String takenAt;
  final double? latitude;
  final double? longitude;
  final int? uploadedBy;
  final String? uploadedByName;
  final String createdAt;

  const SitePhoto({
    required this.id,
    required this.project,
    this.report,
    this.imageUrl,
    required this.description,
    required this.photoType,
    required this.takenAt,
    this.latitude,
    this.longitude,
    this.uploadedBy,
    this.uploadedByName,
    required this.createdAt,
  });

  factory SitePhoto.fromJson(Map<String, dynamic> json) => SitePhoto(
        id: json["id"] as int,
        project: json["project"] as int,
        report: json["report"] as int?,
        imageUrl: json["image_url"] as String?,
        description: json["description"] as String? ?? "",
        photoType: json["photo_type"] as String,
        takenAt: json["taken_at"] as String,
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
        uploadedBy: json["uploaded_by"] as int?,
        uploadedByName: json["uploaded_by_name"] as String?,
        createdAt: json["created_at"] as String,
      );
}
