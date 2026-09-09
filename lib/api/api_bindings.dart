import 'package:first_app/api/api_client.dart';
import 'package:first_app/services/auth_service.dart';
import 'package:first_app/services/cart_service.dart';
import 'package:first_app/services/notification_service.dart';
import 'package:first_app/services/order_service.dart';
import 'package:first_app/services/product_service.dart';
import 'package:first_app/storage/local_storage.dart';
import 'package:get/get.dart';

Future<void> setupApiDependencies() async {
  final storage = LocalStorage();
  await storage.init();
  Get.put(storage, permanent: true);

  final client = ApiClient(storage: storage);
  Get.put(client, permanent: true);

  Get.put(AuthService(client, storage), permanent: true);
  Get.put(ProductService(client), permanent: true);
  Get.put(CartService(client), permanent: true);
  Get.put(NotificationService(client), permanent: true);
  Get.put(OrderService(client), permanent: true);
}
