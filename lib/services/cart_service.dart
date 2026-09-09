import 'package:first_app/api/api_client.dart';
import 'package:first_app/api/api_endpoints.dart';
import 'package:first_app/models/product.dart';

class CartService {
  CartService(this._client);

  final ApiClient _client;

  Future<List<Product>> fetchCart() async {
    final response = await _client.get(ApiEndpoints.cart);
    return _asList(response).map(Product.fromJson).toList();
  }

  Future<void> addToCart(String productId, {int quantity = 1}) {
    return _client.post(ApiEndpoints.cart, {
      'productId': productId,
      'quantity': quantity,
    });
  }

  Future<void> removeFromCart(String itemId) {
    return _client.delete(ApiEndpoints.cartItem(itemId));
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    final raw = response is Map ? response['data'] ?? response['items'] : response;
    if (raw is List) {
      return raw.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    return const [];
  }
}
