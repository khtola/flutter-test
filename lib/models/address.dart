class Address {
  final String label;
  final String street;
  final String city;
  final String phone;
  final String note;

  const Address({
    required this.label,
    required this.street,
    required this.city,
    required this.phone,
    this.note = '',
  });

  String get line => '$street, $city';

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      label: json['label']?.toString() ?? 'Home',
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'street': street,
      'city': city,
      'phone': phone,
      'note': note,
    };
  }

  Address copyWith({
    String? label,
    String? street,
    String? city,
    String? phone,
    String? note,
  }) {
    return Address(
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      note: note ?? this.note,
    );
  }
}
