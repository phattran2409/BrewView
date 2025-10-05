import 'package:briewview/core/network/user_storage_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:briewview/features/survey/model/category_model.dart';
import 'package:briewview/features/survey/model/feature_tag_model.dart';
import 'package:briewview/features/survey/repository/survey_repository.dart';
import 'survey_event.dart';
import 'survey_state.dart';

@injectable
class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SurveyRepository _repository;
  final UserStorageServices _userStorageServices;

  SurveyBloc(this._repository, this._userStorageServices) : super(SurveyInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadFeatureTags>(_onLoadFeatureTags);
    on<ToggleCategorySelection>(_onToggleCategorySelection);
    on<ToggleFeatureTagSelection>(_onToggleFeatureTagSelection);
    on<SubmitSurvey>(_onSubmitSurvey);
    on<ClearError>(_onClearError);
    on<ResetSurvey>(_onResetSurvey);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<SurveyState> emit,
  ) async {
    emit(CategoriesLoading());
    try {
      final categories = await _repository.getCategories();
      final currentState = state;
      
      if (currentState is SurveyLoaded) {
        emit(currentState.copyWith(
          categories: categories,
          errorMessage: null,
        ));
      } else {
        emit(SurveyLoaded(
          categories: categories,
          featureTags: [],
          selectedCategories: [],
          selectedFeatureTags: [],
        ));
      }
    } catch (e) {
      emit(SurveyError(
        message: 'Failed to load categories: $e',
        categories: state is SurveyLoaded ? (state as SurveyLoaded).categories : null,
        featureTags: state is SurveyLoaded ? (state as SurveyLoaded).featureTags : null,
        selectedCategories: state is SurveyLoaded ? (state as SurveyLoaded).selectedCategories : null,
        selectedFeatureTags: state is SurveyLoaded ? (state as SurveyLoaded).selectedFeatureTags : null,
      ));
    }
  }

  Future<void> _onLoadFeatureTags(
    LoadFeatureTags event,
    Emitter<SurveyState> emit,
  ) async {
    emit(FeatureTagsLoading());
    try {
      final featureTags = await _repository.getFeatureTags();
      final currentState = state;
      
      if (currentState is SurveyLoaded) {
        emit(currentState.copyWith(
          featureTags: featureTags,
          errorMessage: null,
        ));
      } else {
        emit(SurveyLoaded(
          categories: [],
          featureTags: featureTags,
          selectedCategories: [],
          selectedFeatureTags: [],
        ));
      }
    } catch (e) {
      emit(SurveyError(
        message: 'Failed to load feature tags: $e',
        categories: state is SurveyLoaded ? (state as SurveyLoaded).categories : null,
        featureTags: state is SurveyLoaded ? (state as SurveyLoaded).featureTags : null,
        selectedCategories: state is SurveyLoaded ? (state as SurveyLoaded).selectedCategories : null,
        selectedFeatureTags: state is SurveyLoaded ? (state as SurveyLoaded).selectedFeatureTags : null,
      ));
    }
  }

  void _onToggleCategorySelection(
    ToggleCategorySelection event,
    Emitter<SurveyState> emit,
  ) {
    final currentState = state;
    if (currentState is SurveyLoaded) {
      List<CategoryModel> updatedCategories = List.from(currentState.selectedCategories);
      
      if (updatedCategories.contains(event.category)) {
        updatedCategories.remove(event.category);
      } else {
        updatedCategories.add(event.category);
      }
      
      emit(currentState.copyWith(
        selectedCategories: updatedCategories,
        errorMessage: null,
      ));
    }
  }

  void _onToggleFeatureTagSelection(
    ToggleFeatureTagSelection event,
    Emitter<SurveyState> emit,
  ) {
    final currentState = state;
    if (currentState is SurveyLoaded) {
      List<FeatureTagModel> updatedFeatureTags = List.from(currentState.selectedFeatureTags);
      
      if (updatedFeatureTags.contains(event.featureTag)) {
        updatedFeatureTags.remove(event.featureTag);
      } else {
        updatedFeatureTags.add(event.featureTag);
      }
      
      emit(currentState.copyWith(
        selectedFeatureTags: updatedFeatureTags,
        errorMessage: null,
      ));
    }
  }

  Future<void> _onSubmitSurvey(
    SubmitSurvey event,
    Emitter<SurveyState> emit,
  ) async {
    final currentState = state;
    if (currentState is SurveyLoaded) {
      if (!currentState.canSubmitSurvey) {
        emit(currentState.copyWith(
          errorMessage: 'Please select at least one feature tag',
        ));
        return;
      }

      emit(SurveySubmitting(
        categories: currentState.categories,
        featureTags: currentState.featureTags,
        selectedCategories: currentState.selectedCategories,
        selectedFeatureTags: currentState.selectedFeatureTags,
      ));

      try {
        final currentUser = await _userStorageServices.getCurrentUser();
        if (currentUser?.id == null || currentUser!.id.isEmpty) {
          emit(SurveyError(message: 'Failed to submit survey. Please try again.'));
          return;
        }
       
        final categoryIds = currentState.selectedCategories
            .map((category) => category.categoryId)
            .toList();

        final featureTagIds = currentState.selectedFeatureTags
            .map((featureTag) => featureTag.tagId)
            .toList();


        final success = await _repository.submitUserPreferences(
          userId: currentUser.id,
          categoryIds: categoryIds,
          featureTagIds: featureTagIds,
        );

        if (success) {
          emit(SurveySubmitted(
            categories: currentState.categories,
            featureTags: currentState.featureTags,
            selectedCategories: currentState.selectedCategories,
            selectedFeatureTags: currentState.selectedFeatureTags,
          ));
        } else {
          emit(SurveyError(
            message: 'Failed to submit survey. Please try again.',
            categories: currentState.categories,
            featureTags: currentState.featureTags,
            selectedCategories: currentState.selectedCategories,
            selectedFeatureTags: currentState.selectedFeatureTags,
          ));
        }
      } catch (e) {
        emit(SurveyError(
          message: 'Error submitting survey: $e',
          categories: currentState.categories,
          featureTags: currentState.featureTags,
          selectedCategories: currentState.selectedCategories,
          selectedFeatureTags: currentState.selectedFeatureTags,
        ));
      }
    }
  }

  void _onClearError(
    ClearError event,
    Emitter<SurveyState> emit,
  ) {
    final currentState = state;
    if (currentState is SurveyLoaded) {
      emit(currentState.copyWith(errorMessage: null));
    } else if (currentState is SurveyError) {
      emit(SurveyLoaded(
        categories: currentState.categories ?? [],
        featureTags: currentState.featureTags ?? [],
        selectedCategories: currentState.selectedCategories ?? [],
        selectedFeatureTags: currentState.selectedFeatureTags ?? [],
      ));
    }
  }

  void _onResetSurvey(
    ResetSurvey event,
    Emitter<SurveyState> emit,
  ) {
    final currentState = state;
    if (currentState is SurveyLoaded) {
      emit(currentState.copyWith(
        selectedCategories: [],
        selectedFeatureTags: [],
        errorMessage: null,
      ));
    } else {
      emit(SurveyInitial());
    }
  }
}
