class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/login';
  static const String logout = '/logout';
  static const String register = '/register';
  static const String profile = '/profile';

  static const String banners = '/banners';
  static const String categories = '/categories';

  static const String products = '/products';
  static String product(String id) => '/products/$id';

  static const String cart = '/cart';
  static String cartItem(String id) => '/cart/$id';

  static const String wishlist = '/wishlist';
  static String wishlistItem(String id) => '/wishlist/$id';

  static const String notifications = '/notifications';

  static const String orders = '/orders';
  static String order(String id) => '/orders/$id';
}
