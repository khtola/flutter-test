import 'package:first_app/api/api_client.dart';
import 'package:first_app/api/api_endpoints.dart';
import 'package:first_app/models/product.dart';
import 'package:get/get.dart';

class WishlistService {
  WishlistService(this._client);

  final ApiClient _client;
  final items = <Product>[].obs;

  bool contains(String? productId) {
    if (productId == null) {
      return false;
    }
    return items.any((item) => item.id == productId);
  }

  Future<List<Product>> fetchWishlist() async {
    final response = await _client.get(ApiEndpoints.wishlist);
    items.assignAll(_asList(response).map(Product.fromJson));
    return items;
  }

  Future<void> toggle(Product product) async {
    final id = product.id;
    if (id == null) {
      return;
    }
    if (contains(id)) {
      await _client.delete(ApiEndpoints.wishlistItem(id));
    } else {
      await _client.post(ApiEndpoints.wishlist, {'productId': id});
    }
    await fetchWishlist();
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    final raw = response is Map ? response['data'] ?? response['items'] : response;
    if (raw is List) {
      return raw.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    return const [];
  }
}
