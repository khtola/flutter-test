import 'package:flutter/material.dart';

class Product {
  final String? id;
  final String imageUrl;
  final String name;
  final double price;
  final Color color;
  final String discount;
  bool isWishlist;

  Product({
    this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.color,
    required this.discount,
    this.isWishlist = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString(),
      imageUrl: json['imageUrl']?.toString() ??
          json['image']?.toString() ??
          json['thumbnail']?.toString() ??
          '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      price: _toDouble(json['price']),
      color: _parseColor(json['color']),
      discount: json['discount']?.toString() ?? '',
      isWishlist: json['isWishlist'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
      'discount': discount,
      'isWishlist': isWishlist,
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static Color _parseColor(dynamic value) {
    if (value is Color) {
      return value;
    }
    final raw = value?.toString().replaceFirst('#', '');
    if (raw == null || raw.isEmpty) {
      return Colors.grey;
    }
    final hex = raw.length == 6 ? 'FF$raw' : raw;
    final parsed = int.tryParse(hex, radix: 16);
    return parsed == null ? Colors.grey : Color(parsed);
  }
}
