import 'package:first_app/api/api_exception.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/services/order_service.dart';
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
  static final List<Product> _demoItems = [
    Product(
      imageUrl: 'assets/Screenshot1.png',
      name: 'Product 1',
      price: 29.99,
      color: Colors.red,
      discount: 'discount 70%',
    ),
    Product(
      imageUrl: 'assets/Screenshot2.png',
      name: 'Product 2',
      price: 59.99,
      color: Colors.blue,
      discount: 'discount 50%',
    ),
  ];

  late final List<Product> _items;
  String? _paymentMethod;
  bool _isPaying = false;

  @override
  void initState() {
    super.initState();
    _items = widget.products?.isNotEmpty == true ? widget.products! : _demoItems;
  }

  double get _total {
    if (widget.totalPrice != null) {
      return widget.totalPrice!;
    }
    return _items.fold<double>(0, (sum, item) => sum + item.price);
  }

  Future<void> _payNow() async {
    if (_paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a payment method')),
      );
      return;
    }

    setState(() => _isPaying = true);
    try {
      await Get.find<OrderService>().placeOrder(
        items: _items,
        paymentMethod: _paymentMethod!,
        total: _total,
      );
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment successful'),
          content: Text(
            'Paid \$${_total.toStringAsFixed(2)} with $_paymentMethod.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
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
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final buttonColor = theme.colorScheme.primary;
    final formattedTotal = _total.toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary', style: TextStyle(color: textColor)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8.0),
            ..._items.map(
              (item) => ListTile(
                leading: _productImage(item.imageUrl),
                title: Text(item.name, style: TextStyle(color: textColor)),
                subtitle: Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Total',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '\$$formattedTotal',
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'Credit Card',
                    groupValue: _paymentMethod,
                    activeColor: buttonColor,
                    secondary: Icon(Icons.credit_card, color: textColor),
                    title: Text('Credit Card', style: TextStyle(color: textColor)),
                    onChanged: _isPaying
                        ? null
                        : (value) => setState(() => _paymentMethod = value),
                  ),
                  RadioListTile<String>(
                    value: 'PayPal',
                    groupValue: _paymentMethod,
                    activeColor: buttonColor,
                    secondary: Icon(Icons.account_balance_wallet, color: textColor),
                    title: Text('PayPal', style: TextStyle(color: textColor)),
                    onChanged: _isPaying
                        ? null
                        : (value) => setState(() => _paymentMethod = value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$$formattedTotal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              ElevatedButton(
                onPressed: _isPaying ? null : _payNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: _isPaying
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productImage(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
      );
    }

    return Image.network(
      url,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
    );
  }
}
