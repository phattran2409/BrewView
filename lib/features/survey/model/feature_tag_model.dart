import 'package:json_annotation/json_annotation.dart';

part 'feature_tag_model.g.dart';

@JsonSerializable()
class FeatureTagModel {
  @JsonKey(name: 'tagId')
  final int tagId;
  final String name;

  FeatureTagModel({
    required this.tagId,
    required this.name,
  });

  factory FeatureTagModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureTagModelToJson(this);

  @override
  String toString() {
    return 'FeatureTagModel(tagId: $tagId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeatureTagModel &&
        other.tagId == tagId &&
        other.name == name;
  }

  @override
  int get hashCode => tagId.hashCode ^ name.hashCode;
}
