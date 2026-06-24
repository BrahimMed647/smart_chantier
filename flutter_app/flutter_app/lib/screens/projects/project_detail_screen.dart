import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "../../core/theme.dart";
import "../../models/project.dart";
import "../../providers/data_provider.dart";
import "../../widgets/alert_card.dart";
import "../../widgets/app_progress_bar.dart";
import "../../widgets/report_card.dart";
import "../../widgets/status_badge.dart";
import "../../widgets/task_card.dart";
import "../expenses/expenses_screen.dart";

class ProjectDetailScreen extends StatefulWidget {
  final Project project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(p.name, overflow: TextOverflow.ellipsis),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.accent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Aperçu"),
            Tab(text: "Tâches"),
            Tab(text: "Rapports"),
            Tab(text: "Dépenses"),
            Tab(text: "Alertes"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OverviewTab(project: p),
          _TasksTab(projectId: p.id),
          _ReportsTab(projectId: p.id),
          ExpensesScreen(projectId: p.id),
          _AlertsTab(projectId: p.id),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Project project;
  const _OverviewTab({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = project;
    final fmt = NumberFormat("#,##0", "fr_FR");
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(p.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                      StatusBadge(status: p.status, type: "project"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(p.location,
                          style:
                              const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  if (p.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(p.description,
                        style: const TextStyle(
                            color: AppColors.textSecondary, height: 1.5)),
                  ],
                  const SizedBox(height: 16),
                  const Text("Avancement global",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  AppProgressBar(
                      value: p.progress / 100, label: "${p.progress}%"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Budget",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  _budgetRow("Budget initial", fmt.format(p.initialBudget),
                      AppColors.primary),
                  const Divider(height: 16),
                  _budgetRow("Dépenses", fmt.format(p.totalExpenses),
                      AppColors.danger),
                  const Divider(height: 16),
                  _budgetRow("Restant", fmt.format(p.remainingBudget),
                      AppColors.success),
                  const SizedBox(height: 12),
                  AppProgressBar(
                    value: (p.budgetPercentage / 100).clamp(0.0, 1.0),
                    label: "${p.budgetPercentage}% utilisé",
                    color: p.budgetPercentage > 90
                        ? AppColors.danger
                        : AppColors.accent,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _dateRow(Icons.play_arrow_outlined, "Début", p.startDate),
                  const Divider(height: 12),
                  _dateRow(
                      Icons.flag_outlined, "Fin prévue", p.expectedEndDate),
                  if (p.realEndDate != null) ...[
                    const Divider(height: 12),
                    _dateRow(Icons.check_circle_outline, "Fin réelle",
                        p.realEndDate!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _budgetRow(String label, String amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text("$amount DA",
            style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }

  Widget _dateRow(IconData icon, String label, String date) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const Spacer(),
        Text(date, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _TasksTab extends StatelessWidget {
  final int projectId;
  const _TasksTab({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, data, _) {
        final tasks = data.tasksForProject(projectId);
        if (tasks.isEmpty) {
          return const Center(
              child: Text("Aucune tâche",
                  style: TextStyle(color: AppColors.textSecondary)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => TaskCardWidget(task: tasks[i]),
        );
      },
    );
  }
}

class _ReportsTab extends StatelessWidget {
  final int projectId;
  const _ReportsTab({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, data, _) {
        final reports = data.reportsForProject(projectId);
        if (reports.isEmpty) {
          return const Center(
              child: Text("Aucun rapport",
                  style: TextStyle(color: AppColors.textSecondary)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => ReportCardWidget(report: reports[i]),
        );
      },
    );
  }
}

class _AlertsTab extends StatelessWidget {
  final int projectId;
  const _AlertsTab({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, data, _) {
        final alerts = data.alertsForProject(projectId);
        if (alerts.isEmpty) {
          return const Center(
              child: Text("Aucune alerte",
                  style: TextStyle(color: AppColors.textSecondary)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: alerts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => AlertCardWidget(alert: alerts[i]),
        );
      },
    );
  }
}
