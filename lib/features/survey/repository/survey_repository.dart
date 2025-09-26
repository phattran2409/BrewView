import 'package:briewview/features/survey/model/category_model.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';
import 'package:briewview/features/survey/model/user_preferred_category_model.dart';
import 'package:briewview/features/survey/model/user_preferred_feature_tag_model.dart';

abstract class SurveyRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<FeatureTagModel>> getFeatureTags();
  Future<bool> submitUserPreferences({
    required String userId,
    required List<UserPreferredCategoryModel> preferredCategories,
    required List<UserPreferredFeatureTagModel> preferredFeatureTags,
  });
}
