import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:briewview/features/survey/model/category_model.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';
import 'package:briewview/features/survey/model/user_preferred_category_model.dart';
import 'package:briewview/features/survey/model/user_preferred_feature_tag_model.dart';
import '../services/survey_service.dart';
import 'survey_repository.dart';

@Singleton(as: SurveyRepository)
class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyService _surveyService;

  SurveyRepositoryImpl(this._surveyService);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      return await _surveyService.getCategories();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<List<FeatureTagModel>> getFeatureTags() async {
    try {
      return await _surveyService.getFeatureTags();
    } catch (e) {
      throw Exception('Failed to get feature tags: $e');
    }
  }

  @override
  Future<bool> submitUserPreferences({
    required String userId,
    required List<UserPreferredCategoryModel> preferredCategories,
    required List<UserPreferredFeatureTagModel> preferredFeatureTags,
  }) async {
    try {
      return await _surveyService.submitUserPreferences(
        userId: userId,
        preferredCategories: preferredCategories,
        preferredFeatureTags: preferredFeatureTags,
      );
    } catch (e) {
      throw Exception('Failed to submit user preferences: $e');
    }
  }
}
