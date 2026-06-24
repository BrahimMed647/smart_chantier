class DailyReport {
  final int id;
  final int project;
  final String? projectName;
  final int? task;
  final String reportDate;
  final String workDone;
  final int workersCount;
  final String materialsUsed;
  final String equipmentUsed;
  final String problems;
  final String solutions;
  final String weather;
  final String remarks;
  final int progressToday;
  final int? createdBy;
  final String? createdByName;
  final String createdAt;

  const DailyReport({
    required this.id,
    required this.project,
    this.projectName,
    this.task,
    required this.reportDate,
    required this.workDone,
    required this.workersCount,
    required this.materialsUsed,
    required this.equipmentUsed,
    required this.problems,
    required this.solutions,
    required this.weather,
    required this.remarks,
    required this.progressToday,
    this.createdBy,
    this.createdByName,
    required this.createdAt,
  });

  factory DailyReport.fromJson(Map<String, dynamic> json) => DailyReport(
        id: json["id"] as int,
        project: json["project"] as int,
        projectName: json["project_name"] as String?,
        task: json["task"] as int?,
        reportDate: json["report_date"] as String,
        workDone: json["work_done"] as String,
        workersCount: json["workers_count"] as int? ?? 0,
        materialsUsed: json["materials_used"] as String? ?? "—",
        equipmentUsed: json["equipment_used"] as String? ?? "—",
        problems: json["problems"] as String? ?? "Aucun",
        solutions: json["solutions"] as String? ?? "RAS",
        weather: json["weather"] as String? ?? "",
        remarks: json["remarks"] as String? ?? "",
        progressToday: json["progress_today"] as int? ?? 0,
        createdBy: json["created_by"] as int?,
        createdByName: json["created_by_name"] as String?,
        createdAt: json["created_at"] as String,
      );
}
