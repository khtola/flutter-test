import 'dart:async';

import 'package:first_app/cart_screen.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/order_summary_screen.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, this.product});
    final Product? product;


  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final List<String> images = [
    'assets/Screenshot1.png',
    'assets/Screenshot2.png',
    'assets/Screenshot3.png',
    'assets/Screenshot4.png',
    'assets/Screenshot4.png',
  ];
  
  late PageController _pageController;
  late int _currentPage;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController(initialPage: _currentPage);
    _startAutoPlay();

    print('Product tola: ${widget.product?.price}');
  }

   @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

    void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme =  Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final buttonColor = theme.buttonTheme.colorScheme?.primary ?? Colors.blue;
    final appBarBackgroundColor = theme.appBarTheme.backgroundColor ?? (theme.brightness == Brightness.dark ? Colors.black : Colors.white);
    final appBarTextColor = theme.appBarTheme.titleTextStyle?.color ?? ( theme.brightness == Brightness.dark ? Colors.white : Colors.black);


    return Scaffold(
       appBar: AppBar(
        title: Text("Product",style: TextStyle(color: appBarTextColor),),
        backgroundColor: appBarBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new ,color: appBarTextColor,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart,color: appBarTextColor,),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => const CartScreen()));
            }, 
          ),
        ],
      ),
     body: Column(
        children: [
          widgetSlider(context),
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: backgroundColor,
                  child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 7,
                          child:SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.4,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: const EdgeInsets.only(left: 15),
                                child: Text('\$${widget.product?.price ?? '23.8'}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: textColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text('\$${widget.product?.discount  ?? 'the t-shite disount 70%'}'),
                              )
                            ],
                          )
                         ), 
                        ),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('1 instock',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16 ,color: textColor),),
                              Padding(
                                padding:  const EdgeInsets.only(right: 0),
                                //  child: Text('10.12'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Size M',style: TextStyle(color: textColor),),
                                    const SizedBox(width: 5),
                                    // Icon(Icons.ios_share_outlined)
                                    IconButton(
                                      icon: Icon(Icons.ios_share_outlined,color: textColor,),
                                      onPressed:() {
                                        Share.share('Check out this product!');
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                       ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('-  input  +',style: TextStyle(color: textColor),)
                            ],
                          ),
                        )
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: const EdgeInsets.only(right: 15),
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderSummaryScreen(
                                    products: widget.product == null
                                        ? null
                                        : [widget.product!],
                                    totalPrice: widget.product?.price,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              foregroundColor: textColor
                            ),
                            child: Text('Add to Cart',style: TextStyle(color: textColor),),
                          ),
                        )
                      )
                    ],
                  ),
                Container(
                  margin:const EdgeInsets.only(left: 8,top: 5),
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.only(right: 8.0),
                        child:SizedBox(
                          width: 160,
                          child: Image.asset('assets/Screenshot1.png',height: 200,fit: BoxFit.cover,),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(right: 8.0),
                        child:SizedBox(
                          width: 160,
                          child: Image.asset('assets/Screenshot2.png',height: 200,fit: BoxFit.cover,),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(right: 8.0),
                        child:SizedBox(
                          width: 160,
                          child: Image.asset('assets/Screenshot3.png',height: 200,fit: BoxFit.cover,),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(right: 8.0),
                        child:SizedBox(
                          width: 160,
                          child: Image.asset('assets/Screenshot4.png',height: 200,fit: BoxFit.cover,),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(right: 8.0),
                        child:SizedBox(
                          width: 160,
                          child: Image.asset('assets/Screenshot5.png',height: 200,fit: BoxFit.cover,),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Size",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: textColor),
                      ),
                      const SizedBox(width: 5,),
                      SizedBox(
                        width: 110,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: buttonColor, // You can set your preferred color here
                                width: 0.5,          // This is set to 1.0 by default
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10,)
              ],
            ),
          ),
        ],
      ),
    );
  }
   Widget widgetSlider(BuildContext context){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.asset(
            images[index],
            fit: BoxFit.cover,
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
