import "package:dio/dio.dart";
import "../core/constants.dart";
import "storage_service.dart";

class ApiService {
  static final Dio _dio = _buildDio();

  static Dio _buildDio() {
    final dio = Dio(BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {"Content-Type": "application/json"},
    ));

    // Auth interceptor — attach JWT + refresh on 401
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshTokens();
            if (refreshed) {
              final token = await StorageService.getAccessToken();
              final opts = error.requestOptions;
              opts.headers["Authorization"] = "Bearer $token";
              try {
                final response = await dio.fetch(opts);
                handler.resolve(response);
                return;
              } catch (_) {}
            }
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  static Future<bool> _refreshTokens() async {
    final refresh = await StorageService.getRefreshToken();
    if (refresh == null) return false;
    try {
      final resp = await Dio().post(
        "$kBaseUrl/auth/refresh/",
        data: {"refresh": refresh},
      );
      final access = resp.data["access"] as String;
      await StorageService.saveTokens(access, refresh);
      return true;
    } catch (_) {
      return false;
    }
  }

  // AUTH
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await _dio.post("/auth/login/", data: {"email": email, "password": password});
    return resp.data as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getMe() async {
    final resp = await _dio.get("/auth/me/");
    return resp.data as Map<String, dynamic>;
  }

  // DASHBOARD
  static Future<Map<String, dynamic>> getDashboard() async {
    final resp = await _dio.get("/dashboard/");
    return resp.data as Map<String, dynamic>;
  }

  // PROJECTS
  static Future<List<dynamic>> getProjects({String? status}) async {
    final resp = await _dio.get("/projects/", queryParameters: status != null ? {"status": status} : null);
    return resp.data as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getProject(int id) async {
    final resp = await _dio.get("/projects/$id/");
    return resp.data as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> createProject(Map<String, dynamic> data) async {
    final resp = await _dio.post("/projects/", data: data);
    return resp.data as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateProject(int id, Map<String, dynamic> data) async {
    final resp = await _dio.patch("/projects/$id/", data: data);
    return resp.data as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getProjectBudget(int projectId) async {
    final resp = await _dio.get("/projects/$projectId/budget/");
    return resp.data as Map<String, dynamic>;
  }

  // TASKS
  static Future<List<dynamic>> getTasks({int? projectId, String? status}) async {
    final params = <String, dynamic>{};
    if (projectId != null) params["project"] = projectId;
    if (status != null) params["status"] = status;
    final resp = await _dio.get("/tasks/", queryParameters: params.isNotEmpty ? params : null);
    return resp.data as List<dynamic>;
  }

  static Future<Map<String, dynamic>> updateTask(int id, Map<String, dynamic> data) async {
    final resp = await _dio.patch("/tasks/$id/", data: data);
    return resp.data as Map<String, dynamic>;
  }

  // REPORTS
  static Future<List<dynamic>> getReports({int? projectId}) async {
    final resp = await _dio.get(
      "/reports/",
      queryParameters: projectId != null ? {"project": projectId} : null,
    );
    return resp.data as List<dynamic>;
  }

  static Future<Map<String, dynamic>> createReport(Map<String, dynamic> data) async {
    final resp = await _dio.post("/reports/", data: data);
    return resp.data as Map<String, dynamic>;
  }

  // EXPENSES
  static Future<List<dynamic>> getExpenses({int? projectId}) async {
    final resp = await _dio.get(
      "/expenses/",
      queryParameters: projectId != null ? {"project": projectId} : null,
    );
    return resp.data as List<dynamic>;
  }

  static Future<Map<String, dynamic>> createExpense(Map<String, dynamic> data) async {
    final resp = await _dio.post("/expenses/", data: data);
    return resp.data as Map<String, dynamic>;
  }

  // ALERTS
  static Future<List<dynamic>> getAlerts({int? projectId, String? status}) async {
    final params = <String, dynamic>{};
    if (projectId != null) params["project"] = projectId;
    if (status != null) params["status"] = status;
    final resp = await _dio.get("/alerts/", queryParameters: params.isNotEmpty ? params : null);
    return resp.data as List<dynamic>;
  }

  static Future<Map<String, dynamic>> resolveAlert(int id) async {
    final resp = await _dio.patch("/alerts/$id/resolve/");
    return resp.data as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> markAlertRead(int id) async {
    final resp = await _dio.patch("/alerts/$id/read/");
    return resp.data as Map<String, dynamic>;
  }

  // PHOTOS
  static Future<List<dynamic>> getPhotos({int? projectId}) async {
    final resp = await _dio.get(
      "/photos/",
      queryParameters: projectId != null ? {"project": projectId} : null,
    );
    return resp.data as List<dynamic>;
  }

  static Future<Map<String, dynamic>> uploadPhoto(int projectId, String filePath, String photoType) async {
    final formData = FormData.fromMap({
      "project": projectId,
      "photo_type": photoType,
      "taken_at": DateTime.now().toIso8601String(),
      "image": await MultipartFile.fromFile(filePath),
    });
    final resp = await _dio.post("/photos/", data: formData);
    return resp.data as Map<String, dynamic>;
  }
}
