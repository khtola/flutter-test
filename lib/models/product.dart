import 'package:flutter/material.dart';

class Product {
  final String? id;
  final String imageUrl;
  final List<String> images;
  final String name;
  final double price;
  final double? originalPrice;
  final Color color;
  final String discount;
  bool isWishlist;
  final int quantity;
  final String description;
  final String categoryId;
  final String category;
  final int stock;
  final double rating;
  final String size;
  final int deliveryMinutes;

  Product({
    this.id,
    required this.imageUrl,
    this.images = const [],
    required this.name,
    required this.price,
    this.originalPrice,
    required this.color,
    required this.discount,
    this.isWishlist = false,
    this.quantity = 1,
    this.description = '',
    this.categoryId = '',
    this.category = '',
    this.stock = 10,
    this.rating = 4.5,
    this.size = '',
    this.deliveryMinutes = 30,
  });

  List<String> get gallery {
    if (images.isNotEmpty) {
      return images;
    }
    return imageUrl.isEmpty ? const [] : [imageUrl];
  }

  double get lineTotal => price * quantity;

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    return Product(
      id: json['id']?.toString(),
      imageUrl: json['imageUrl']?.toString() ??
          json['image']?.toString() ??
          json['thumbnail']?.toString() ??
          '',
      images: rawImages is List
          ? rawImages.map((item) => item.toString()).toList()
          : const [],
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      price: _toDouble(json['price']),
      originalPrice: json['originalPrice'] == null
          ? null
          : _toDouble(json['originalPrice']),
      color: _parseColor(json['color']),
      discount: json['discount']?.toString() ?? '',
      isWishlist: json['isWishlist'] == true,
      quantity: _toInt(json['quantity'] ?? json['number'] ?? 1),
      description: json['description']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      stock: _toInt(json['stock'] ?? 10),
      rating: _toDouble(json['rating'] ?? 4.5),
      size: json['size']?.toString() ?? '',
      deliveryMinutes: _toInt(json['deliveryMinutes'] ?? 30),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'imageUrl': imageUrl,
      'images': images,
      'name': name,
      'price': price,
      if (originalPrice != null) 'originalPrice': originalPrice,
      'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
      'discount': discount,
      'isWishlist': isWishlist,
      'quantity': quantity,
      'number': quantity,
      'description': description,
      'categoryId': categoryId,
      'category': category,
      'stock': stock,
      'rating': rating,
      'size': size,
      'deliveryMinutes': deliveryMinutes,
    };
  }

  Product copyWith({
    String? id,
    String? imageUrl,
    List<String>? images,
    String? name,
    double? price,
    double? originalPrice,
    Color? color,
    String? discount,
    bool? isWishlist,
    int? quantity,
    String? description,
    String? categoryId,
    String? category,
    int? stock,
    double? rating,
    String? size,
    int? deliveryMinutes,
  }) {
    return Product(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      name: name ?? this.name,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      color: color ?? this.color,
      discount: discount ?? this.discount,
      isWishlist: isWishlist ?? this.isWishlist,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      size: size ?? this.size,
      deliveryMinutes: deliveryMinutes ?? this.deliveryMinutes,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
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
