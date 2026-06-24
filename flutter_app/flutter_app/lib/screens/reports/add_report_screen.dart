import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "../../core/theme.dart";
import "../../providers/data_provider.dart";

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _projectId;
  final _workDoneCtrl = TextEditingController();
  final _workersCtrl = TextEditingController(text: "0");
  final _materialsCtrl = TextEditingController(text: "—");
  final _equipmentCtrl = TextEditingController(text: "—");
  final _problemsCtrl = TextEditingController(text: "Aucun");
  final _solutionsCtrl = TextEditingController(text: "RAS");
  final _weatherCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();
  int _progressToday = 0;
  bool _loading = false;
  DateTime _reportDate = DateTime.now();

  @override
  void dispose() {
    for (final c in [
      _workDoneCtrl,
      _workersCtrl,
      _materialsCtrl,
      _equipmentCtrl,
      _problemsCtrl,
      _solutionsCtrl,
      _weatherCtrl,
      _remarksCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _projectId == null) return;
    setState(() => _loading = true);
    try {
      await context.read<DataProvider>().addReport({
        "project": _projectId,
        "report_date": DateFormat("yyyy-MM-dd").format(_reportDate),
        "work_done": _workDoneCtrl.text,
        "workers_count": int.tryParse(_workersCtrl.text) ?? 0,
        "materials_used": _materialsCtrl.text,
        "equipment_used": _equipmentCtrl.text,
        "problems": _problemsCtrl.text,
        "solutions": _solutionsCtrl.text,
        "weather": _weatherCtrl.text,
        "remarks": _remarksCtrl.text,
        "progress_today": _progressToday,
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Erreur: ${e.toString()}"),
              backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.read<DataProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Nouveau rapport journalier")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: _projectId,
                        decoration:
                            const InputDecoration(labelText: "Projet *"),
                        hint: const Text("Sélectionner un projet"),
                        items: data.projects
                            .map((p) => DropdownMenuItem(
                                value: p.id, child: Text(p.name)))
                            .toList(),
                        onChanged: (v) => setState(() => _projectId = v),
                        validator: (v) => v == null ? "Champ requis" : null,
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Date du rapport"),
                        trailing: TextButton(
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _reportDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (d != null) setState(() => _reportDate = d);
                          },
                          child: Text(
                              DateFormat("dd/MM/yyyy").format(_reportDate)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _workDoneCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            labelText: "Travaux réalisés *"),
                        validator: (v) => v!.isEmpty ? "Champ requis" : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _workersCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: "Nb. ouvriers"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _weatherCtrl,
                              decoration:
                                  const InputDecoration(labelText: "Météo"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: _materialsCtrl,
                          decoration: const InputDecoration(
                              labelText: "Matériaux utilisés")),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: _equipmentCtrl,
                          decoration: const InputDecoration(
                              labelText: "Équipement utilisé")),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _problemsCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                              labelText: "Problèmes rencontrés")),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: _solutionsCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                              labelText: "Solutions apportées")),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: _remarksCtrl,
                          maxLines: 2,
                          decoration:
                              const InputDecoration(labelText: "Remarques")),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text("Avancement du jour: "),
                          Expanded(
                            child: Slider(
                              value: _progressToday.toDouble(),
                              min: 0,
                              max: 20,
                              divisions: 20,
                              label: "$_progressToday%",
                              activeColor: AppColors.primary,
                              onChanged: (v) =>
                                  setState(() => _progressToday = v.round()),
                            ),
                          ),
                          Text("$_progressToday%",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Text("Enregistrer le rapport"),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
