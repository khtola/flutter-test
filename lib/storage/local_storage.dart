import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get token => _prefs?.getString(_tokenKey);

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  Future<void> saveToken(String token) async {
    await _prefs?.setString(_tokenKey, token);
  }

  Map<String, dynamic>? get user {
    final raw = _prefs?.getString(_userKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs?.setString(_userKey, jsonEncode(user));
  }

  Future<void> clearSession() async {
    await _prefs?.remove(_tokenKey);
    await _prefs?.remove(_userKey);
  }
}
