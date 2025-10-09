import 'package:json_annotation/json_annotation.dart';

part 'payment_method_model.g.dart';

@JsonSerializable()
class PaymentMethodModel {
  final String id;
  final String type; // credit_card, debit_card, bank_transfer, e_wallet
  final String name;
  final String? lastFourDigits;
  final String? expiryDate;
  final String? brand; // visa, mastercard, etc.
  final bool isDefault;
  final String? iconUrl;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.name,
    this.lastFourDigits,
    this.expiryDate,
    this.brand,
    required this.isDefault,
    this.iconUrl,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);

  // Helper methods
  String get displayName {
    switch (type) {
      case 'credit_card':
      case 'debit_card':
        return '$brand ****$lastFourDigits';
      case 'bank_transfer':
        return 'Chuyển khoản ngân hàng';
      case 'e_wallet':
        return 'Ví điện tử';
      default:
        return name;
    }
  }

  String get typeText {
    switch (type) {
      case 'credit_card':
        return 'Thẻ tín dụng';
      case 'debit_card':
        return 'Thẻ ghi nợ';
      case 'bank_transfer':
        return 'Chuyển khoản';
      case 'e_wallet':
        return 'Ví điện tử';
      default:
        return name;
    }
  }
}

