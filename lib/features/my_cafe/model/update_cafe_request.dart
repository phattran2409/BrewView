import 'package:briewview/features/my_cafe/model/cafe_model.dart';

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
  final String? hotline;
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
    this.hotline,
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
      'hotline': hotline,
      'mediaIdsToDelete': mediaIdsToDelete,
      'cafeFeatureTags': cafeFeatureTags,
    };
  }

  factory UpdateCafeRequest.fromCafeModel(CafeModel cafe) {
    return UpdateCafeRequest(
      cafeId: cafe.id ?? '',
      categoryId: cafe.categoryId,
      name: cafe.name,
      address: cafe.address,
      description: cafe.description,
      priceMin: cafe.priceMin,
      priceMax: cafe.priceMax,
      openingTime: cafe.openingTime,
      closingTime: cafe.closingTime,
      linkPage: cafe.linkPage,
      hotline: cafe.hotline,
      cafeFeatureTags: cafe.selectedFeatureTagIds ?? [],
    );
  }
}
