import 'dart:ffi';

import 'package:briewview/features/cafe/model/cafeMedia.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CafeModel extends Equatable {
  String? cafeId;
  int? categoryId;  
  String? name;
  String? address;
  String? description;
  int? priceMin;
  int? priceMax;
  String? openingTime;
  String? closingTime;
  String? hotLine;
  String? linkPage;
  double? rating;
  String? imageUrl;
  String? videoUrl;
  String? ownerId;
  DateTime? createdAt;
  String? createdById;
  bool? isPromoted;
  bool? status;
  // final List<String>? tags;
  final List<CafeMedias>? cafeMedias;
  final List<dynamic>? cafeCategories;
  final List<int>? cafeFeatureTags;   

  CafeModel({
    this.cafeId,
    this.name,
    this.address,
    this.description,
    this.priceMin,
    this.priceMax,
    this.openingTime,
    this.closingTime,
    this.hotLine,
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
    this.categoryId,
  });
  factory CafeModel.fromJson(Map<String, dynamic> json) {
    return CafeModel(
      cafeId: json['cafeId'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      priceMin: _parseInt(json['priceMin']),
      priceMax: _parseInt(json['priceMax']),
      openingTime: json['openingTime'] as String?,
      closingTime: json['closingTime'] as String?,
      hotLine: json['hotLine'] as String?,
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
          ?.map((item) => item as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cafeId': cafeId,
      'name': name,
      'address': address,
      'description': description,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'hotLine': hotLine,
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
      'cafeFeatureTags': cafeFeatureTags,
    };
  }

  static int? _parseInt(dynamic? value) {
   if (value == null) return null;
    if (value is double) return value.toInt();
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
  }

  static double? _parseDouble(dynamic? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
  }

  @override
  List<Object?> get props => [
    cafeId,
    name,
    address,
    description,
    priceMin,
    priceMax,
    openingTime,
    closingTime,
    hotLine,
    linkPage,
    rating,
    imageUrl,
    videoUrl,
    ownerId,
    createdAt,
    createdById,
    isPromoted,
    status,
  ];
}
