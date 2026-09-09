import 'package:first_app/api/api_client.dart';
import 'package:first_app/api/api_endpoints.dart';
import 'package:first_app/models/notification_item.dart';

class NotificationService {
  NotificationService(this._client);

  final ApiClient _client;

  Future<List<NotificationItem>> fetchNotifications() async {
    final response = await _client.get(ApiEndpoints.notifications);
    return _asList(response).map(NotificationItem.fromJson).toList();
  }

  List<Map<String, dynamic>> _asList(dynamic response) {
    final raw =
        response is Map ? response['data'] ?? response['notifications'] : response;
    if (raw is List) {
      return raw.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    return const [];
  }
}
