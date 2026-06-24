import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/theme.dart";
import "../../models/alert.dart";
import "../../providers/data_provider.dart";
import "../../widgets/alert_card.dart";

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Alertes"),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: AppColors.accent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Non lues"),
            Tab(text: "Lues"),
            Tab(text: "Résolues"),
          ],
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, data, _) {
          final unread = data.alerts.where((a) => a.isUnread).toList();
          final read = data.alerts.where((a) => a.status == "read").toList();
          final resolved = data.alerts.where((a) => a.isResolved).toList();
          return TabBarView(
            controller: _tabs,
            children: [
              _AlertList(alerts: unread, onResolve: (id) => data.resolveAlert(id)),
              _AlertList(alerts: read, onResolve: (id) => data.resolveAlert(id)),
              _AlertList(alerts: resolved),
            ],
          );
        },
      ),
    );
  }
}

class _AlertList extends StatelessWidget {
  final List<Alert> alerts;
  final void Function(int id)? onResolve;
  const _AlertList({required this.alerts, this.onResolve});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none, size: 64, color: AppColors.mutedForeground.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            const Text("Aucune alerte", style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: alerts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => AlertCardWidget(
        alert: alerts[i],
        onResolve: onResolve,
      ),
    );
  }
}
