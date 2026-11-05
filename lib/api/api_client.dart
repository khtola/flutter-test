import 'dart:async';
import 'dart:convert';

import 'package:first_app/api/api_config.dart';
import 'package:first_app/api/api_exception.dart';
import 'package:first_app/api/static_api.dart';
import 'package:first_app/storage/local_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    LocalStorage? storage,
    http.Client? httpClient,
    this.baseUrl = ApiConfig.baseUrl,
  })  : _storage = storage,
        _http = httpClient ?? http.Client();

  final String baseUrl;
  final LocalStorage? _storage;
  final http.Client _http;

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? query,
  }) {
    if (ApiConfig.useStaticApi) {
      return StaticApi.handle(
        method: 'GET',
        endpoint: endpoint,
        query: query,
      );
    }
    return _send(
      () => _http.get(_uri(endpoint, query), headers: _headers()),
    );
  }

  Future<dynamic> post(String endpoint, [Map<String, dynamic>? data]) {
    if (ApiConfig.useStaticApi) {
      return StaticApi.handle(
        method: 'POST',
        endpoint: endpoint,
        data: data,
      );
    }
    return _send(
      () => _http.post(
        _uri(endpoint),
        headers: _headers(),
        body: data == null ? null : jsonEncode(data),
      ),
    );
  }

  Future<dynamic> put(String endpoint, [Map<String, dynamic>? data]) {
    if (ApiConfig.useStaticApi) {
      return StaticApi.handle(
        method: 'PUT',
        endpoint: endpoint,
        data: data,
      );
    }
    return _send(
      () => _http.put(
        _uri(endpoint),
        headers: _headers(),
        body: data == null ? null : jsonEncode(data),
      ),
    );
  }

  Future<dynamic> delete(String endpoint) {
    if (ApiConfig.useStaticApi) {
      return StaticApi.handle(method: 'DELETE', endpoint: endpoint);
    }
    return _send(
      () => _http.delete(_uri(endpoint), headers: _headers()),
    );
  }

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(ApiConfig.timeout);
      return _decode(response);
    } on TimeoutException {
      throw const ApiException(message: 'Request timed out');
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(message: error.toString());
    }
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException.fromStatusCode(response.statusCode, response.body);
    }
    if (response.body.isEmpty) {
      return null;
    }
    return jsonDecode(response.body);
  }

  Map<String, String> _headers() {
    final token = _storage?.token;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String endpoint, [Map<String, String>? query]) {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$base$path').replace(queryParameters: query);
  }
}
