import "package:flutter/material.dart";

import "../core/theme.dart";
import "../models/daily_report.dart";

class ReportCardWidget extends StatelessWidget {
  final DailyReport report;
  final bool showProject;

  const ReportCardWidget({super.key, required this.report, this.showProject = false});

  @override
  Widget build(BuildContext context) {
    final r = report;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.description, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rapport du ${r.reportDate}",
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      if (showProject && r.projectName != null)
                        Text(r.projectName!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, size: 12, color: AppColors.success),
                      const SizedBox(width: 3),
                      Text("+${r.progressToday}%", style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(r.workDone, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _chip(Icons.people_outline, "${r.workersCount} ouvriers"),
                if (r.weather.isNotEmpty) _chip(Icons.wb_sunny_outlined, r.weather),
                if (r.problems != "Aucun") _chip(Icons.warning_amber_outlined, "Problèmes signalés", AppColors.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, [Color? color]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(color: color ?? AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}
