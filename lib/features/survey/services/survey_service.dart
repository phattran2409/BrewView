import 'package:briewview/core/network/user_storage_services.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/features/survey/model/category_model.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';


@singleton
class SurveyService {
  final Dio _dio;
  SurveyService(this._dio);

  // Fetch all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(AppConstants.categoriesEndpoint);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['isSuccess'] == true && data['data'] != null) {
          final responseData = data['data'];
          final List<dynamic> categoriesJson = responseData['categories'];
          return categoriesJson
              .map((json) => CategoryModel.fromJson(json))
              .toList();
        }
      }

      // Return mock data if API fails
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      // Return mock data on error
      return [];
    }
  }

  // Fetch all feature tags
  Future<List<FeatureTagModel>> getFeatureTags() async {
    try {
      final response = await _dio.get(AppConstants.featureTagsEndpoint);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['isSuccess'] == true && data['data'] != null) {
          final responseData = data['data'];
          final List<dynamic> featureTagsJson = responseData['featureTags'];
          return featureTagsJson
              .map((json) => FeatureTagModel.fromJson(json))
              .toList();
        }
      }

      // Return mock data if API fails
      return [];
    } catch (e) {
      print('Error fetching feature tags: $e');
      // Return mock data on error
      return [];
    }
  }

  // Submit user preferences
  Future<bool> submitUserPreferences({
    required String userId,
    required List<int> categoryIds,
    required List<int> featureTagIds,
  }) async {
    try {

      final response = await _dio.post(
        AppConstants.getUserPreferencesEndpoint(userId),
        data: {
          'preferenceCategoryIds': categoryIds,
          'preferenceFeatureTagIds': featureTagIds,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        return data['isSuccess'] == true;
      }

      return false;
    } catch (e) {
      print('Error submitting user preferences: $e');
      return false;
    }
  }
}
