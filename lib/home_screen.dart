import 'package:first_app/components/home_slider.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text("KHTL01"),
        centerTitle: true,
        backgroundColor: coloAppBar,
      ),
      body: Container(child: ListView(children: const [
        // HomeSlider(),
      ]),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle FAB press
        },
        backgroundColor: backgroundColor,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
