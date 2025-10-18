import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:equatable/equatable.dart';

class WishlistModel extends Equatable {
  final String userId;
  final List<CafeModel> favoriteCafes;

  const WishlistModel({
    required this.userId,
    required this.favoriteCafes,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      userId: json['userId'] as String,
      favoriteCafes: (json['favoriteCafes'] as List<dynamic>)
          .map((cafe) => CafeModel.fromJson(cafe))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'favoriteCafes': favoriteCafes.map((cafe) => cafe.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [userId, favoriteCafes];
}

class WishlistResponse extends Equatable {
  final bool isSuccess;
  final WishlistModel? data;

  const WishlistResponse({
    required this.isSuccess,
    this.data,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      isSuccess: json['isSuccess'] as bool,
      data: json['data'] != null ? WishlistModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'data': data?.toJson(),
    };
  }

  @override
  List<Object?> get props => [isSuccess, data];
}
