import 'package:first_app/cart_screen.dart';
import 'package:first_app/components/product_image.dart';
import 'package:first_app/components/qty_stepper.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/order_summary_screen.dart';
import 'package:first_app/services/cart_service.dart';
import 'package:first_app/services/wishlist_service.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, this.product});

  final Product? product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Product _product;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _product = widget.product ??
        Product(
          id: 'p0',
          imageUrl: '',
          name: 'Product',
          price: 0,
          color: Colors.grey,
          discount: '',
        );
  }

  Future<void> _addToCart({bool buyNow = false}) async {
    final cart = Get.find<CartService>();
    await cart.addToCart(_product, quantity: _quantity);
    if (!mounted) {
      return;
    }
    if (buyNow) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSummaryScreen(
            products: [_product.copyWith(quantity: _quantity)],
            totalPrice: _product.price * _quantity,
          ),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_product.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _product.gallery;
    final wishlist = Get.find<WishlistService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_product.name),
        actions: [
          Obx(() {
            final saved = wishlist.contains(_product.id);
            return IconButton(
              icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
              color: saved ? Colors.red : null,
              onPressed: () => wishlist.toggle(_product),
            );
          }),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text:
                      '${_product.name} is available for \$${_product.price.toStringAsFixed(2)} on ShopGo',
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 260,
            child: images.isEmpty
                ? const Center(child: Icon(Icons.image_outlined, size: 64))
                : PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return ProductImage(url: images[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (_product.discount.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _product.discount,
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(' ${_product.rating.toStringAsFixed(1)}'),
                    const Spacer(),
                    Text('${_product.stock} in stock'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '\$${_product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    if (_product.originalPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '\$${_product.originalPrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Delivery in ${_product.deliveryMinutes} min • ${_product.category}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                if (_product.size.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Size: ${_product.size}'),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  _product.description.isEmpty
                      ? 'Fresh product, packed and delivered from nearby stores.'
                      : _product.description,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Quantity',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    QtyStepper(
                      value: _quantity,
                      max: _product.stock == 0 ? 1 : _product.stock,
                      onChanged: (value) => setState(() => _quantity = value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _addToCart(),
                  child: const Text('Add to cart'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _addToCart(buyNow: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Buy now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
