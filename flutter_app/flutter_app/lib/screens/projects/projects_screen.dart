import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/constants.dart";
import "../../core/theme.dart";
import "../../models/project.dart";
import "../../providers/data_provider.dart";
import "../../widgets/project_card.dart";
import "project_detail_screen.dart";

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _search = "";
  String _statusFilter = "all";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Projets"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => context.read<DataProvider>().loadAll()),
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, data, _) {
          final filtered = _filter(data.projects);
          return Column(
            children: [
              _buildSearchBar(),
              _buildFilterChips(),
              Expanded(
                child: data.isLoading && data.projects.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? _buildEmpty()
                        : RefreshIndicator(
                            onRefresh: data.loadAll,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (ctx, i) => ProjectCard(
                                project: filtered[i],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProjectDetailScreen(project: filtered[i]),
                                  ),
                                ),
                              ),
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Project> _filter(List<Project> projects) {
    return projects.where((p) {
      final matchesSearch = _search.isEmpty ||
          p.name.toLowerCase().contains(_search.toLowerCase()) ||
          p.location.toLowerCase().contains(_search.toLowerCase());
      final matchesStatus = _statusFilter == "all" || p.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        decoration: InputDecoration(
          hintText: "Rechercher un projet...",
          prefixIcon: const Icon(Icons.search, color: AppColors.mutedForeground),
          suffixIcon: _search.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _search = ""))
              : null,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final statuses = ["all", "in_progress", "planned", "delayed", "completed"];
    final labels = {"all": "Tous", ...kProjectStatusLabels};
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        children: statuses.map((s) {
          final selected = _statusFilter == s;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(labels[s] ?? s),
              selected: selected,
              onSelected: (_) => setState(() => _statusFilter = s),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.business_outlined, size: 64, color: AppColors.mutedForeground.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          const Text("Aucun projet trouvé", style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }
}
