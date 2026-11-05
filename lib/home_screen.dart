import 'package:first_app/api/api_config.dart';
import 'package:first_app/components/grid_list.dart';
import 'package:first_app/components/home_slider.dart';
import 'package:first_app/models/banner_item.dart';
import 'package:first_app/models/category.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/notification_screen.dart';
import 'package:first_app/product_detail_screen.dart';
import 'package:first_app/services/auth_service.dart';
import 'package:first_app/services/cart_service.dart';
import 'package:first_app/services/product_service.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _productService = Get.find<ProductService>();
  final _cartService = Get.find<CartService>();

  List<BannerItem> _banners = const [];
  List<Category> _categories = const [];
  List<Product> _products = const [];
  String _selectedCategory = 'all';
  bool _loading = true;
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
      // if (mounted) setState(() {}); 
    });
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  
   Future<void> _searchProductsOnly() async {
    try {
      final products = await _productService.fetchProducts(
        categoryId: _selectedCategory,
        query: _searchController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _products = products;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
      });
    }
  }
  
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _searchProductsOnly();
      });
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _productService.fetchBanners(),
        _productService.fetchCategories(),
        _productService.fetchProducts(
          categoryId: _selectedCategory,
          query: _searchController.text.trim(),
        ),
      ]);
      if (!mounted) {
        return;
      }
      setState(() {
        _banners = results[0] as List<BannerItem>;
        _categories = results[1] as List<Category>;
        _products = results[2] as List<Product>;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _addToCart(Product product) async {
    await _cartService.addToCart(product);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  String get _deliverTo {
    final address = Get.find<AuthService>().currentUser?.address;
    if (address == null) {
      return 'Phnom Penh';
    }
    return '${address.label} • ${address.city}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {
        //     Scaffold.of(context).openDrawer();
        //   },
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ApiConfig.appName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Deliver to $_deliverTo',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search food, grocery, gadgets...',
                  prefixIcon: const Icon(Icons.search),
                  
                  // suffixIcon: IconButton(
                  //   icon: const Icon(Icons.tune),
                  //   onPressed: _load,
                  // ),

                  // suffixIcon: IntrinsicWidth(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       if (_searchController.text.isNotEmpty)
                  //         IconButton(
                  //           padding: EdgeInsets.zero,
                  //           constraints: const BoxConstraints(),
                  //           icon: const Icon(Icons.clear, color: Colors.grey),
                  //           onPressed: () {
                  //             _searchController.clear();
                  //             _onSearchChanged('');
                  //           },
                  //         ),
                  //       IconButton(
                  //         padding: EdgeInsets.zero,
                  //         constraints: const BoxConstraints(),
                  //         icon: const Icon(Icons.tune),
                  //         onPressed: _load,
                  //       ),
                  //       const SizedBox(width: 4)
                  //     ],
                  //   ),
                  // ),
                  suffixIcon: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _searchProductsOnly();
                            },
                            child: const Icon(Icons.clear, color: Colors.grey),
                          ),
                        
                        // នេះជា space តែបន្តិចរវាង X និង Filter (អ្នកអាចដូរពី 12 ទៅ 8 ឬ 6 តាមចិត្តចង់បាន)
                        if (_searchController.text.isNotEmpty) const SizedBox(width: 12), 
                        
                        GestureDetector(
                          onTap: _load,
                          child: const Icon(Icons.tune, color: Colors.black87),
                        ),
                        
                        const SizedBox(width: 16), // គម្លាតពីប៊ូតុង Filter ទៅគែមខាងស្តាំនៃ TextField
                      ],
                    ),
                  ),

                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            HomeSlider(banners: _banners),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final selected = category.id == _selectedCategory;
                  return ChoiceChip(
                    label: Text(category.name),
                    selected: selected,
                    selectedColor: AppColor.primary.withOpacity(0.18),
                    onSelected: (_) {
                      setState(() => _selectedCategory = category.id);
                      _load();
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  const Text(
                    'Popular near you',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${_products.length} items',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: _load, child: const Text('Retry')),
                  ],
                ),
              )
            else
              ProductGrid(
                products: _products,
                onTap: (product) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetail(product: product),
                    ),
                  );
                },
                onAdd: _addToCart,
              ),
          ],
        ),
      ),
    );
  }
}
