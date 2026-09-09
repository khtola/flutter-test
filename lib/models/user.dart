class User {
  final String? id;
  final String username;
  final String? token;

  const User({
    this.id,
    required this.username,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final nested = json['user'];
    final source = nested is Map<String, dynamic> ? nested : json;
    return User(
      id: source['id']?.toString(),
      username: source['username']?.toString() ??
          source['name']?.toString() ??
          '',
      token: json['token']?.toString() ??
          json['access_token']?.toString() ??
          source['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      if (token != null) 'token': token,
    };
  }
}
