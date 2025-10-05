import 'package:briewview/features/my_cafe/model/cafe_model.dart';
import 'package:briewview/features/my_cafe/model/category_model.dart';
import 'package:briewview/features/my_cafe/model/feature_tag_model.dart';
import 'package:briewview/features/my_cafe/model/create_cafe_request.dart';
import 'package:briewview/features/my_cafe/model/update_cafe_request.dart';
import 'dart:io';

abstract class MyCafeRepository {
  Future<List<CafeModel>> getMyCafes();
  Future<CafeModel> getCafeById(String cafeId);
  Future<CafeModel> createCafe(CreateCafeRequest request, List<File>? mediaFiles);
  Future<CafeModel> updateCafe(UpdateCafeRequest request, List<File>? mediaFiles);
  Future<void> deleteCafe(String cafeId);
  Future<List<CategoryModel>> getCategories();
  Future<List<FeatureTagModel>> getFeatureTags();
}
