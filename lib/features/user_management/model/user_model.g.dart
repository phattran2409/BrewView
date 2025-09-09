// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  profilePicture: json['profilePicture'] as String?,
  accessToken: json['accessToken'] as String?,
  refreshToken: json['refreshToken'] as String?,
  identityId: json['identityId'] as String?,
  role: json['role'] as String?,
  gender: json['gender'] as String?,
  provinceName: json['provinceName'] as String?,
  isPremium: json['isPremium'] as bool?,
  status: json['status'] as bool?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'profilePicture': instance.profilePicture,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'identityId': instance.identityId,
  'role': instance.role,
  'gender': instance.gender,
  'provinceName': instance.provinceName,
  'isPremium': instance.isPremium,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
};
