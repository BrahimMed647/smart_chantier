import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/constants.dart";
import "../../core/theme.dart";
import "../../providers/auth_provider.dart";
import "../../providers/data_provider.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Profil")),
      body: Consumer2<AuthProvider, DataProvider>(
        builder: (context, auth, data, _) {
          final user = auth.user;
          if (user == null) return const Center(child: CircularProgressIndicator());
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildUserCard(user, data),
                const SizedBox(height: 16),
                _buildStatsCard(data),
                const SizedBox(height: 16),
                _buildMenuCard(context, auth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(user, DataProvider data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Text(
                user.initials,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(user.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                kRoleLabels[user.role] ?? user.role,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
            if (user.organizationName != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.business, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(user.organizationName!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(DataProvider data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mes statistiques", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Row(
              children: [
                _statItem(Icons.business, "${data.projects.length}", "Projets"),
                _statItem(Icons.task_alt, "${data.tasks.length}", "Tâches"),
                _statItem(Icons.description, "${data.reports.length}", "Rapports"),
                _statItem(Icons.notifications, "${data.unreadAlertsCount}", "Alertes"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, AuthProvider auth) {
    final items = [
      (_MenuAction("Mon compte", Icons.person_outline, AppColors.primary, null)),
      (_MenuAction("Paramètres", Icons.settings_outlined, AppColors.textSecondary, null)),
      (_MenuAction("Aide & Support", Icons.help_outline, AppColors.info, null)),
      (_MenuAction("Déconnexion", Icons.logout, AppColors.danger, () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Déconnexion"),
            content: const Text("Voulez-vous vraiment vous déconnecter?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Déconnecter", style: TextStyle(color: AppColors.danger)),
              ),
            ],
          ),
        );
        if (confirm == true) await auth.logout();
      })),
    ];
    return Card(
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: item.color),
                title: Text(item.label, style: TextStyle(color: item.color)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.mutedForeground),
                onTap: item.onTap,
              ),
              if (i < items.length - 1) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _MenuAction(this.label, this.icon, this.color, this.onTap);
}
