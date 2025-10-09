// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    PaymentMethodModel(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      lastFourDigits: json['lastFourDigits'] as String?,
      expiryDate: json['expiryDate'] as String?,
      brand: json['brand'] as String?,
      isDefault: json['isDefault'] as bool,
      iconUrl: json['iconUrl'] as String?,
    );

Map<String, dynamic> _$PaymentMethodModelToJson(PaymentMethodModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'lastFourDigits': instance.lastFourDigits,
      'expiryDate': instance.expiryDate,
      'brand': instance.brand,
      'isDefault': instance.isDefault,
      'iconUrl': instance.iconUrl,
    };
