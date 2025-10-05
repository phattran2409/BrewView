// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cafe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CafeModel _$CafeModelFromJson(Map<String, dynamic> json) => CafeModel(
  id: json['id'] as String?,
  categoryId: (json['categoryId'] as num).toInt(),
  name: json['name'] as String,
  address: json['address'] as String,
  description: json['description'] as String,
  priceMin: (json['priceMin'] as num).toInt(),
  priceMax: (json['priceMax'] as num).toInt(),
  linkPage: json['linkPage'] as String?,
  hotline: json['hotline'] as String?,
  ownerId: json['ownerId'] as String?,
  openingTime: json['openingTime'] as String,
  closingTime: json['closingTime'] as String,
  selectedFeatureTagIds:
      (json['selectedFeatureTagIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
  mediaUrls:
      (json['mediaUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  rating: (json['rating'] as num?)?.toDouble(),
  reviewCount: (json['reviewCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$CafeModelToJson(CafeModel instance) => <String, dynamic>{
  'id': instance.id,
  'categoryId': instance.categoryId,
  'name': instance.name,
  'address': instance.address,
  'description': instance.description,
  'priceMin': instance.priceMin,
  'priceMax': instance.priceMax,
  'linkPage': instance.linkPage,
  'hotline': instance.hotline,
  'ownerId': instance.ownerId,
  'openingTime': instance.openingTime,
  'closingTime': instance.closingTime,
  'selectedFeatureTagIds': instance.selectedFeatureTagIds,
  'mediaUrls': instance.mediaUrls,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
};
