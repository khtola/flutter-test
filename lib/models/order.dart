import 'package:first_app/models/address.dart';
import 'package:first_app/models/delivery.dart';
import 'package:first_app/models/product.dart';

class Order {
  final String id;
  final String status;
  final String paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime createdAt;
  final Address address;
  final List<Product> items;
  final Delivery? delivery;

  const Order({
    required this.id,
    required this.status,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    required this.address,
    required this.items,
    this.delivery,
  });

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'on_the_way':
        return 'On the way';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final rawAddress = json['address'];
    final rawDelivery = json['delivery'];
    return Order(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      subtotal: _toDouble(json['subtotal']),
      deliveryFee: _toDouble(json['deliveryFee']),
      total: _toDouble(json['total']),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      address: rawAddress is Map
          ? Address.fromJson(Map<String, dynamic>.from(rawAddress))
          : const Address(
              label: 'Home',
              street: '',
              city: '',
              phone: '',
            ),
      items: rawItems is List
          ? rawItems
              .whereType<Map>()
              .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      delivery: rawDelivery is Map
          ? Delivery.fromJson(Map<String, dynamic>.from(rawDelivery))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'address': address.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      if (delivery != null) 'delivery': delivery!.toJson(),
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
