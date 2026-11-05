import 'package:first_app/components/product_image.dart';
import 'package:first_app/controllers/nav_controller.dart';
import 'package:first_app/product_detail_screen.dart';
import 'package:first_app/services/cart_service.dart';
import 'package:first_app/services/wishlist_service.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistService>();
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        automaticallyImplyLeading: canPop,
      ),
      body: Obx(() {
        if (wishlist.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text('No saved items yet'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (canPop) {
                      Navigator.pop(context);
                    } else {
                      Get.find<NavController>().goTo(0);
                    }
                  },
                  child: const Text('Browse products'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: wishlist.items.length,
          itemBuilder: (context, index) {
            final item = wishlist.items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetail(product: item),
                    ),
                  );
                },
                leading: ProductImage(
                  url: item.imageUrl,
                  width: 64,
                  height: 64,
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(item.name),
                subtitle: Text(
                  '\$${item.price.toStringAsFixed(2)} • ${item.category}',
                  style: const TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: AppColor.primary),
                      onPressed: () async {
                        await Get.find<CartService>().addToCart(item);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.name} added to cart')),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => wishlist.toggle(item),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
