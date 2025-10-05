import 'package:briewview/features/my_cafe/model/cafe_model.dart';

class CreateCafeRequest {
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
  final List<int> selectedFeatureTagIds;

  CreateCafeRequest({
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
      'linkPage': linkPage,
      'hotline': hotline,
      'ownerId': ownerId,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'selectedFeatureTagIds': selectedFeatureTagIds,
    };
  }

  factory CreateCafeRequest.fromCafeModel(CafeModel cafe) {
    return CreateCafeRequest(
      categoryId: cafe.categoryId,
      name: cafe.name,
      address: cafe.address,
      description: cafe.description,
      priceMin: cafe.priceMin,
      priceMax: cafe.priceMax,
      linkPage: cafe.linkPage,
      hotline: cafe.hotline,
      ownerId: cafe.ownerId,
      openingTime: cafe.openingTime,
      closingTime: cafe.closingTime,
      selectedFeatureTagIds: cafe.selectedFeatureTagIds ?? [],
    );
  }
}
