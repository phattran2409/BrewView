// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferred_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferredCategoryModel _$UserPreferredCategoryModelFromJson(
  Map<String, dynamic> json,
) => UserPreferredCategoryModel(
  userId: json['userId'] as String,
  categoryId: (json['categoryId'] as num).toInt(),
);

Map<String, dynamic> _$UserPreferredCategoryModelToJson(
  UserPreferredCategoryModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'categoryId': instance.categoryId,
};
