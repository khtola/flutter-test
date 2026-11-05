import 'package:first_app/api/api_config.dart';
import 'package:first_app/api/api_exception.dart';

/// In-memory API used while [ApiConfig.useStaticApi] is true.
/// Swap to a live backend by setting `useStaticApi = false` and updating [ApiConfig.baseUrl].
class StaticApi {
  StaticApi._();

  static Map<String, dynamic> profile = {
    'id': 'u1',
    'username': 'demo',
    'name': 'Demo User',
    'phone': '+855 12 345 678',
    'address': {
      'label': 'Home',
      'street': 'Street 271, Toul Kork',
      'city': 'Phnom Penh',
      'phone': '+855 12 345 678',
      'note': 'Call on arrival',
    },
  };

  static final List<Map<String, dynamic>> banners = [
    {
      'id': 'b1',
      'title': 'Free delivery today',
      'subtitle': 'On grocery orders over \$15',
      'imageUrl':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'id': 'b2',
      'title': 'Lunch in 25 minutes',
      'subtitle': 'Hot meals from nearby kitchens',
      'imageUrl':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'id': 'b3',
      'title': 'Tech deals',
      'subtitle': 'Up to 30% off electronics',
      'imageUrl':
          'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=1200&q=80',
    },
  ];

  static const List<Map<String, dynamic>> categories = [
    {'id': 'all', 'name': 'All', 'icon': 'apps'},
    {'id': 'grocery', 'name': 'Grocery', 'icon': 'local_grocery_store'},
    {'id': 'food', 'name': 'Food', 'icon': 'fastfood'},
    {'id': 'drinks', 'name': 'Drinks', 'icon': 'local_cafe'},
    {'id': 'electronics', 'name': 'Electronics', 'icon': 'devices'},
    {'id': 'fashion', 'name': 'Fashion', 'icon': 'checkroom'},
  ];

