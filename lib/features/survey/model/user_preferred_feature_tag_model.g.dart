// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferred_feature_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferredFeatureTagModel _$UserPreferredFeatureTagModelFromJson(
  Map<String, dynamic> json,
) => UserPreferredFeatureTagModel(
  userId: json['userId'] as String,
  featureTagId: (json['featureTagId'] as num).toInt(),
);

Map<String, dynamic> _$UserPreferredFeatureTagModelToJson(
  UserPreferredFeatureTagModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'featureTagId': instance.featureTagId,
};
