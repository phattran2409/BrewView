// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentErrorModel _$PaymentErrorModelFromJson(Map<String, dynamic> json) =>
    PaymentErrorModel(
      type: json['type'] as String,
      title: json['title'] as String,
      status: (json['status'] as num).toInt(),
      detail: json['detail'] as String,
      traceId: json['traceId'] as String,
    );

Map<String, dynamic> _$PaymentErrorModelToJson(PaymentErrorModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'status': instance.status,
      'detail': instance.detail,
      'traceId': instance.traceId,
    };
