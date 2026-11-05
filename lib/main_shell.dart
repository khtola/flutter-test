import 'package:first_app/cart_screen.dart';
import 'package:first_app/controllers/nav_controller.dart';
import 'package:first_app/home_screen.dart';
import 'package:first_app/orders_screen.dart';
import 'package:first_app/services/cart_service.dart';
import 'package:first_app/setting_screen.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:first_app/Wishlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _pages = const [
    HomeScreen(),
    OrdersScreen(),
    CartScreen(),
    WishlistScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavController>();
    final cart = Get.find<CartService>();

    return Obx(() {
      final index = nav.index.value;
      return Scaffold(
        body: IndexedStack(index: index, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor.primary,
          unselectedItemColor: Colors.grey,
          onTap: nav.goTo,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Shop',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              activeIcon: Icon(Icons.local_shipping),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: _CartIcon(count: cart.itemCount, filled: false),
              activeIcon: _CartIcon(count: cart.itemCount, filled: true),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      );
    });
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.count, required this.filled});

  final int count;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(filled ? Icons.shopping_bag : Icons.shopping_bag_outlined),
        if (count > 0)
          Positioned(
            right: -8,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count > 9 ? '9+' : '$count',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}
