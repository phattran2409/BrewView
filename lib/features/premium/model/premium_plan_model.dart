import 'package:json_annotation/json_annotation.dart';

part 'premium_plan_model.g.dart';

@JsonSerializable()
class PremiumPlanModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int durationDays;
  final List<String> features;
  final bool isPopular;
  final String? originalPrice;
  final double? discountPercentage;

  const PremiumPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.durationDays,
    required this.features,
    required this.isPopular,
    this.originalPrice,
    this.discountPercentage,
  });

  factory PremiumPlanModel.fromJson(Map<String, dynamic> json) =>
      _$PremiumPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$PremiumPlanModelToJson(this);

  // Helper methods
  String get formattedPrice => '${price.toStringAsFixed(0)}';
  String get formattedDuration {
    if (durationDays >= 365) {
      return '${(durationDays / 365).toStringAsFixed(0)} năm';
    } else if (durationDays >= 30) {
      return '${(durationDays / 30).toStringAsFixed(0)} tháng';
    } else {
      return '$durationDays ngày';
    }
  }

  String get savingsText {
    if (discountPercentage != null && discountPercentage! > 0) {
      return 'Tiết kiệm ${discountPercentage!.toStringAsFixed(0)}%';
    }
    return '';
  }
}

