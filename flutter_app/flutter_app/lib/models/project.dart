class Project {
  final int id;
  final String name;
  final String description;
  final String location;
  final double? latitude;
  final double? longitude;
  final String startDate;
  final String expectedEndDate;
  final String? realEndDate;
  final double initialBudget;
  final int progress;
  final String status;
  final int? organization;
  final String? organizationName;
  final int? createdBy;
  final String? createdByName;
  final double totalExpenses;
  final double remainingBudget;
  final int budgetPercentage;
  final String createdAt;
  final String updatedAt;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.latitude,
    this.longitude,
    required this.startDate,
    required this.expectedEndDate,
    this.realEndDate,
    required this.initialBudget,
    required this.progress,
    required this.status,
    this.organization,
    this.organizationName,
    this.createdBy,
    this.createdByName,
    required this.totalExpenses,
    required this.remainingBudget,
    required this.budgetPercentage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"] as int,
        name: json["name"] as String,
        description: json["description"] as String? ?? "",
        location: json["location"] as String,
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
        startDate: json["start_date"] as String,
        expectedEndDate: json["expected_end_date"] as String,
        realEndDate: json["real_end_date"] as String?,
        initialBudget: (json["initial_budget"] as num).toDouble(),
        progress: json["progress"] as int? ?? 0,
        status: json["status"] as String,
        organization: json["organization"] as int?,
        organizationName: json["organization_name"] as String?,
        createdBy: json["created_by"] as int?,
        createdByName: json["created_by_name"] as String?,
        totalExpenses: (json["total_expenses"] as num?)?.toDouble() ?? 0,
        remainingBudget: (json["remaining_budget"] as num?)?.toDouble() ?? 0,
        budgetPercentage: json["budget_percentage"] as int? ?? 0,
        createdAt: json["created_at"] as String,
        updatedAt: json["updated_at"] as String,
      );
}
