import 'package:first_app/api/api_client.dart';
import 'package:first_app/api/api_endpoints.dart';
import 'package:first_app/models/product.dart';

class ProductService {
  ProductService(this._client);

  final ApiClient _client;

  Future<List<Product>> fetchProducts() async {
    final response = await _client.get(ApiEndpoints.products);
    return _asList(response).map(Product.fromJson).toList();
  }

  Future<Product> fetchProduct(String id) async {
    final response = await _client.get(ApiEndpoints.product(id));
    return Product.fromJson(_asMap(response));
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    final raw = response is Map ? response['data'] ?? response['products'] : response;
    if (raw is List) {
      return raw.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    return const [];
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
