import 'user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  String? identityId;
  String? role;
  int? age; // Thêm
  String? gender; // Thêm
  String? provinceName; // Thêm
  bool? isPremium; // Thêm
  bool? status; // Thêm
  DateTime? createdAt; // Thêm

  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.profilePicture,
    super.accessToken,
    super.refreshToken,
    super.isSurvey,
    String? identityId,
    String? role,
    int? age, // Thêm
    String? gender, // Thêm
    String? provinceName, // Thêm
    bool? isPremium, // Thêm
    bool? status, // Thêm
    DateTime? createdAt, // Thêm
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // ✅ Safe DateTime parsing
    DateTime? createdAtDateTime;
    if (json['createdAt'] != null) {
      try {
        if (json['createdAt'] is String) {
          createdAtDateTime = DateTime.parse(json['createdAt'] as String);
        } else if (json['createdAt'] is DateTime) {
          createdAtDateTime = json['createdAt'] as DateTime;
        }
      } catch (e) {
        print('Error parsing createdAt: $e');
        createdAtDateTime = DateTime.now();
      }
    }

    return UserModel(
      id: json['userId'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profilePicture'] as String?,
      role: json['role'] as String?,
      identityId: json['identityId'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      age: json['age'] as int?,
      provinceName: json['provinceName'] as String?,
      isPremium: json['isPremium'] as bool?,
      status: json['status'] as bool?,
      isSurvey: json['isSurvey'] as bool?,
      createdAt: createdAtDateTime,
      gender: json['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'role': role,
      'identityId': identityId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'phoneNumber': phoneNumber,
      'age': age,
      'provinceName': provinceName,
      'isPremium': isPremium,
      'status': status,
      'isSurvey': isSurvey,
      'createdAt':
          createdAt?.toIso8601String(), // ✅ Convert back to String for JSON
      'gender': gender,
    };
  }

  // ✅ Helper getter for formatted date string
  String? get createdAtFormatted {
    if (createdAt == null) return null;
    // You can format as needed, e.g., using intl package
    return createdAt!.toIso8601String();
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      isSurvey: isSurvey,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? accessToken,
    String? refreshToken,
    String? identityId,
    String? role,
    int? age,
    String? gender,
    String? provinceName,
    bool? isPremium,
    bool? status,
    bool? isSurvey,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      identityId: identityId ?? this.identityId,
      role: role ?? this.role,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      provinceName: provinceName ?? this.provinceName,
      isPremium: isPremium ?? this.isPremium,
      status: status ?? this.status,
      isSurvey: isSurvey ?? this.isSurvey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
