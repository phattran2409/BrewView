import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: 'categoryId')
  final int categoryId;
  final String name;

  CategoryModel({
    required this.categoryId,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  String toString() {
    return 'CategoryModel(categoryId: $categoryId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel &&
        other.categoryId == categoryId &&
        other.name == name;
  }

  @override
  int get hashCode => categoryId.hashCode ^ name.hashCode;
}
