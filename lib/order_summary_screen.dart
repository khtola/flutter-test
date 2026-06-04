import 'package:flutter/material.dart';

class OrderSummaryScreen extends StatelessWidget {
  final double? totalPrice;
  
  const OrderSummaryScreen({super.key,  this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final buttonColor = theme.buttonTheme.colorScheme?.primary ?? Colors.blue;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary", style: TextStyle(color: textColor)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Order Details Section
            Text(
              "Order Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8.0),
            // Example order items, you can populate this with actual data
            ListTile(
              leading: Image.network('https://via.placeholder.com/150'),
              title: Text("Product 1", style: TextStyle(color: textColor)),
              subtitle: Text("\$29.99", style: TextStyle(color: textColor)),
            ),
            ListTile(
              leading: Image.network('https://via.placeholder.com/150'),
              title: Text("Product 2", style: TextStyle(color: textColor)),
              subtitle: Text("\$59.99", style: TextStyle(color: textColor)),
            ),
            
            // Total Price Section
            const SizedBox(height: 16.0),
            Text(
              "Total",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8.0),
            Text(
              // "\$${totalPrice.toStringAsFixed(2)}",
              "34",
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            
            // Payment Methods Section
            const SizedBox(height: 16.0),
            Text(
              "Payment Methods",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.credit_card, color: textColor),
                    title: Text("Credit Card", style: TextStyle(color: textColor)),
                    onTap: () {
                      // Handle payment method selection
                    },
                  ),
                   ListTile(
                    leading: Icon(Icons.paypal, color: textColor),
                    title: Text("PayPal", style: TextStyle(color: textColor)),
                    onTap: () {
                      // Handle payment method selection
                    },
                  ),
                ]
              ),
            ) 
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // "Total: \$${totalPrice.toStringAsFixed(2)}",
              "Total:  43.5",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle payment process
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
              ),
              child: const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
