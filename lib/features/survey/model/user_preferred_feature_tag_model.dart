import 'package:json_annotation/json_annotation.dart';

part 'user_preferred_feature_tag_model.g.dart';

@JsonSerializable()
class UserPreferredFeatureTagModel {
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'featureTagId')
  final int featureTagId;

  UserPreferredFeatureTagModel({
    required this.userId,
    required this.featureTagId,
  });

  factory UserPreferredFeatureTagModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferredFeatureTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferredFeatureTagModelToJson(this);

  @override
  String toString() {
    return 'UserPreferredFeatureTagModel(userId: $userId, featureTagId: $featureTagId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferredFeatureTagModel &&
        other.userId == userId &&
        other.featureTagId == featureTagId;
  }

  @override
  int get hashCode => userId.hashCode ^ featureTagId.hashCode;
}
