import 'package:json_annotation/json_annotation.dart';

part 'user_preferred_category_model.g.dart';

@JsonSerializable()
class UserPreferredCategoryModel {
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'categoryId')
  final int categoryId;

  UserPreferredCategoryModel({
    required this.userId,
    required this.categoryId,
  });

  factory UserPreferredCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferredCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferredCategoryModelToJson(this);

  @override
  String toString() {
    return 'UserPreferredCategoryModel(userId: $userId, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferredCategoryModel &&
        other.userId == userId &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode => userId.hashCode ^ categoryId.hashCode;
}
