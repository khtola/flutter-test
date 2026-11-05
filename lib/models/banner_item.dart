class BannerItem {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;

  const BannerItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
    );
  }
}
