// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureTagModel _$FeatureTagModelFromJson(Map<String, dynamic> json) =>
    FeatureTagModel(
      tagId: (json['tagId'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$FeatureTagModelToJson(FeatureTagModel instance) =>
    <String, dynamic>{'tagId': instance.tagId, 'name': instance.name};
