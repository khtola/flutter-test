import 'package:get/get.dart';

class NavController extends GetxController {
  final index = 0.obs;

  void goTo(int value) => index.value = value;
}
