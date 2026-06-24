import "package:flutter/material.dart";

import "../core/theme.dart";
import "../models/alert.dart";

class AlertCardWidget extends StatelessWidget {
  final Alert alert;
  final void Function(int id)? onResolve;

  const AlertCardWidget({super.key, required this.alert, this.onResolve});

  static const Map<String, Color> _levelColors = {
    "critical": AppColors.danger,
    "warning": AppColors.warning,
    "info": AppColors.info,
  };

  static const Map<String, Color> _levelBg = {
    "critical": AppColors.dangerLight,
    "warning": AppColors.warningLight,
    "info": AppColors.infoLight,
  };

  static const Map<String, IconData> _levelIcons = {
    "critical": Icons.error,
    "warning": Icons.warning_amber,
    "info": Icons.info,
  };

  @override
  Widget build(BuildContext context) {
    final a = alert;
    final color = _levelColors[a.level] ?? AppColors.textSecondary;
    final bg = _levelBg[a.level] ?? AppColors.muted;
    final icon = _levelIcons[a.level] ?? Icons.notifications;
    final isResolved = a.isResolved;

    return Opacity(
      opacity: isResolved ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: isResolved ? AppColors.border : color, width: 4)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: isResolved ? AppColors.muted : bg, borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, color: isResolved ? AppColors.mutedForeground : color, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        if (a.projectName != null)
                          Text(a.projectName!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isResolved ? AppColors.successLight : bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isResolved ? "Résolu" : _capitalize(a.level),
                      style: TextStyle(
                        color: isResolved ? AppColors.success : color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(a.message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
              if (!isResolved && onResolve != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => onResolve!(a.id),
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text("Marquer résolu"),
                    style: TextButton.styleFrom(foregroundColor: AppColors.success, padding: EdgeInsets.zero),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
