import 'package:first_app/api/api_client.dart';
import 'package:first_app/api/api_endpoints.dart';
import 'package:first_app/models/product.dart';
import 'package:get/get.dart';

class CartService {
  CartService(this._client);

  final ApiClient _client;
  final items = <Product>[].obs;

  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.lineTotal);

  double get deliveryFee {
    if (items.isEmpty) {
      return 0;
    }
    return subtotal >= 15 ? 0 : 1.5;
  }

  double get total => subtotal + deliveryFee;

  Future<List<Product>> fetchCart() async {
    final response = await _client.get(ApiEndpoints.cart);
    items.assignAll(_asList(response).map(Product.fromJson));
    return items;
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    await _client.post(ApiEndpoints.cart, {
      'productId': product.id,
      'quantity': quantity,
    });
    await fetchCart();
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(itemId);
      return;
    }
    await _client.put(ApiEndpoints.cartItem(itemId), {'quantity': quantity});
    await fetchCart();
  }

  Future<void> removeFromCart(String itemId) async {
    await _client.delete(ApiEndpoints.cartItem(itemId));
    await fetchCart();
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    final raw = response is Map ? response['data'] ?? response['items'] : response;
    if (raw is List) {
      return raw.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    return const [];
  }
}
