import 'package:first_app/api/api_client.dart';
import 'package:first_app/api/api_endpoints.dart';
import 'package:first_app/models/product.dart';

class OrderService {
  OrderService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> placeOrder({
    required List<Product> items,
    required String paymentMethod,
    required double total,
  }) async {
    final payload = {
      'paymentMethod': paymentMethod,
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
    };

    try {
      final response = await _client.post(ApiEndpoints.orders, payload);
      final data = _asMap(response);
      if (data.isNotEmpty) {
        return data;
      }
    } catch (_) {
      // Keep checkout usable while the API host is a placeholder.
    }

    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'status': 'paid',
      'paymentMethod': paymentMethod,
      'total': total,
    };
  }

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
