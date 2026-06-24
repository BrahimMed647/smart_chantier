import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../providers/data_provider.dart";
import "../alerts/alerts_screen.dart";
import "../dashboard/dashboard_screen.dart";
import "../profile/profile_screen.dart";
import "../projects/projects_screen.dart";
import "../reports/reports_screen.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ProjectsScreen(),
    ReportsScreen(),
    AlertsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Consumer<DataProvider>(
        builder: (context, data, _) {
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: "Tableau de bord",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.business_outlined),
                activeIcon: Icon(Icons.business),
                label: "Projets",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.description_outlined),
                activeIcon: Icon(Icons.description),
                label: "Rapports",
              ),
              BottomNavigationBarItem(
                icon: data.unreadAlertsCount > 0
                    ? Badge(
                        label: Text("${data.unreadAlertsCount}"),
                        child: const Icon(Icons.notifications_outlined),
                      )
                    : const Icon(Icons.notifications_outlined),
                activeIcon: const Icon(Icons.notifications),
                label: "Alertes",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                activeIcon: Icon(Icons.person),
                label: "Profil",
              ),
            ],
          );
        },
      ),
    );
  }
}
