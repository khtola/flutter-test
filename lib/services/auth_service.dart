import 'package:first_app/api/api_client.dart';
import 'package:first_app/api/api_endpoints.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/storage/local_storage.dart';

class AuthService {
  AuthService(this._client, this._storage);

  final ApiClient _client;
  final LocalStorage _storage;

  Future<User> login(String username, String password) async {
    final response = await _client.post(ApiEndpoints.login, {
      'username': username,
      'password': password,
    });
    final data = _asMap(response);
    final user = User.fromJson(data);
    final token = user.token;

    if (token != null && token.isNotEmpty) {
      await _storage.saveToken(token);
    }
    await _storage.saveUser(user.toJson());
    return user;
  }

  Future<void> logout() async {
    try {
      await _client.post(ApiEndpoints.logout);
    } finally {
      await _storage.clearSession();
    }
  }

  bool get isLoggedIn => _storage.isLoggedIn;

  Map<String, dynamic> _asMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response;
    }
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return <String, dynamic>{};
  }
}
