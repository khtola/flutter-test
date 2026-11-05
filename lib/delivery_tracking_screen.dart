import 'package:first_app/components/product_image.dart';
import 'package:first_app/models/order.dart';
import 'package:first_app/services/order_service.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  Order? _order;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final order = await Get.find<OrderService>().fetchOrder(widget.orderId);
      if (!mounted) {
        return;
      }
      setState(() {
        _order = order;
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

  @override
  Widget build(BuildContext context) {
    final order = _order;
    final delivery = order?.delivery;

    return Scaffold(
      appBar: AppBar(title: const Text('Track delivery')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : order == null
                  ? const Center(child: Text('Order not found'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Card(
                          color: AppColor.primary.withOpacity(0.08),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.statusLabel,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  delivery == null || delivery.etaMinutes <= 0
                                      ? 'Order ${order.id}'
                                      : 'Arriving in about ${delivery.etaMinutes} min',
                                ),
                                const SizedBox(height: 4),
                                Text(order.address.line),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (delivery != null) ...[
                          const Text(
                            'Rider',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: AppColor.primary,
                                child: Icon(Icons.sports_motorsports, color: Colors.white),
                              ),
                              title: Text(delivery.riderName),
                              subtitle: Text('${delivery.vehicle} • ${delivery.riderPhone}'),
                              trailing: const Icon(Icons.phone, color: AppColor.primary),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tracking',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...delivery.steps.asMap().entries.map((entry) {
                            final step = entry.value;
                            final isLast = entry.key == delivery.steps.length - 1;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      step.done
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: step.done ? AppColor.success : Colors.grey,
                                    ),
                                    if (!isLast)
                                      Container(
                                        width: 2,
                                        height: 36,
                                        color: step.done
                                            ? AppColor.success
                                            : Colors.grey.shade300,
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      children: [
                                        Text(
                                          step.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: step.done ? null : Colors.grey,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (step.time != null)
                                          Text(
                                            step.time!,
                                            style: TextStyle(color: Colors.grey.shade600),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                        const SizedBox(height: 8),
                        const Text(
                          'Items',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ...order.items.map(
                          (item) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ProductImage(
                              url: item.imageUrl,
                              width: 48,
                              height: 48,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            title: Text(item.name),
                            subtitle: Text('x${item.quantity}'),
                            trailing: Text('\$${item.lineTotal.toStringAsFixed(2)}'),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Paid with'),
                          trailing: Text(order.paymentMethod),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            '\$${order.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
