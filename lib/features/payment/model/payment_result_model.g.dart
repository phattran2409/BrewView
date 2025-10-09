// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResultModel _$PaymentResultModelFromJson(Map<String, dynamic> json) =>
    PaymentResultModel(
      id: json['id'] as String,
      subscriptionId: json['subscriptionId'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod: json['paymentMethod'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt:
          json['completedAt'] == null
              ? null
              : DateTime.parse(json['completedAt'] as String),
      transactionId: json['transactionId'] as String?,
      failureReason: json['failureReason'] as String?,
    );

Map<String, dynamic> _$PaymentResultModelToJson(PaymentResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subscriptionId': instance.subscriptionId,
      'status': instance.status,
      'amount': instance.amount,
      'currency': instance.currency,
      'paymentMethod': instance.paymentMethod,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'transactionId': instance.transactionId,
      'failureReason': instance.failureReason,
    };
