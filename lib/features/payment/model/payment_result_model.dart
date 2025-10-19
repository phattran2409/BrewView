import 'package:json_annotation/json_annotation.dart';

part 'payment_result_model.g.dart';

@JsonSerializable()
class PaymentResultModel {
  final String subscriptionId;
  final int orderCode;
  final String paymentUrl;
  final String qrCode;

  const PaymentResultModel({
    required this.subscriptionId,
    required this.orderCode,
    required this.paymentUrl,
    required this.qrCode,
  });

  factory PaymentResultModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResultModelToJson(this);

  // Helper methods
  bool get hasQrCode => qrCode.isNotEmpty;
  
  bool get hasPaymentUrl => paymentUrl.isNotEmpty;
  
  String get displayOrderCode => '#$orderCode';
  
  // Copy with method for state management
  PaymentResultModel copyWith({
    String? subscriptionId,
    int? orderCode,
    String? paymentUrl,
    String? qrCode,
  }) {
    return PaymentResultModel(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      orderCode: orderCode ?? this.orderCode,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentResultModel &&
        other.subscriptionId == subscriptionId &&
        other.orderCode == orderCode &&
        other.paymentUrl == paymentUrl &&
        other.qrCode == qrCode;
  }

  @override
  int get hashCode {
    return subscriptionId.hashCode ^
        orderCode.hashCode ^
        paymentUrl.hashCode ^
        qrCode.hashCode;
  }

  @override
  String toString() {
    return 'PaymentResultModel(subscriptionId: $subscriptionId, orderCode: $orderCode, paymentUrl: $paymentUrl, qrCode: $qrCode)';
  }
}

