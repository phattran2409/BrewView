// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResultModel _$PaymentResultModelFromJson(Map<String, dynamic> json) =>
    PaymentResultModel(
      subscriptionId: json['subscriptionId'] as String,
      orderCode: (json['orderCode'] as num).toInt(),
      paymentUrl: json['paymentUrl'] as String,
      qrCode: json['qrCode'] as String,
    );

Map<String, dynamic> _$PaymentResultModelToJson(PaymentResultModel instance) =>
    <String, dynamic>{
      'subscriptionId': instance.subscriptionId,
      'orderCode': instance.orderCode,
      'paymentUrl': instance.paymentUrl,
      'qrCode': instance.qrCode,
    };
