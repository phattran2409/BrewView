import 'package:briewview/features/cafe/model/cafeMode.dart';

class CreateCafeRequest {
  final int categoryId;
  final String name;
  final String address;
  final String description;
  final int priceMin;
  final int priceMax;
  final String openingTime;
  final String closingTime;
  final String? linkPage;
  final String? hotLine;
  final List<int> selectedFeatureTagIds;

  CreateCafeRequest({
    required this.categoryId,
    required this.name,
    required this.address,
    required this.description,
    required this.priceMin,
    required this.priceMax,
    required this.openingTime,
    required this.closingTime,
    this.linkPage,
    this.hotLine,
    this.selectedFeatureTagIds = const [],
  });

    Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'address': address,
      'description': description,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'linkPage': linkPage,
      'hotLine': hotLine,
      'selectedFeatureTagIds': selectedFeatureTagIds,
    };
  }

   factory CreateCafeRequest.fromCafeModel(CafeModel cafe) {
    return CreateCafeRequest(
      categoryId: cafe.categoryId ?? 0,
      name: cafe.name ?? '',
      address: cafe.address ?? '',
      description: cafe.description ?? '',
      priceMin: cafe.priceMin ?? 0,
      priceMax: cafe.priceMax ?? 0,
      openingTime: cafe.openingTime ?? '',
      closingTime: cafe.closingTime ?? '',
      linkPage: cafe.linkPage,
      hotLine: cafe.hotLine,
      selectedFeatureTagIds:
          cafe.cafeFeatureTags?.map((tag) => tag.tagId).toList() ?? [],
    );
  }
}

class UpdateCafeRequest {
  final String cafeId;
  final int categoryId;
  final String name;
  final String address;
  final String description;
  final int priceMin;
  final int priceMax;
  final String openingTime;
  final String closingTime;
  final String? linkPage;
  final String? hotLine;
  final List<String>? mediaIdsToDelete;
  final List<int> cafeFeatureTags;

  UpdateCafeRequest({
    required this.cafeId,
    required this.categoryId,
    required this.name,
    required this.address,
    required this.description,
    required this.priceMin,
    required this.priceMax,
    required this.openingTime,
    required this.closingTime,
    this.linkPage,
    this.hotLine,
    this.mediaIdsToDelete,
    this.cafeFeatureTags = const [],
  });

Map<String, dynamic> toJson() {
    return {
      'cafeId': cafeId,
      'categoryId': categoryId,
      'name': name,
      'address': address,
      'description': description,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'linkPage': linkPage,
      'hotLine': hotLine,
      'mediaIdsToDelete': mediaIdsToDelete,
      'cafeFeatureTags': cafeFeatureTags,
    };
  }

  factory UpdateCafeRequest.fromCafeModel(CafeModel cafe) {
    return UpdateCafeRequest(
      cafeId: cafe.cafeId ?? '',
      categoryId: cafe.categoryId ?? 0,
      name: cafe.name ?? '',
      address: cafe.address ?? '',
      description: cafe.description ?? '',
      priceMin: cafe.priceMin ?? 0,
      priceMax: cafe.priceMax ?? 0,
      openingTime: cafe.openingTime ?? '',
      closingTime: cafe.closingTime ?? '',
      linkPage: cafe.linkPage,
      hotLine: cafe.hotLine,
      cafeFeatureTags: cafe.cafeFeatureTags?.map((tag) => tag.tagId).toList() ?? [],
    );
  }
}