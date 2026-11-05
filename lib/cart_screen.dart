import 'package:first_app/components/product_image.dart';
import 'package:first_app/components/qty_stepper.dart';
import 'package:first_app/controllers/nav_controller.dart';
import 'package:first_app/order_summary_screen.dart';
import 'package:first_app/product_detail_screen.dart';
import 'package:first_app/services/cart_service.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cart = Get.find<CartService>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await _cart.fetchCart();
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        automaticallyImplyLeading: canPop,
      ),
      body: Obx(() {
        if (_loading && _cart.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_cart.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 72, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('Your cart is empty'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Get.find<NavController>().goTo(0);
                      });
                    }
                  },
                  child: const Text('Start shopping'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _cart.items.length,
                itemBuilder: (context, index) {
                  final product = _cart.items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetail(product: product),
                                ),
                              );
                            },
                            child: ProductImage(
                              url: product.imageUrl,
                              width: 64,
                              height: 64,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetail(product: product),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)} • ${product.deliveryMinutes} min',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          QtyStepper(
                            value: product.quantity,
                            min: 0,
                            onChanged: (value) async{
                              final id = product.id;
                              if (id == null) return;
                              if(value == 0) {
                                final itemExists = _cart.items.any((item) => item.id == id);
                                if(!itemExists) return;
                              } 
                              try {
                                await _cart.updateQuantity(id, value);
                              } catch (e) {
                                debugPrint("ដោះស្រាយបញ្ហា Cart: $e");
                                _cart.fetchCart();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _row('Subtotal', _cart.subtotal),
                  _row(
                    'Delivery',
                    _cart.deliveryFee,
                    trailing: _cart.deliveryFee == 0 ? 'Free' : null,
                  ),
                  const Divider(),
                  _row('Total', _cart.total, bold: true),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderSummaryScreen(
                              products: List.of(_cart.items),
                              totalPrice: _cart.total,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Checkout & deliver'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _row(String label, double value, {bool bold = false, String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500),
          ),
          const Spacer(),
          Text(
            trailing ?? '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: bold ? AppColor.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
