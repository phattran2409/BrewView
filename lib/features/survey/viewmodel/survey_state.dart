import 'package:briewview/features/survey/model/category_model.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';

abstract class SurveyState {}

class SurveyInitial extends SurveyState {}

class SurveyLoading extends SurveyState {}

class CategoriesLoading extends SurveyState {}

class FeatureTagsLoading extends SurveyState {}

class SurveyLoaded extends SurveyState {
  final List<CategoryModel> categories;
  final List<FeatureTagModel> featureTags;
  final List<CategoryModel> selectedCategories;
  final List<FeatureTagModel> selectedFeatureTags;
  final String? errorMessage;

  SurveyLoaded({
    required this.categories,
    required this.featureTags,
    required this.selectedCategories,
    required this.selectedFeatureTags,
    this.errorMessage,
  });

  SurveyLoaded copyWith({
    List<CategoryModel>? categories,
    List<FeatureTagModel>? featureTags,
    List<CategoryModel>? selectedCategories,
    List<FeatureTagModel>? selectedFeatureTags,
    String? errorMessage,
  }) {
    return SurveyLoaded(
      categories: categories ?? this.categories,
      featureTags: featureTags ?? this.featureTags,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedFeatureTags: selectedFeatureTags ?? this.selectedFeatureTags,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get canProceedToFeatureTags => selectedCategories.isNotEmpty;
  bool get canSubmitSurvey => selectedFeatureTags.isNotEmpty;
}

class CategoryLoaded extends SurveyState {
  final List<CategoryModel> categories;
  // final List<CategoryModel> selectedCategories;

  CategoryLoaded({
    required this.categories,
    // required this.selectedCategories,
  });
}

class FeatureTagLoaded extends SurveyState {
  final List<FeatureTagModel> featureTags;
  // final List<FeatureTagModel> selectedFeatureTags;

  FeatureTagLoaded({
    required this.featureTags,
    // required this.selectedFeatureTags,
  });
}

class SurveySubmitting extends SurveyState {
  final List<CategoryModel> categories;
  final List<FeatureTagModel> featureTags;
  final List<CategoryModel> selectedCategories;
  final List<FeatureTagModel> selectedFeatureTags;

  SurveySubmitting({
    required this.categories,
    required this.featureTags,
    required this.selectedCategories,
    required this.selectedFeatureTags,
  });
}

class SurveySubmitted extends SurveyState {
  final List<CategoryModel> categories;
  final List<FeatureTagModel> featureTags;
  final List<CategoryModel> selectedCategories;
  final List<FeatureTagModel> selectedFeatureTags;

  SurveySubmitted({
    required this.categories,
    required this.featureTags,
    required this.selectedCategories,
    required this.selectedFeatureTags,
  });
}

class SurveyError extends SurveyState {
  final String message;
  final List<CategoryModel>? categories;
  final List<FeatureTagModel>? featureTags;
  final List<CategoryModel>? selectedCategories;
  final List<FeatureTagModel>? selectedFeatureTags;

  SurveyError({
    required this.message,
    this.categories,
    this.featureTags,
    this.selectedCategories,
    this.selectedFeatureTags,
  });
}
