import "package:flutter/material.dart";

import "../core/constants.dart";
import "../core/theme.dart";
import "../models/task.dart";
import "app_progress_bar.dart";
import "status_badge.dart";

class TaskCardWidget extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCardWidget({super.key, required this.task, this.onTap});

  static const Map<String, Color> _priorityColors = {
    "critical": AppColors.danger,
    "high": AppColors.warning,
    "medium": AppColors.info,
    "low": AppColors.success,
  };

  @override
  Widget build(BuildContext context) {
    final t = task;
    final priorityColor = _priorityColors[t.priority] ?? AppColors.textSecondary;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 36,
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                kTaskPriorityLabels[t.priority] ?? t.priority,
                                style: TextStyle(color: priorityColor, fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (t.isOverdue) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.danger.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text("En retard", style: TextStyle(color: AppColors.danger, fontSize: 10, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: t.status, type: "task"),
                ],
              ),
              const SizedBox(height: 10),
              AppProgressBar(value: t.progress / 100, label: "${t.progress}%"),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.event, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text("Fin: ${t.endDate}", style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  if (t.assignedToName != null) ...[
                    const SizedBox(width: 12),
                    const Icon(Icons.person_outline, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        t.assignedToName!,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
