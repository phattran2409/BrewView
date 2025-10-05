// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureTagModel _$FeatureTagModelFromJson(Map<String, dynamic> json) =>
    FeatureTagModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
    );

Map<String, dynamic> _$FeatureTagModelToJson(FeatureTagModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
    };
