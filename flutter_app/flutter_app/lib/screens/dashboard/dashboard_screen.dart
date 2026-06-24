import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "../../core/theme.dart";
import "../../models/project.dart";
import "../../providers/auth_provider.dart";
import "../../providers/data_provider.dart";
import "../../widgets/alert_card.dart";
import "../../widgets/status_badge.dart";
import "../projects/project_detail_screen.dart";

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<DataProvider>(
        builder: (context, data, _) {
          final dash = data.dashboard;
          final projects = dash["projects"] as Map<String, dynamic>? ?? {};
          final tasks    = dash["tasks"]    as Map<String, dynamic>? ?? {};
          final budget   = dash["budget"]   as Map<String, dynamic>? ?? {};

          return RefreshIndicator(
            onRefresh: data.loadAll,
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 80),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Budget compact ────────────────────────────────────
                      _buildBudgetCard(budget),
                      const SizedBox(height: 10),

                      // ── 4 stats en ligne ──────────────────────────────────
                      _buildStatsRow(projects, tasks, data),
                      const SizedBox(height: 14),

                      // ── Projets en cours ──────────────────────────────────
                      _sectionHeader("Projets en cours", Icons.business),
                      const SizedBox(height: 8),
                      if (data.isLoading && data.projects.isEmpty)
                        const Center(child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ))
                      else if (data.projects.isEmpty)
                        _emptyBox("Aucun projet pour le moment")
                      else
                        ...data.projects
                            .where((p) => p.status != "completed" && p.status != "cancelled")
                            .take(4)
                            .map((p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _ProjectMiniCard(project: p),
                                )),

                      const SizedBox(height: 14),

                      // ── Alertes récentes ─────────────────────────────────
                      _sectionHeader("Alertes récentes", Icons.notifications_outlined),
                      const SizedBox(height: 8),
                      if (data.alerts.where((a) => !a.isResolved).isEmpty)
                        _emptyBox("Aucune alerte active")
                      else
                        ...data.alerts
                            .where((a) => !a.isResolved)
                            .take(3)
                            .map((a) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: AlertCardWidget(alert: a),
                                )),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── AppBar compact ────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final now  = DateFormat("EEE d MMM yyyy", "fr_FR").format(DateTime.now());
    return SliverAppBar(
      expandedHeight: 90,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bonjour, ${auth.user?.name.split(" ").first ?? "Admin"}",
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Text(now, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 19,
                backgroundColor: AppColors.accent,
                child: Text(
                  auth.user?.initials ?? "A",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Budget card compact ───────────────────────────────────────────────────
  Widget _buildBudgetCard(Map<String, dynamic> budget) {
    final total = (budget["total"]          as num?)?.toDouble() ?? 0;
    final spent = (budget["total_expenses"] as num?)?.toDouble() ?? 0;
    final pct   = total > 0 ? (spent / total) : 0.0;
    final fmt   = NumberFormat("#,##0", "fr_FR");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Budget Total Géré", style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text("${(pct * 100).toStringAsFixed(0)}% utilisé",
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${fmt.format(total)} DA",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              Text("Dépensé: ${fmt.format(spent)} DA",
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: AlwaysStoppedAnimation<Color>(
                  pct > 0.9 ? AppColors.danger : AppColors.accent),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // ── 4 stats en une seule ligne ────────────────────────────────────────────
  Widget _buildStatsRow(Map<String, dynamic> projects, Map<String, dynamic> tasks, DataProvider data) {
    return Row(
      children: [
        _statChip("Projets actifs", "${projects["in_progress"] ?? data.projects.where((p) => p.status == "in_progress").length}", AppColors.primary, Icons.business),
        const SizedBox(width: 8),
        _statChip("Tâches",        "${tasks["in_progress"] ?? data.tasks.where((t) => t.status == "in_progress").length}", AppColors.accent,  Icons.task_alt),
        const SizedBox(width: 8),
        _statChip("Alertes",       "${data.unreadAlertsCount}",  AppColors.danger,  Icons.notifications),
        const SizedBox(width: 8),
        _statChip("Rapports",      "${data.reports.length}",     AppColors.success, Icons.description),
      ],
    );
  }

  Widget _statChip(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _emptyBox(String msg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Center(child: Text(msg, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
    );
  }
}

// ── Mini card projet ──────────────────────────────────────────────────────────
class _ProjectMiniCard extends StatelessWidget {
  final Project project;
  const _ProjectMiniCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,##0", "fr_FR");
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: project))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(project.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: project.status, type: "project"),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textSecondary),
                const SizedBox(width: 2),
                Text(project.location, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                const Spacer(),
                Text("${fmt.format(project.initialBudget)} DA",
                    style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: project.progress / 100,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          project.progress >= 100 ? AppColors.success :
                          project.progress >= 60  ? AppColors.accent  : AppColors.primary),
                      minHeight: 5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text("${project.progress}%",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
