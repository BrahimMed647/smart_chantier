class Expense {
  final int id;
  final int project;
  final String? projectName;
  final String title;
  final String description;
  final double amount;
  final String category;
  final String expenseDate;
  final int? createdBy;
  final String? createdByName;
  final String createdAt;

  const Expense({
    required this.id,
    required this.project,
    this.projectName,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.expenseDate,
    this.createdBy,
    this.createdByName,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json["id"] as int,
        project: json["project"] as int,
        projectName: json["project_name"] as String?,
        title: json["title"] as String,
        description: json["description"] as String? ?? "",
        amount: (json["amount"] as num).toDouble(),
        category: json["category"] as String,
        expenseDate: json["expense_date"] as String,
        createdBy: json["created_by"] as int?,
        createdByName: json["created_by_name"] as String?,
        createdAt: json["created_at"] as String,
      );
}
