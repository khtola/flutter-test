import 'package:first_app/models/notification_item.dart';
import 'package:first_app/services/notification_service.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> _notifications = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items = await Get.find<NotificationService>().fetchNotifications();
      if (!mounted) {
        return;
      }
      setState(() {
        _notifications = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _loading = false);
    }
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'delivery':
        return Icons.local_shipping;
      case 'promo':
        return Icons.local_offer;
      case 'stock':
        return Icons.inventory_2;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final item = _notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColor.primary.withOpacity(0.12),
                        child: Icon(_iconFor(item.type), color: AppColor.primary),
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.name),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
