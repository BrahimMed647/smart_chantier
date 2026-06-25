import "package:flutter/material.dart";
import "../models/user.dart";
import "../services/api_service.dart";
import "../services/storage_service.dart";

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  AppUser? _user;
  String? _error;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Called once when the app starts.
  // If the user was already logged in, we restore their session.
  Future<void> initialize() async {
    final savedUser = await StorageService.getUser();
    final token = await StorageService.getAccessToken();

    if (savedUser != null && token != null) {
      _user = savedUser;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
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
    } catch (e) {
      _error = "Impossible de se connecter. Verifiez votre email et mot de passe.";
      _status = AuthStatus.unauthenticated;
      notifyListeners();
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
