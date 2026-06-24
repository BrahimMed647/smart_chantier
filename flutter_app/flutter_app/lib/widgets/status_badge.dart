import "package:flutter/material.dart";
import "../core/constants.dart";
import "../core/theme.dart";

class StatusBadge extends StatelessWidget {
  final String status;
  final String type; // "project" or "task"

  const StatusBadge({super.key, required this.status, required this.type});

  static const Map<String, Color> _projectColors = {
    "planned": AppColors.info,
    "in_progress": AppColors.accent,
    "on_hold": AppColors.mutedForeground,
    "delayed": AppColors.danger,
    "completed": AppColors.success,
    "cancelled": AppColors.mutedForeground,
  };

  static const Map<String, Color> _taskColors = {
    "todo": AppColors.info,
    "in_progress": AppColors.accent,
    "done": AppColors.success,
    "delayed": AppColors.danger,
    "cancelled": AppColors.mutedForeground,
  };

  @override
  Widget build(BuildContext context) {
    final colors = type == "task" ? _taskColors : _projectColors;
    final labels = type == "task" ? kTaskStatusLabels : kProjectStatusLabels;
    final color = colors[status] ?? AppColors.mutedForeground;
    final label = labels[status] ?? status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
