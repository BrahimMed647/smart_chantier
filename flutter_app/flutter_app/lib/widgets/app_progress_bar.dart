import "package:flutter/material.dart";
import "../core/theme.dart";

class AppProgressBar extends StatelessWidget {
  final double value; // 0.0 — 1.0
  final String? label;
  final Color? color;
  final double height;

  const AppProgressBar({
    super.key,
    required this.value,
    this.label,
    this.color,
    this.height = 8,
  });

  Color _resolveColor() {
    if (color != null) return color!;
    if (value >= 1.0) return AppColors.success;
    if (value >= 0.6) return AppColors.primary;
    if (value >= 0.3) return AppColors.accent;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final c = _resolveColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            backgroundColor: c.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(c),
            minHeight: height,
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(label!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ],
    );
  }
}
