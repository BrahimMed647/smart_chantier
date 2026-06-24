import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/theme.dart";
import "../../providers/data_provider.dart";
import "../../widgets/report_card.dart";
import "add_report_screen.dart";

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Rapports journaliers")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddReportScreen()),
        ),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add),
        label: const Text("Nouveau rapport"),
      ),
      body: Consumer<DataProvider>(
        builder: (context, data, _) {
          if (data.isLoading && data.reports.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (data.reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.description_outlined, size: 64, color: AppColors.mutedForeground.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  const Text("Aucun rapport", style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: data.loadAll,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: data.reports.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => ReportCardWidget(report: data.reports[i], showProject: true),
            ),
          );
        },
      ),
    );
  }
}
