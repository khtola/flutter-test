import 'package:first_app/controllers/nav_controller.dart';
import 'package:first_app/delivery_tracking_screen.dart';
import 'package:first_app/services/order_service.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _orders = Get.find<OrderService>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await _orders.fetchOrders();
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'delivered':
        return AppColor.success;
      case 'on_the_way':
        return AppColor.onTheWay;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColor.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders & delivery')),
      body: Obx(() {
        if (_loading && _orders.orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_orders.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_shipping_outlined, size: 72, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('No orders yet'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Get.find<NavController>().goTo(0),
                  child: const Text('Shop now'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _orders.orders.length,
            itemBuilder: (context, index) {
              final order = _orders.orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    order.id,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${order.items.length} item(s) • ${order.paymentMethod}'),
                        const SizedBox(height: 4),
                        Text(order.address.line),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(order.status).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.statusLabel,
                            style: TextStyle(
                              color: _statusColor(order.status),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeliveryTrackingScreen(orderId: order.id),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
