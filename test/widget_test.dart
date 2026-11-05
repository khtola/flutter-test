import 'package:first_app/api/api_bindings.dart';
import 'package:first_app/controllers/theme_controller.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash then shop home loads from static API', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
    await setupApiDependencies();
    Get.put(ThemeController());

    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('ShopGo'), findsWidgets);
    expect(find.text('Shop & Delivery'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pump();

    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
  });
}
