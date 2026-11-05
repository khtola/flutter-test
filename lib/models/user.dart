import 'package:first_app/models/address.dart';

class User {
  final String? id;
  final String username;
  final String? name;
  final String? phone;
  final String? token;
  final Address? address;

  const User({
    this.id,
    required this.username,
    this.name,
    this.phone,
    this.token,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final nested = json['user'];
    final source = nested is Map ? Map<String, dynamic>.from(nested) : json;
    final rawAddress = source['address'] ?? json['address'];
    return User(
      id: source['id']?.toString(),
      username: source['username']?.toString() ??
          source['name']?.toString() ??
          '',
      name: source['name']?.toString(),
      phone: source['phone']?.toString(),
      token: json['token']?.toString() ??
          json['access_token']?.toString() ??
          source['token']?.toString(),
      address: rawAddress is Map
          ? Address.fromJson(Map<String, dynamic>.from(rawAddress))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (token != null) 'token': token,
      if (address != null) 'address': address!.toJson(),
    };
  }
}
