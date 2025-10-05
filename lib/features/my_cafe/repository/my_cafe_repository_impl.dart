import 'package:briewview/features/my_cafe/model/cafe_model.dart';
import 'package:briewview/features/my_cafe/model/category_model.dart';
import 'package:briewview/features/my_cafe/model/feature_tag_model.dart';
import 'package:briewview/features/my_cafe/model/create_cafe_request.dart';
import 'package:briewview/features/my_cafe/model/update_cafe_request.dart';
import 'package:briewview/features/my_cafe/repository/my_cafe_repository.dart';
import 'package:briewview/features/my_cafe/services/my_cafe_service.dart';
import 'dart:io';

import 'package:injectable/injectable.dart';

@LazySingleton(as: MyCafeRepository)
class MyCafeRepositoryImpl implements MyCafeRepository {
  final MyCafeService _myCafeService;

  MyCafeRepositoryImpl(this._myCafeService);

  @override
  Future<List<CafeModel>> getMyCafes() async {
    return await _myCafeService.getMyCafes();
  }

  @override
  Future<CafeModel> getCafeById(String cafeId) async {
    return await _myCafeService.getCafeById(cafeId);
  }

  @override
  Future<CafeModel> createCafe(CreateCafeRequest request, List<File>? mediaFiles) async {
    return await _myCafeService.createCafe(request, mediaFiles);
  }

  @override
  Future<CafeModel> updateCafe(UpdateCafeRequest request, List<File>? mediaFiles) async {
    return await _myCafeService.updateCafe(request, mediaFiles);
  }

  @override
  Future<void> deleteCafe(String cafeId) async {
    return await _myCafeService.deleteCafe(cafeId);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    return await _myCafeService.getCategories();
  }

  @override
  Future<List<FeatureTagModel>> getFeatureTags() async {
    return await _myCafeService.getFeatureTags();
  }
}
