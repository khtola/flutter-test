class ApiConfig {
  ApiConfig._();

  /// Keep this `true` until a real backend is ready.
  /// Set to `false` and update [baseUrl] to switch to live HTTP calls.
  static const bool useStaticApi = true;

  static const String baseUrl = 'https://example.com/api';
  static const Duration timeout = Duration(seconds: 15);
  static const Duration staticDelay = Duration(milliseconds: 250);

  static const String appName = 'ShopGo';
  static const String appTagline = 'Shop & Delivery';

  static const String demoUsername = 'demo';
  static const String demoPassword = '123456';
}
