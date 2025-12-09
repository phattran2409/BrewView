import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionModel {
  final String id;
  final String userId;
  final String planId;
  final String status; // active, expired, cancelled
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? nextBillingDate;
  final String paymentMethod;
  final double amount;
  final String currency;
  final bool isAutoRenew;

  const SubscriptionModel({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.nextBillingDate,
    required this.paymentMethod,
    required this.amount,
    required this.currency,
    required this.isAutoRenew,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  // Helper methods
  bool get isActive => status == 'active' && DateTime.now().isBefore(endDate);
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isCancelled => status == 'cancelled';

  String get statusText {
    switch (status) {
      case 'active':
        return 'Đang hoạt động';
      case 'expired':
        return 'Đã hết hạn';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }
}

