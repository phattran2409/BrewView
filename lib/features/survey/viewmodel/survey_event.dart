import 'package:briewview/features/survey/model/category_model.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';

abstract class SurveyEvent {}

class LoadCategories extends SurveyEvent {}

class LoadFeatureTags extends SurveyEvent {}

class ToggleCategorySelection extends SurveyEvent {
  final CategoryModel category;

  ToggleCategorySelection(this.category);
}

class ToggleFeatureTagSelection extends SurveyEvent {
  final FeatureTagModel featureTag;

  ToggleFeatureTagSelection(this.featureTag);
}

class SubmitSurvey extends SurveyEvent {
   SubmitSurvey();

  @override
  List<Object?> get props => [];
}

class ClearError extends SurveyEvent {}

class ResetSurvey extends SurveyEvent {}
