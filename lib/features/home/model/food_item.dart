class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> categories;
  final List<String> ingredients;
  final bool isAvailable;
  final bool isFavorite;
  final int preparationTime; // in minutes
  final double? discountPercentage;
  final String? chefName;
  final Map<String, double>? nutritionInfo;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.categories,
    required this.ingredients,
    this.isAvailable = true,
    this.isFavorite = false,
    this.preparationTime = 30,
    this.discountPercentage,
    this.chefName,
    this.nutritionInfo,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      isFavorite: json['isFavorite'] ?? false,
      preparationTime: json['preparationTime'] ?? 30,
      discountPercentage: json['discountPercentage']?.toDouble(),
      chefName: json['chefName'],
      nutritionInfo:
          json['nutritionInfo'] != null
              ? Map<String, double>.from(json['nutritionInfo'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'categories': categories,
      'ingredients': ingredients,
      'isAvailable': isAvailable,
      'isFavorite': isFavorite,
      'preparationTime': preparationTime,
      'discountPercentage': discountPercentage,
      'chefName': chefName,
      'nutritionInfo': nutritionInfo,
    };
  }

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    List<String>? categories,
    List<String>? ingredients,
    bool? isAvailable,
    bool? isFavorite,
    int? preparationTime,
    double? discountPercentage,
    String? chefName,
    Map<String, double>? nutritionInfo,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      ingredients: ingredients ?? this.ingredients,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      preparationTime: preparationTime ?? this.preparationTime,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      chefName: chefName ?? this.chefName,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
    );
  }

  // Get formatted price with discount
  String get formattedPrice {
    if (discountPercentage != null && discountPercentage! > 0) {
      final discountedPrice = price * (1 - discountPercentage! / 100);
      return '\$${discountedPrice.toStringAsFixed(2)}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  // Get original price if discounted
  String? get originalPrice {
    if (discountPercentage != null && discountPercentage! > 0) {
      return '\$${price.toStringAsFixed(2)}';
    }
    return null;
  }

  // Get formatted review count
  String get formattedReviewCount {
    if (reviewCount >= 1000) {
      return '${(reviewCount / 1000).toStringAsFixed(1)}k';
    }
    return reviewCount.toString();
  }

  // Get formatted preparation time
  String get formattedPreparationTime {
    if (preparationTime < 60) {
      return '${preparationTime}min';
    }
    final hours = preparationTime ~/ 60;
    final minutes = preparationTime % 60;
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}min';
  }

  // Check if item is discounted
  bool get isDiscounted =>
      discountPercentage != null && discountPercentage! > 0;

  // Get discount amount
  double? get discountAmount {
    if (discountPercentage != null && discountPercentage! > 0) {
      return price * (discountPercentage! / 100);
    }
    return null;
  }

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, price: $price, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

