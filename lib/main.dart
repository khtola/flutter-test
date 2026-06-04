
import 'package:first_app/components/home_slider.dart';
import 'package:first_app/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'setting_screen.dart';

void main() {
  final themeController = Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final themeController = Get.find<ThemeController>();
        return GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          home: const HomeSlider(),
        );
      },
    );
  }
}
