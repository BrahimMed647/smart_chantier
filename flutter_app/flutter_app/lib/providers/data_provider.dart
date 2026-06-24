import "package:flutter/material.dart";
import "../core/default_data.dart";
import "../models/alert.dart";
import "../models/daily_report.dart";
import "../models/expense.dart";
import "../models/project.dart";
import "../models/site_photo.dart";
import "../models/task.dart";
import "../services/api_service.dart";

class DataProvider extends ChangeNotifier {
  List<Project>    _projects  = List.of(kDefaultProjects);
  List<Task>       _tasks     = List.of(kDefaultTasks);
  List<DailyReport>_reports   = List.of(kDefaultReports);
  List<Expense>    _expenses  = List.of(kDefaultExpenses);
  List<Alert>      _alerts    = List.of(kDefaultAlerts);
  List<SitePhoto>  _photos    = [];
  Map<String, dynamic> _dashboard = Map.of(kDefaultDashboard);
  bool   _isLoading = false;
  String? _error;

  List<Project>    get projects  => _projects;
  List<Task>       get tasks     => _tasks;
  List<DailyReport>get reports   => _reports;
  List<Expense>    get expenses  => _expenses;
  List<Alert>      get alerts    => _alerts;
  List<SitePhoto>  get photos    => _photos;
  Map<String, dynamic> get dashboard => _dashboard;
  bool   get isLoading => _isLoading;
  String? get error    => _error;

  List<Task>        tasksForProject(int id)   => _tasks.where((t)   => t.project == id).toList();
  List<DailyReport> reportsForProject(int id) => _reports.where((r) => r.project == id).toList();
  List<Expense>     expensesForProject(int id)=> _expenses.where((e) => e.project == id).toList();
  List<Alert>       alertsForProject(int id)  => _alerts.where((a)  => a.project == id).toList();
  List<SitePhoto>   photosForProject(int id)  => _photos.where((p)  => p.project == id).toList();

  int get unreadAlertsCount => _alerts.where((a) => a.isUnread).length;

  // ── Charge depuis le backend ; en cas d'erreur garde les données par défaut
  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await Future.wait([
        _loadDashboard(),
        _loadProjects(),
        _loadTasks(),
        _loadReports(),
        _loadExpenses(),
        _loadAlerts(),
        _loadPhotos(),
      ]);
    } catch (e) {
      // Garde les données par défaut silencieusement
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDashboard() async {
    try {
      _dashboard = await ApiService.getDashboard();
    } catch (_) { /* garde kDefaultDashboard */ }
  }

  Future<void> _loadProjects() async {
    try {
      final data = await ApiService.getProjects();
      if (data.isNotEmpty) {
        _projects = data.map((j) => Project.fromJson(j as Map<String, dynamic>)).toList();
      }
    } catch (_) { /* garde kDefaultProjects */ }
  }

  Future<void> _loadTasks() async {
    try {
      final data = await ApiService.getTasks();
      if (data.isNotEmpty) {
        _tasks = data.map((j) => Task.fromJson(j as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
  }

  Future<void> _loadReports() async {
    try {
      final data = await ApiService.getReports();
      if (data.isNotEmpty) {
        _reports = data.map((j) => DailyReport.fromJson(j as Map<String, dynamic>)).toList();
        _reports.sort((a, b) => b.reportDate.compareTo(a.reportDate));
      }
    } catch (_) {}
  }

  Future<void> _loadExpenses() async {
    try {
      final data = await ApiService.getExpenses();
      if (data.isNotEmpty) {
        _expenses = data.map((j) => Expense.fromJson(j as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
  }

  Future<void> _loadAlerts() async {
    try {
      final data = await ApiService.getAlerts();
      if (data.isNotEmpty) {
        _alerts = data.map((j) => Alert.fromJson(j as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
  }

  Future<void> _loadPhotos() async {
    try {
      final data = await ApiService.getPhotos();
      _photos = data.map((j) => SitePhoto.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {}
  }

  // ── Actions utilisateur ───────────────────────────────────────────────────
  Future<void> resolveAlert(int id) async {
    try { await ApiService.resolveAlert(id); } catch (_) {}
    final idx = _alerts.indexWhere((a) => a.id == id);
    if (idx >= 0) {
      final a = _alerts[idx];
      _alerts[idx] = Alert(
        id: a.id, project: a.project, projectName: a.projectName,
        task: a.task, alertType: a.alertType, level: a.level,
        title: a.title, message: a.message, status: "resolved",
        createdBy: a.createdBy, createdByName: a.createdByName,
        createdAt: a.createdAt, resolvedAt: DateTime.now().toIso8601String(),
      );
      notifyListeners();
    }
  }

  Future<void> addReport(Map<String, dynamic> data) async {
    final json = await ApiService.createReport(data);
    _reports.insert(0, DailyReport.fromJson(json));
    notifyListeners();
  }

  Future<void> addExpense(Map<String, dynamic> data) async {
    final json = await ApiService.createExpense(data);
    _expenses.insert(0, Expense.fromJson(json));
    notifyListeners();
  }

  Future<void> addPhoto(int projectId, String filePath, String type) async {
    final json = await ApiService.uploadPhoto(projectId, filePath, type);
    _photos.insert(0, SitePhoto.fromJson(json));
    notifyListeners();
  }

  Future<void> updateTask(int id, Map<String, dynamic> data) async {
    final json = await ApiService.updateTask(id, data);
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      _tasks[idx] = Task.fromJson(json);
      notifyListeners();
    }
  }
}
