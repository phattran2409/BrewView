import 'package:json_annotation/json_annotation.dart';

part 'feature_tag_model.g.dart';

@JsonSerializable()
class FeatureTagModel {
  final int id;
  final String name;
  final String? description;
  final String? iconUrl;

  FeatureTagModel({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
  });

  factory FeatureTagModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureTagModelToJson(this);
}
