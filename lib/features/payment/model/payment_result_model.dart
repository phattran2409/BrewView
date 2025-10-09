import 'package:json_annotation/json_annotation.dart';

part 'payment_result_model.g.dart';

@JsonSerializable()
class PaymentResultModel {
  final String id;
  final String subscriptionId;
  final String status; // pending, completed, failed, cancelled
  final double amount;
  final String currency;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? transactionId;
  final String? failureReason;

  const PaymentResultModel({
    required this.id,
    required this.subscriptionId,
    required this.status,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.createdAt,
    this.completedAt,
    this.transactionId,
    this.failureReason,
  });

  factory PaymentResultModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResultModelToJson(this);

  // Helper methods
  bool get isSuccess => status == 'completed';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';
  bool get isCancelled => status == 'cancelled';

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Đang xử lý';
      case 'completed':
        return 'Thành công';
      case 'failed':
        return 'Thất bại';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  String get formattedAmount => '${amount.toStringAsFixed(0)} $currency';
}

