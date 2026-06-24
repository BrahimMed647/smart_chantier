import "dart:convert";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "../models/user.dart";

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _userKey = "current_user";

  static Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  static Future<String?> getAccessToken() => _storage.read(key: _accessKey);
  static Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);

  static Future<void> saveUser(AppUser user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  static Future<AppUser?> getUser() async {
    final data = await _storage.read(key: _userKey);
    if (data == null) return null;
    return AppUser.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
