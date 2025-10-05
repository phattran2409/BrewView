import 'package:json_annotation/json_annotation.dart';

part 'cafe_model.g.dart';

@JsonSerializable()
class CafeModel {
  final String? id;
  final int categoryId;
  final String name;
  final String address;
  final String description;
  final int priceMin;
  final int priceMax;
  final String? linkPage;
  final String? hotline;
  final String? ownerId;
  final String openingTime;
  final String closingTime;
  final List<int>? selectedFeatureTagIds;
  final List<String>? mediaUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? rating;
  final int? reviewCount;

  CafeModel({
    this.id,
    required this.categoryId,
    required this.name,
    required this.address,
    required this.description,
    required this.priceMin,
    required this.priceMax,
    this.linkPage,
    this.hotline,
    this.ownerId,
    required this.openingTime,
    required this.closingTime,
    this.selectedFeatureTagIds,
    this.mediaUrls,
    this.createdAt,
    this.updatedAt,
    this.rating,
    this.reviewCount,
  });

  factory CafeModel.fromJson(Map<String, dynamic> json) =>
      _$CafeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CafeModelToJson(this);

  CafeModel copyWith({
    String? id,
    int? categoryId,
    String? name,
    String? address,
    String? description,
    int? priceMin,
    int? priceMax,
    String? linkPage,
    String? hotline,
    String? ownerId,
    String? openingTime,
    String? closingTime,
    List<int>? selectedFeatureTagIds,
    List<String>? mediaUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    int? reviewCount,
  }) {
    return CafeModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      linkPage: linkPage ?? this.linkPage,
      hotline: hotline ?? this.hotline,
      ownerId: ownerId ?? this.ownerId,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      selectedFeatureTagIds: selectedFeatureTagIds ?? this.selectedFeatureTagIds,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}
