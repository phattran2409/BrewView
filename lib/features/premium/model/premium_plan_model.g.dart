// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PremiumPlanModel _$PremiumPlanModelFromJson(Map<String, dynamic> json) =>
    PremiumPlanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      durationDays: (json['durationDays'] as num).toInt(),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      isPopular: json['isPopular'] as bool,
      originalPrice: json['originalPrice'] as String?,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PremiumPlanModelToJson(PremiumPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'durationDays': instance.durationDays,
      'features': instance.features,
      'isPopular': instance.isPopular,
      'originalPrice': instance.originalPrice,
      'discountPercentage': instance.discountPercentage,
    };
