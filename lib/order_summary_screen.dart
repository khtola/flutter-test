import 'package:first_app/api/api_exception.dart';
import 'package:first_app/components/product_image.dart';
import 'package:first_app/delivery_tracking_screen.dart';
import 'package:first_app/models/address.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/services/auth_service.dart';
import 'package:first_app/services/cart_service.dart';
import 'package:first_app/services/order_service.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSummaryScreen extends StatefulWidget {
  final double? totalPrice;
  final List<Product>? products;

  const OrderSummaryScreen({
    super.key,
    this.totalPrice,
    this.products,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late final List<Product> _items;
  late final Address _address;
  String? _paymentMethod = 'Cash on Delivery';
  bool _isPaying = false;

  @override
  void initState() {
    super.initState();
    _items = widget.products?.isNotEmpty == true
        ? widget.products!
        : List.of(Get.find<CartService>().items);
    _address = Get.find<AuthService>().currentUser?.address ??
        const Address(
          label: 'Home',
          street: 'Street 271, Toul Kork',
          city: 'Phnom Penh',
          phone: '+855 12 345 678',
          note: 'Call on arrival',
        );
  }

  double get _subtotal =>
      _items.fold<double>(0, (sum, item) => sum + item.lineTotal);

  double get _deliveryFee => _subtotal >= 15 ? 0 : 1.5;

  double get _total => widget.totalPrice ?? (_subtotal + _deliveryFee);

  Future<void> _payNow() async {
    if (_paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a payment method')),
      );
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    setState(() => _isPaying = true);
    try {
      final order = await Get.find<OrderService>().placeOrder(
        items: _items,
        paymentMethod: _paymentMethod!,
        total: _total,
        subtotal: _subtotal,
        deliveryFee: _deliveryFee,
        address: _address,
      );
      await Get.find<CartService>().fetchCart();
      if (!mounted) {
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DeliveryTrackingScreen(orderId: order.id),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isPaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Deliver to',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on, color: AppColor.primary),
              title: Text('${_address.label} • ${_address.phone}'),
              subtitle: Text('${_address.line}\n${_address.note}'),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Order details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._items.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ProductImage(
                url: item.imageUrl,
                width: 56,
                height: 56,
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(item.name, style: TextStyle(color: textColor)),
              subtitle: Text('x${item.quantity}'),
              trailing: Text('\$${item.lineTotal.toStringAsFixed(2)}'),
            ),
          ),
          const Divider(height: 32),
          _amountRow('Subtotal', _subtotal),
          _amountRow('Delivery', _deliveryFee, free: _deliveryFee == 0),
          _amountRow('Total', _total, bold: true),
          const SizedBox(height: 16),
          const Text(
            'Payment methods',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'Cash on Delivery',
                  groupValue: _paymentMethod,
                  activeColor: AppColor.primary,
                  secondary: const Icon(Icons.payments_outlined),
                  title: const Text('Cash on Delivery'),
                  onChanged: _isPaying
                      ? null
                      : (value) => setState(() => _paymentMethod = value),
                ),
                RadioListTile<String>(
                  value: 'ABA KHQR',
                  groupValue: _paymentMethod,
                  activeColor: AppColor.primary,
                  secondary: const Icon(Icons.qr_code),
                  title: const Text('ABA KHQR'),
                  onChanged: _isPaying
                      ? null
                      : (value) => setState(() => _paymentMethod = value),
                ),
                RadioListTile<String>(
                  value: 'Credit Card',
                  groupValue: _paymentMethod,
                  activeColor: AppColor.primary,
                  secondary: const Icon(Icons.credit_card),
                  title: const Text('Credit Card'),
                  onChanged: _isPaying
                      ? null
                      : (value) => setState(() => _paymentMethod = value),
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
                child: Text(
                  'Total: \$${_total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _isPaying ? null : _payNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: _isPaying
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Place order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amountRow(String label, double value, {bool bold = false, bool free = false}) {
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
            free ? 'Free' : '\$${value.toStringAsFixed(2)}',
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
