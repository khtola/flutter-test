import 'package:first_app/api/api_client.dart';
import 'package:first_app/api/api_endpoints.dart';
import 'package:first_app/models/address.dart';
import 'package:first_app/models/order.dart';
import 'package:first_app/models/product.dart';
import 'package:get/get.dart';

class OrderService {
  OrderService(this._client);

  final ApiClient _client;
  final orders = <Order>[].obs;

  Future<List<Order>> fetchOrders() async {
    final response = await _client.get(ApiEndpoints.orders);
    orders.assignAll(_asList(response).map(Order.fromJson));
    return orders;
  }

  Future<Order> fetchOrder(String id) async {
    final response = await _client.get(ApiEndpoints.order(id));
    return Order.fromJson(_asMap(response));
  }

  Future<Order> placeOrder({
    required List<Product> items,
    required String paymentMethod,
    required double total,
    double? subtotal,
    double deliveryFee = 1.5,
    Address? address,
  }) async {
    final payload = {
      'paymentMethod': paymentMethod,
      'total': total,
      'subtotal': subtotal ?? (total - deliveryFee),
      'deliveryFee': deliveryFee,
      'items': items.map((item) => item.toJson()).toList(),
      if (address != null) 'address': address.toJson(),
    };

    final response = await _client.post(ApiEndpoints.orders, payload);
    final data = _asMap(response);
    final order = data.isEmpty
        ? Order(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            status: 'preparing',
            paymentMethod: paymentMethod,
            subtotal: subtotal ?? total,
            deliveryFee: deliveryFee,
            total: total,
            createdAt: DateTime.now(),
            address: address ??
                const Address(
                  label: 'Home',
                  street: '',
                  city: '',
                  phone: '',
                ),
            items: items,
          )
        : Order.fromJson(data);
    await fetchOrders();
    return order;
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    final raw = response is Map ? response['data'] ?? response['orders'] : response;
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
