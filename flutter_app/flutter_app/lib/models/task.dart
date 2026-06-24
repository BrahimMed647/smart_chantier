class Task {
  final int id;
  final int project;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final int progress;
  final String priority;
  final String status;
  final int? assignedTo;
  final String? assignedToName;
  final int? createdBy;
  final String? createdByName;
  final bool isOverdue;
  final String createdAt;

  const Task({
    required this.id,
    required this.project,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.priority,
    required this.status,
    this.assignedTo,
    this.assignedToName,
    this.createdBy,
    this.createdByName,
    required this.isOverdue,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"] as int,
        project: json["project"] as int,
        title: json["title"] as String,
        description: json["description"] as String? ?? "",
        startDate: json["start_date"] as String,
        endDate: json["end_date"] as String,
        progress: json["progress"] as int? ?? 0,
        priority: json["priority"] as String,
        status: json["status"] as String,
        assignedTo: json["assigned_to"] as int?,
        assignedToName: json["assigned_to_name"] as String?,
        createdBy: json["created_by"] as int?,
        createdByName: json["created_by_name"] as String?,
        isOverdue: json["is_overdue"] as bool? ?? false,
        createdAt: json["created_at"] as String,
      );
}
