import 'package:briewview/features/cafe/model/cafeMedia.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

class CafeModel extends Equatable {
  final String? cafeId;
  final int? categoryId;  
  final String? name;
  final String? address;
  final String? description;
  final double? distance;
  final int? priceMin;
  final int? priceMax;
  final String? openingTime;
  final String? closingTime;
  final String? hotline;
  final String? linkPage;
  final double? rating;
  final String? imageUrl;
  final String? videoUrl;
  final String? ownerId;
  final DateTime? createdAt;
  final String? createdById;
  final bool? isPromoted;
  final bool? status;
  // final List<String>? tags;
  final List<CafeMedias>? cafeMedias;
  final List<dynamic>? cafeCategories;
  final List<FeatureTagModel>? cafeFeatureTags;   

  const CafeModel({
    this.cafeId,
    this.categoryId,
    this.name,
    this.address,
    this.description,
    this.distance,
    this.priceMin,
    this.priceMax,
    this.openingTime,
    this.closingTime,
    this.hotline,
    this.linkPage,
    this.rating,
    this.imageUrl,
    this.videoUrl,
    this.ownerId,
    this.createdAt,
    this.createdById,
    this.isPromoted,
    this.status,
    this.cafeMedias,
    this.cafeCategories,
    this.cafeFeatureTags,
  });
  factory CafeModel.fromJson(Map<String, dynamic> json) {
    return CafeModel(
      cafeId: json['cafeId'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?, 
      distance: json['distance']?.toDouble(),
      priceMin: _parseInt(json['priceMin']),
      priceMax: _parseInt(json['priceMax']),
      openingTime: json['openingTime'] as String?,
      closingTime: json['closingTime'] as String?,
      hotline: json['hotline'] as String?,
      linkPage: json['linkPage'] as String?,
      rating: _parseDouble(json['rating']),
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      ownerId: json['ownerId'] as String?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      createdById: json['createdById'] as String?,
      isPromoted: json['isPromoted'] as bool?,
      status: json['status'] as bool?,
      cafeMedias:
          json['cafeMedias'] != null
              ? (json['cafeMedias'] as List)
                  .map((item) => CafeMedias.fromJson(item))
                  .toList()
              : null,
      cafeCategories: json['cafeCategories'] as List<dynamic>?,
      cafeFeatureTags: (json['cafeFeatureTags'] as List<dynamic>?)
          ?.map((item) => FeatureTagModel(
                tagId: item['tagId'] as int,
                name: item['tagName'] as String,
              ))
          .toList(),
      categoryId: _parseInt(json['categoryId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cafeId': cafeId,
      'name': name,
      'address': address,
      'description': description,
      'distance': distance,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'hotline': hotline,
      'linkPage': linkPage,
      'rating': rating,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'ownerId': ownerId,
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'isPromoted': isPromoted,
      'status': status,
      'cafeMedias': cafeMedias?.map((media) => media.toJson()).toList(),
      'cafeCategories': cafeCategories,
      'cafeFeatureTags': cafeFeatureTags?.map((tag) => tag.toJson()).toList(),
      'categoryId': categoryId,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is double) return value.toInt();
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  @override
  List<Object?> get props => [
    cafeId,
    categoryId,
    name,
    address,
    description,
    priceMin,
    priceMax,
    openingTime,
    closingTime,
    hotline,
    linkPage,
    rating,
    imageUrl,
    videoUrl,
    ownerId,
    createdAt,
    createdById,
    isPromoted,
    status,
    cafeMedias,
    cafeCategories,
    cafeFeatureTags,
  ];
}