  static final List<Map<String, dynamic>> products = [
    _product(
      id: 'p1',
      name: 'Fresh Avocado',
      price: 3.5,
      originalPrice: 4.2,
      discount: '16% OFF',
      categoryId: 'grocery',
      category: 'Grocery',
      color: '#4CAF50',
      deliveryMinutes: 25,
      rating: 4.7,
      stock: 40,
      size: '1 pack',
      description: 'Ripe Hass avocados, packed fresh for same-day delivery.',
      image:
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p2',
      name: 'Organic Bananas',
      price: 2.2,
      originalPrice: 2.8,
      discount: '20% OFF',
      categoryId: 'grocery',
      category: 'Grocery',
      color: '#FBC02D',
      deliveryMinutes: 25,
      rating: 4.6,
      stock: 80,
      size: '1 kg',
      description: 'Sweet organic bananas, delivered chilled from the market.',
      image:
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p3',
      name: 'Instant Noodles Pack',
      price: 4.9,
      discount: '',
      categoryId: 'grocery',
      category: 'Grocery',
      color: '#FF7043',
      deliveryMinutes: 20,
      rating: 4.4,
      stock: 100,
      size: '5 pcs',
      description: 'Quick lunch pack with five savory noodle cups.',
      image:
          'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p4',
      name: 'Pepperoni Pizza',
      price: 8.9,
      originalPrice: 11.5,
      discount: '22% OFF',
      categoryId: 'food',
      category: 'Food',
      color: '#E53935',
      deliveryMinutes: 30,
      rating: 4.8,
      stock: 18,
      size: '12 inch',
      description: 'Wood-fired pepperoni pizza, boxed hot for delivery.',
      image:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p5',
      name: 'Cheeseburger Combo',
      price: 6.5,
      discount: '',
      categoryId: 'food',
      category: 'Food',
      color: '#8D6E63',
      deliveryMinutes: 28,
      rating: 4.5,
      stock: 24,
      size: 'Combo',
      description: 'Beef cheeseburger with fries. Ready in under 30 minutes.',
      image:
          'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p6',
      name: 'Chocolate Cake Slice',
      price: 3.8,
      discount: '',
      categoryId: 'food',
      category: 'Food',
      color: '#5D4037',
      deliveryMinutes: 35,
      rating: 4.9,
      stock: 12,
      size: '1 slice',
      description: 'Rich chocolate cake, packed for dessert delivery.',
      image:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p7',
      name: 'Iced Coffee',
      price: 2.5,
      discount: '',
      categoryId: 'drinks',
      category: 'Drinks',
      color: '#6D4C41',
      deliveryMinutes: 20,
      rating: 4.6,
      stock: 50,
      size: '16 oz',
      description: 'Cold brew with milk. Kept cold until drop-off.',
      image:
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p8',
      name: 'Fresh Orange Juice',
      price: 3.2,
      originalPrice: 3.9,
      discount: '18% OFF',
      categoryId: 'drinks',
      category: 'Drinks',
      color: '#FB8C00',
      deliveryMinutes: 20,
      rating: 4.7,
      stock: 36,
      size: '500 ml',
      description: 'Freshly squeezed orange juice, no added sugar.',
      image:
          'https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p9',
      name: 'Wireless Earbuds',
      price: 29.9,
      originalPrice: 39.9,
      discount: '25% OFF',
      categoryId: 'electronics',
      category: 'Electronics',
      color: '#1565C0',
      deliveryMinutes: 90,
      rating: 4.4,
      stock: 15,
      size: 'One size',
      description: 'Bluetooth 5.3 earbuds with charging case. 1-day delivery.',
      image:
          'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p10',
      name: 'Smart Watch',
      price: 59.0,
      originalPrice: 79.0,
      discount: '25% OFF',
      categoryId: 'electronics',
      category: 'Electronics',
      color: '#263238',
      deliveryMinutes: 90,
      rating: 4.3,
      stock: 8,
      size: '42 mm',
      description: 'Fitness tracking, heart rate, and message alerts.',
      image:
          'https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p11',
      name: 'Cotton T-Shirt',
      price: 12.0,
      discount: '',
      categoryId: 'fashion',
      category: 'Fashion',
      color: '#1E88E5',
      deliveryMinutes: 60,
      rating: 4.5,
      stock: 22,
      size: 'M',
      description: 'Soft cotton tee. Casual everyday wear.',
      image:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=800&q=80',
    ),
    _product(
      id: 'p12',
      name: 'Running Shoes',
      price: 45.0,
      originalPrice: 59.0,
      discount: '24% OFF',
      categoryId: 'fashion',
      category: 'Fashion',
      color: '#43A047',
      deliveryMinutes: 70,
      rating: 4.6,
      stock: 10,
      size: '42',
      description: 'Lightweight running shoes with cushioned sole.',
      image:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  static final List<Map<String, dynamic>> cart = [];

  static final List<String> wishlistIds = ['p4', 'p11'];

  static final List<Map<String, dynamic>> notifications = [
    {
      'id': 'n1',
      'title': 'Order on the way',
      'name': 'Your pepperoni pizza is 18 minutes away.',
      'type': 'delivery',
    },
    {
      'id': 'n2',
      'title': 'Grocery promo',
      'name': 'Free delivery on grocery orders over \$15 today.',
      'type': 'promo',
    },
    {
      'id': 'n3',
      'title': 'Wishlist restock',
      'name': 'Cotton T-Shirt is back in stock. Order before tonight.',
      'type': 'stock',
    },
  ];

  static final List<Map<String, dynamic>> orders = [
    {
      'id': 'ord-1001',
      'status': 'on_the_way',
      'paymentMethod': 'Cash on Delivery',
      'subtotal': 8.9,
      'deliveryFee': 1.5,
      'total': 10.4,
      'createdAt': DateTime.now().subtract(const Duration(minutes: 25)).toIso8601String(),
      'address': profile['address'],
      'items': [
        {
          ...products.firstWhere((item) => item['id'] == 'p4'),
          'quantity': 1,
        },
      ],
      'delivery': {
        'riderName': 'Sokha Meas',
        'riderPhone': '+855 11 222 333',
        'vehicle': 'Motorbike',
        'etaMinutes': 18,
        'status': 'on_the_way',
        'steps': [
          {'title': 'Order placed', 'time': '10:02', 'done': true},
          {'title': 'Preparing', 'time': '10:08', 'done': true},
          {'title': 'On the way', 'time': '10:20', 'done': true},
          {'title': 'Delivered', 'time': null, 'done': false},
        ],
      },
    },
    {
      'id': 'ord-1000',
      'status': 'delivered',
      'paymentMethod': 'ABA KHQR',
      'subtotal': 5.7,
      'deliveryFee': 1.5,
      'total': 7.2,
      'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'address': profile['address'],
      'items': [
        {
          ...products.firstWhere((item) => item['id'] == 'p1'),
          'quantity': 1,
        },
        {
          ...products.firstWhere((item) => item['id'] == 'p7'),
          'quantity': 1,
        },
      ],
      'delivery': {
        'riderName': 'Dara Kim',
        'riderPhone': '+855 10 555 121',
        'vehicle': 'Motorbike',
        'etaMinutes': 0,
        'status': 'delivered',
        'steps': [
          {'title': 'Order placed', 'time': '18:10', 'done': true},
          {'title': 'Preparing', 'time': '18:16', 'done': true},
          {'title': 'On the way', 'time': '18:28', 'done': true},
          {'title': 'Delivered', 'time': '18:47', 'done': true},
        ],
      },
    },
  ];

  static Future<dynamic> handle({
    required String method,
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, String>? query,
  }) async {
    await Future<void>.delayed(ApiConfig.staticDelay);

    final path = endpoint.split('?').first;
    final verb = method.toUpperCase();

    if (verb == 'POST' && path == '/login') {
      final username = data?['username']?.toString().trim() ?? '';
      final password = data?['password']?.toString() ?? '';
      if (username.isEmpty || password.isEmpty) {
        throw const ApiException(
          statusCode: 400,
          message: 'Username and password required',
        );
      }
      final usernameOk =
          username.toLowerCase() == ApiConfig.demoUsername.toLowerCase();
      final passwordOk = password == ApiConfig.demoPassword;
      if (!usernameOk || !passwordOk) {
        throw const ApiException(
          statusCode: 401,
          message: 'Incorrect username or password',
        );
      }
      return {
        'token': 'static-token-demo',
        'user': {
          ...profile,
          'username': username,
        },
      };
    }

    if (verb == 'POST' && path == '/logout') {
      return {'ok': true};
    }

    if (verb == 'GET' && path == '/profile') {
      return {'data': profile};
    }

    if (verb == 'PUT' && path == '/profile') {
      profile = {
        ...profile,
        ...?data,
      };
      return {'data': profile};
    }

    if (verb == 'GET' && path == '/banners') {
      return {'data': banners};
    }

    if (verb == 'GET' && path == '/categories') {
      return {'data': categories};
    }

    if (verb == 'GET' && path == '/products') {
      final categoryId = query?['categoryId'];
      final search = query?['q']?.toLowerCase();
      var list = List<Map<String, dynamic>>.from(products);
      if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
        list = list.where((item) => item['categoryId'] == categoryId).toList();
      }
      if (search != null && search.isNotEmpty) {
        list = list
            .where((item) => item['name'].toString().toLowerCase().contains(search))
            .toList();
      }
      return {
        'data': list.map(_withWishlistFlag).toList(),
      };
    }

    final productMatch = RegExp(r'^/products/([^/]+)$').firstMatch(path);
    if (verb == 'GET' && productMatch != null) {
      final id = productMatch.group(1);
      final product = products.cast<Map<String, dynamic>?>().firstWhere(
            (item) => item?['id'] == id,
            orElse: () => null,
          );
      if (product == null) {
        throw const ApiException(statusCode: 404, message: 'Product not found');
      }
      return _withWishlistFlag(product);
    }

    if (verb == 'GET' && path == '/cart') {
      return {'data': List<Map<String, dynamic>>.from(cart)};
    }

    if (verb == 'POST' && path == '/cart') {
      final productId = data?['productId']?.toString();
      final quantity = _toInt(data?['quantity'] ?? 1);
      final product = _findProduct(productId);
      if (product == null) {
        throw const ApiException(statusCode: 404, message: 'Product not found');
      }
      final index = cart.indexWhere((item) => item['id'] == productId);
      if (index >= 0) {
        final current = _toInt(cart[index]['quantity']);
        cart[index] = {
          ...cart[index],
          'quantity': current + quantity,
        };
      } else {
        cart.add({
          ...product,
          'quantity': quantity,
        });
      }
      return {'data': List<Map<String, dynamic>>.from(cart)};
    }

    final cartMatch = RegExp(r'^/cart/([^/]+)$').firstMatch(path);
    if (cartMatch != null) {
      final id = cartMatch.group(1);
      final index = cart.indexWhere((item) => item['id'] == id);
      if (index < 0) {
        throw const ApiException(statusCode: 404, message: 'Cart item not found');
      }
      if (verb == 'PUT') {
        cart[index] = {
          ...cart[index],
          'quantity': _toInt(data?['quantity'] ?? cart[index]['quantity']),
        };
      } else if (verb == 'DELETE') {
        cart.removeAt(index);
      }
      return {'data': List<Map<String, dynamic>>.from(cart)};
    }

    if (verb == 'GET' && path == '/wishlist') {
      final list = products
          .where((item) => wishlistIds.contains(item['id']))
          .map(_withWishlistFlag)
          .toList();
      return {'data': list};
    }

    if (verb == 'POST' && path == '/wishlist') {
      final productId = data?['productId']?.toString();
      if (productId != null && !wishlistIds.contains(productId)) {
        wishlistIds.add(productId);
      }
      return {'ok': true};
    }

    final wishlistMatch = RegExp(r'^/wishlist/([^/]+)$').firstMatch(path);
    if (verb == 'DELETE' && wishlistMatch != null) {
      wishlistIds.remove(wishlistMatch.group(1));
      return {'ok': true};
    }

    if (verb == 'GET' && path == '/notifications') {
      return {'data': notifications};
    }

    if (verb == 'GET' && path == '/orders') {
      return {'data': List<Map<String, dynamic>>.from(orders)};
    }

    final orderMatch = RegExp(r'^/orders/([^/]+)$').firstMatch(path);
    if (verb == 'GET' && orderMatch != null) {
      final id = orderMatch.group(1);
      final order = orders.cast<Map<String, dynamic>?>().firstWhere(
            (item) => item?['id'] == id,
            orElse: () => null,
          );
      if (order == null) {
        throw const ApiException(statusCode: 404, message: 'Order not found');
      }
      return order;
    }

    if (verb == 'POST' && path == '/orders') {
      final items = (data?['items'] as List?)
              ?.whereType<Map>()
              .map(Map<String, dynamic>.from)
              .toList() ??
          const <Map<String, dynamic>>[];
      final total = _toDouble(data?['total']);
      final deliveryFee = _toDouble(data?['deliveryFee'] ?? 1.5);
      final now = DateTime.now();
      final order = {
        'id': 'ord-${now.millisecondsSinceEpoch}',
        'status': 'preparing',
        'paymentMethod': data?['paymentMethod'] ?? 'Cash on Delivery',
        'subtotal': _toDouble(data?['subtotal'] ?? total - deliveryFee),
        'deliveryFee': deliveryFee,
        'total': total,
        'createdAt': now.toIso8601String(),
        'address': data?['address'] ?? profile['address'],
        'items': items,
        'delivery': {
          'riderName': 'Vannak Sok',
          'riderPhone': '+855 12 888 999',
          'vehicle': 'Motorbike',
          'etaMinutes': 32,
          'status': 'preparing',
          'steps': [
            {
              'title': 'Order placed',
              'time': _hhmm(now),
              'done': true,
            },
            {
              'title': 'Preparing',
              'time': _hhmm(now.add(const Duration(minutes: 1))),
              'done': true,
            },
            {'title': 'On the way', 'time': null, 'done': false},
            {'title': 'Delivered', 'time': null, 'done': false},
          ],
        },
      };
      orders.insert(0, order);
      cart.clear();
      notifications.insert(0, {
        'id': 'n-${now.millisecondsSinceEpoch}',
        'title': 'Order confirmed',
        'name': 'We are preparing your order ${order['id']}.',
        'type': 'delivery',
      });
      return order;
    }

    throw ApiException(statusCode: 404, message: 'No static route for $verb $path');
  }

  static Map<String, dynamic> _product({
    required String id,
    required String name,
    required double price,
    double? originalPrice,
    required String discount,
    required String categoryId,
    required String category,
    required String color,
    required int deliveryMinutes,
    required double rating,
    required int stock,
    required String size,
    required String description,
    required String image,
  }) {
    return {
      'id': id,
      'name': name,
      'price': price,
      if (originalPrice != null) 'originalPrice': originalPrice,
      'discount': discount,
      'categoryId': categoryId,
      'category': category,
      'color': color,
      'deliveryMinutes': deliveryMinutes,
      'rating': rating,
      'stock': stock,
      'size': size,
      'description': description,
      'imageUrl': image,
      'images': [image],
      'quantity': 1,
      'isWishlist': false,
    };
  }

  static Map<String, dynamic> _withWishlistFlag(Map<String, dynamic> product) {
    return {
      ...product,
      'isWishlist': wishlistIds.contains(product['id']),
    };
  }

  static Map<String, dynamic>? _findProduct(String? id) {
    if (id == null) {
      return null;
    }
    for (final item in products) {
      if (item['id'] == id) {
        return Map<String, dynamic>.from(item);
      }
    }
    return null;
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

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _hhmm(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
