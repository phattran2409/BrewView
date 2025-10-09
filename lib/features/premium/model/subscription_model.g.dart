// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      planId: json['planId'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      nextBillingDate:
          json['nextBillingDate'] == null
              ? null
              : DateTime.parse(json['nextBillingDate'] as String),
      paymentMethod: json['paymentMethod'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      isAutoRenew: json['isAutoRenew'] as bool,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'planId': instance.planId,
      'status': instance.status,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'nextBillingDate': instance.nextBillingDate?.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
      'amount': instance.amount,
      'currency': instance.currency,
      'isAutoRenew': instance.isAutoRenew,
    };
