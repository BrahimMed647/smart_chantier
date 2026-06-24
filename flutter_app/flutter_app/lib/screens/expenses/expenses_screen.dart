import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "../../core/constants.dart";
import "../../core/theme.dart";
import "../../models/expense.dart";
import "../../providers/data_provider.dart";
import "../../widgets/app_progress_bar.dart";

class ExpensesScreen extends StatelessWidget {
  final int? projectId;
  const ExpensesScreen({super.key, this.projectId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, data, _) {
        final expenses = projectId != null
            ? data.expensesForProject(projectId!)
            : data.expenses;
        final project = projectId != null && data.projects.isNotEmpty
            ? data.projects.firstWhere((p) => p.id == projectId,
                orElse: () => data.projects.first)
            : null;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar:
              projectId == null ? AppBar(title: const Text("Dépenses")) : null,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddExpense(context, data),
            backgroundColor: AppColors.accent,
            child: const Icon(Icons.add),
          ),
          body: CustomScrollView(
            slivers: [
              if (project != null)
                SliverToBoxAdapter(
                    child:
                        _buildBudgetSummary(project.initialBudget, expenses)),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: expenses.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text("Aucune dépense",
                              style: TextStyle(color: AppColors.textSecondary)),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _ExpenseCard(expense: expenses[i]),
                          ),
                          childCount: expenses.length,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBudgetSummary(double budget, List<Expense> expenses) {
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final pct = budget > 0 ? total / budget : 0.0;
    final fmt = NumberFormat("#,##0", "fr_FR");
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Résumé budgétaire",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          AppProgressBar(
            value: pct.clamp(0.0, 1.0),
            label: "${(pct * 100).toStringAsFixed(0)}% utilisé",
            color: pct > 0.9 ? AppColors.danger : AppColors.accent,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _budgetCell(
                  "Budget", "${fmt.format(budget)} DA", AppColors.primary),
              _budgetCell(
                  "Dépensé", "${fmt.format(total)} DA", AppColors.danger),
              _budgetCell("Restant", "${fmt.format(budget - total)} DA",
                  AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _budgetCell(String label, String value, Color color) {
    return Column(
      children: [
        Text(label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w700, fontSize: 12)),
      ],
    );
  }

  void _showAddExpense(BuildContext context, DataProvider data) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    int? selProject = projectId;
    String category = "materials";
    DateTime date = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModal) {
          return Container(
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
            decoration: const BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nouvelle dépense",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  if (projectId == null)
                    DropdownButtonFormField<int>(
                      initialValue: selProject,
                      decoration: const InputDecoration(labelText: "Projet"),
                      items: data.projects
                          .map((p) => DropdownMenuItem(
                              value: p.id, child: Text(p.name)))
                          .toList(),
                      onChanged: (v) => setModal(() => selProject = v),
                      validator: (v) => v == null ? "Requis" : null,
                    ),
                  if (projectId == null) const SizedBox(height: 12),
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: "Intitulé *"),
                    validator: (v) => v!.isEmpty ? "Requis" : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: amountCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: "Montant (DA) *"),
                          validator: (v) => v!.isEmpty ? "Requis" : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration:
                              const InputDecoration(labelText: "Catégorie"),
                          items: kExpenseCategoryLabels.entries
                              .map((e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.value,
                                      overflow: TextOverflow.ellipsis)))
                              .toList(),
                          onChanged: (v) => setModal(() => category = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      await data.addExpense({
                        "project": selProject ?? projectId,
                        "title": titleCtrl.text,
                        "amount": double.tryParse(amountCtrl.text) ?? 0,
                        "category": category,
                        "expense_date":
                            "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}",
                      });
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: const Text("Enregistrer"),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final Expense expense;
  const _ExpenseCard({required this.expense});

  static const Map<String, IconData> _catIcons = {
    "materials": Icons.inventory_2_outlined,
    "labor": Icons.people_outline,
    "transport": Icons.local_shipping_outlined,
    "equipment": Icons.construction,
    "subcontractor": Icons.handshake_outlined,
    "administrative": Icons.folder_outlined,
    "other": Icons.more_horiz,
  };

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,##0", "fr_FR");
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_catIcons[expense.category] ?? Icons.receipt,
              color: AppColors.primary, size: 20),
        ),
        title: Text(expense.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          "${kExpenseCategoryLabels[expense.category] ?? expense.category} • ${expense.expenseDate}",
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        trailing: Text(
          "${fmt.format(expense.amount)} DA",
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.danger,
              fontSize: 14),
        ),
      ),
    );
  }
}
