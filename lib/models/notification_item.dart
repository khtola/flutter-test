class NotificationItem {
  final String? id;
  final String title;
  final String name;

  const NotificationItem({
    this.id,
    required this.title,
    required this.name,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? '',
      name: json['name']?.toString() ?? json['body']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'name': name,
    };
  }
}
