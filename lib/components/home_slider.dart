import 'dart:async';

import 'package:first_app/cart_screen.dart';
import 'package:first_app/components/button.dart';
import 'package:first_app/components/grid_list.dart';
import 'package:first_app/notification_screen.dart';
import 'package:first_app/product_detail_screen.dart';
import 'package:first_app/setting_screen.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
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
    final theme = Theme.of(context);
    final textColor =  theme.textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor =  theme.scaffoldBackgroundColor ;
    final buttonColor = theme.buttonTheme.colorScheme?.primary ?? Colors.blue;
    final appBarBackgroundColor = theme.appBarTheme.backgroundColor ?? (theme.brightness == Brightness.dark ? Colors.black : Colors.white);
    final appBarTextColor = theme.appBarTheme.titleTextStyle?.color ?? ( theme.brightness == Brightness.dark ? Colors.white : Colors.black);

    // final product  =  ProductDetail(id: '1', name: 'T-shirt', price: '111')
    return Scaffold(
       key: _scaffoldKey, 
      appBar: AppBar(
        title: Text("Home",style: TextStyle(color: appBarTextColor),),
        backgroundColor: appBarBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu ,color: appBarTextColor,),
           onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
           },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications,color: appBarTextColor),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => const NotificationScreen()));
            }, 
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: backgroundColor),
              child: Text('Drawer Header',
                style: TextStyle(color: textColor),
              )
            ),
            ListTile(
              title: Text('All',style: TextStyle(color: textColor),),
              onTap: (){},
            ),
            ListTile(
              title: Text('Contener',style: TextStyle(color: textColor),),
              onTap:() { },
            ),
            ListTile(
              title: Text('Other' ,style: TextStyle(color: textColor),),
              onTap:() { },
            ),
            ListTile(
              minVerticalPadding: 30,
              title: Text('Version 1.0.0',style: TextStyle(fontWeight: FontWeight.w600,color: textColor),),
              onTap:() { },
            )
          ],
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: ListView(
          children: [
            /// Slider
            widgetSlider(context),
            /// Buttom
            widgetButtom(context, onClick: (){
               Navigator.push(context,MaterialPageRoute(builder: (context) => const CartScreen()),);
            }),
            /// GridView
            widgetGridView(context, onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductDetail()),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: widgetButtomTabbar(context),
    );
  }

widgetButtomTabbar(BuildContext context){
  return BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: 'Cart',
      ),
        BottomNavigationBarItem(
        icon: Icon(Icons.brightness_5_sharp),
        label: 'Setting',
      ),
    ],
  currentIndex: 0, // Set the initial index
    onTap: (index) {
      print('Selected index: $index');
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      }else if(index == 2){
        Navigator.push(
          context,
            MaterialPageRoute(builder: (context) => const SettingScreen())
        );
      }
    },
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
