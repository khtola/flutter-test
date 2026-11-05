import 'package:first_app/api/api_client.dart';
import 'package:first_app/api/api_config.dart';
import 'package:first_app/controllers/nav_controller.dart';
import 'package:first_app/services/auth_service.dart';
import 'package:first_app/services/cart_service.dart';
import 'package:first_app/services/notification_service.dart';
import 'package:first_app/services/order_service.dart';
import 'package:first_app/services/product_service.dart';
import 'package:first_app/services/wishlist_service.dart';
import 'package:first_app/storage/local_storage.dart';
import 'package:get/get.dart';

Future<void> setupApiDependencies() async {
  final storage = LocalStorage();
  await storage.init();
  Get.put(storage, permanent: true);

  final client = ApiClient(storage: storage);
  Get.put(client, permanent: true);
  Get.put(NavController(), permanent: true);

  Get.put(AuthService(client, storage), permanent: true);
  Get.put(ProductService(client), permanent: true);

  final cart = CartService(client);
  Get.put(cart, permanent: true);

  final wishlist = WishlistService(client);
  Get.put(wishlist, permanent: true);

  Get.put(NotificationService(client), permanent: true);

  final orders = OrderService(client);
  Get.put(orders, permanent: true);

  final auth = Get.find<AuthService>();

  if (ApiConfig.useStaticApi) {
    await Future.wait([
      auth.fetchProfile(),
      cart.fetchCart(),
      wishlist.fetchWishlist(),
      orders.fetchOrders(),
    ]);
  }
}
