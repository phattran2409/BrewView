import 'package:briewview/features/survey/model/category_model.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';


abstract class SurveyRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<FeatureTagModel>> getFeatureTags();
  Future<bool> submitUserPreferences({
    required String userId,
    required List<int> categoryIds,
    required List<int> featureTagIds,
  });
}
