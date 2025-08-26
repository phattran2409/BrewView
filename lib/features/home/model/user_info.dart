class UserInfo {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? phoneNumber;
  final DateTime? lastLoginAt;
  final List<String> preferences;
  final int totalOrders;
  final double totalSpent;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.phoneNumber,
    this.lastLoginAt,
    this.preferences = const [],
    this.totalOrders = 0,
    this.totalSpent = 0.0,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      phoneNumber: json['phoneNumber'],
      lastLoginAt:
          json['lastLoginAt'] != null
              ? DateTime.parse(json['lastLoginAt'])
              : null,
      preferences: List<String>.from(json['preferences'] ?? []),
      totalOrders: json['totalOrders'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'preferences': preferences,
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
    };
  }

  UserInfo copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? phoneNumber,
    DateTime? lastLoginAt,
    List<String>? preferences,
    int? totalOrders,
    double? totalSpent,
  }) {
    return UserInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
    );
  }

  @override
  String toString() {
    return 'UserInfo(id: $id, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserInfo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
