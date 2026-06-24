import "package:flutter/material.dart";
import "../models/user.dart";
import "../services/api_service.dart";
import "../services/storage_service.dart";

// Admin par défaut — affiché immédiatement même si le backend est hors ligne
const _kDefaultAdmin = AppUser(
  id: 1,
  email: "admin@smartms.com",
  name: "Administrateur",
  role: "admin",
  organizationName: "Smart Chantier Corp",
);

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  AppUser? _user;
  String? _error;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> initialize() async {
    // 1. Token déjà stocké → utilisateur connecté
    final savedUser = await StorageService.getUser();
    final token = await StorageService.getAccessToken();
    if (savedUser != null && token != null) {
      _user = savedUser;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return;
    }

    // 2. Tentative auto-login
    final ok = await login("admin@smartms.com", "admin12345");
    if (ok) return;

    // 3. Serveur indisponible → on entre quand même en tant qu'admin par défaut
    _user = _kDefaultAdmin;
    _status = AuthStatus.authenticated;
    notifyListeners();
    // Retry en arrière-plan toutes les 5s jusqu'à connexion réelle
    _retryLoginInBackground();
  }

  void _retryLoginInBackground() {
    Future.delayed(const Duration(seconds: 5), () async {
      if (_user == _kDefaultAdmin) {
        final ok = await login("admin@smartms.com", "admin12345");
        if (!ok) _retryLoginInBackground();
      }
    });
  }

  Future<bool> login(String email, String password) async {
    _error = null;
    try {
      final data = await ApiService.login(email, password);
      final accessToken = data["access"] as String;
      final refreshToken = data["refresh"] as String;
      final userData = data["user"] as Map<String, dynamic>;
      final user = AppUser.fromJson(userData);

      await StorageService.saveTokens(accessToken, refreshToken);
      await StorageService.saveUser(user);

      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    await StorageService.clear();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
