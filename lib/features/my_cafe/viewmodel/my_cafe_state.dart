import 'package:briewview/features/my_cafe/model/cafe_model.dart';
import 'package:briewview/features/my_cafe/model/category_model.dart';
import 'package:briewview/features/my_cafe/model/feature_tag_model.dart';

abstract class MyCafeState {}

// Initial state
class MyCafeInitial extends MyCafeState {}

// Loading states
class MyCafeLoading extends MyCafeState {}

class MyCafeCreating extends MyCafeState {}

class MyCafeUpdating extends MyCafeState {}

class MyCafeDeleting extends MyCafeState {}

// Success states
class MyCafesLoaded extends MyCafeState {
  final List<CafeModel> cafes;
  MyCafesLoaded(this.cafes);
}

class CafeLoaded extends MyCafeState {
  final CafeModel cafe;
  CafeLoaded(this.cafe);
}

class CategoriesLoaded extends MyCafeState {
  final List<CategoryModel> categories;
  CategoriesLoaded(this.categories);
}

class FeatureTagsLoaded extends MyCafeState {
  final List<FeatureTagModel> featureTags;
  FeatureTagsLoaded(this.featureTags);
}

class CafeCreated extends MyCafeState {
  final CafeModel cafe;
  CafeCreated(this.cafe);
}

class CafeUpdated extends MyCafeState {
  final CafeModel cafe;
  CafeUpdated(this.cafe);
}

class CafeDeleted extends MyCafeState {
  final String cafeId;
  CafeDeleted(this.cafeId);
}

// Error state
class MyCafeError extends MyCafeState {
  final String message;
  MyCafeError(this.message);
}
