import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_app/product_detail_screen.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:share/share.dart';

// Product data model
class Product {
  final String imageUrl;
  final String name;
  final double price;
  final Color color;
  final String discount;
  bool isWishlist;

  Product({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.color,
    required this.discount,
    this.isWishlist = false,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample products
  final List<Product> _products = [
    Product(
        imageUrl: 'https://via.placeholder.com/150',
        name: 'Product 1',
        price: 29.99,
        color: Colors.red,
        discount: 'discount 70%'),
    Product(
        imageUrl: 'https://via.placeholder.com/150',
        name: 'Product 2',
        price: 59.99,
        color: Colors.blue,
        discount: 'discount 50%'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final appBarTextColor = theme.appBarTheme.titleTextStyle?.color ??
        (theme.brightness == Brightness.dark ? Colors.white : Colors.black);
    final appBarBackgroundColor = theme.appBarTheme.backgroundColor ??
        (theme.brightness == Brightness.dark ? Colors.black : Colors.white);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(color: appBarTextColor)),
        backgroundColor: appBarBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: appBarTextColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            // return Card(
            //   margin: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: ListTile(
            //     leading: Image.network(product.imageUrl),
            //     title: Text(product.name, style: TextStyle(color: textColor)),
            //     subtitle: Text('\$${product.price}', style: TextStyle(color: textColor)),
            //     trailing: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         IconButton(
            //           icon: Icon(
            //             product.isWishlist ? Icons.favorite : Icons.favorite_border,
            //             color: product.isWishlist ? Colors.red : Colors.grey,
            //           ),
            //           onPressed: () {
            //             setState(() {
            //               product.isWishlist = !product.isWishlist;
            //             });
            //           },
            //         ),
            //         IconButton(
            //           icon: const Icon(Icons.share),
            //           onPressed: () {
            //             Share.share('${product.name} is available for \$${product.price}');
            //           },
            //         ),
            //       ],
            //     ),
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: product)));
            //     },
            //   ),
            // );
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Image.network(
                  product.imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image,
                        color: Colors.grey, size: 50);
                  },
                ),
                title: Text(product.name, style: TextStyle(color: textColor)),
                subtitle: Text('\$${product.price}',
                    style: TextStyle(color: textColor)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        product.isWishlist
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: product.isWishlist ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          product.isWishlist = !product.isWishlist;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        Share.share(
                            '${product.name} is available for \$${product.price}');
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetail(product: product)));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
