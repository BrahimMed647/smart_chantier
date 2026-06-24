class Alert {
  final int id;
  final int project;
  final String? projectName;
  final int? task;
  final String alertType;
  final String level;
  final String title;
  final String message;
  final String status;
  final int? createdBy;
  final String? createdByName;
  final String createdAt;
  final String? resolvedAt;

  const Alert({
    required this.id,
    required this.project,
    this.projectName,
    this.task,
    required this.alertType,
    required this.level,
    required this.title,
    required this.message,
    required this.status,
    this.createdBy,
    this.createdByName,
    required this.createdAt,
    this.resolvedAt,
  });

  bool get isResolved => status == "resolved";
  bool get isUnread => status == "unread";

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        id: json["id"] as int,
        project: json["project"] as int,
        projectName: json["project_name"] as String?,
        task: json["task"] as int?,
        alertType: json["alert_type"] as String,
        level: json["level"] as String,
        title: json["title"] as String,
        message: json["message"] as String,
        status: json["status"] as String,
        createdBy: json["created_by"] as int?,
        createdByName: json["created_by_name"] as String?,
        createdAt: json["created_at"] as String,
        resolvedAt: json["resolved_at"] as String?,
      );
}
