// lib/features/cafe/viewmodel/cafe_state.dart
import 'package:briewview/features/cafe/model/cafeMode.dart';

abstract class CafeState {}

class CafeInitial extends CafeState {}

class CafeLoading extends CafeState {}

class CafeLoadingMore extends CafeState {
  final List<CafeModel> currentCafes;

  CafeLoadingMore(this.currentCafes);
}

class CafesLoaded extends CafeState {
  final List<CafeModel> cafes;
  final bool hasNextPage;
  final int currentPage;
  final int totalCount;

  CafesLoaded({
    required this.cafes,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalCount,
  });
}

class CafesRatingLoaded extends CafeState {
  final List<CafeModel> cafes;
  final int currentPage;
  final int totalCount;

  CafesRatingLoaded({
    required this.cafes,
    required this.currentPage,
    required this.totalCount,
  });
}

class CafesByDistanceLoaded extends CafeState {
  final List<CafeModel> cafes;
  final int currentPage;
  final int totalCount;

  CafesByDistanceLoaded({
    required this.cafes,
    required this.currentPage,
    required this.totalCount,
  });
}

class CombinedCafesLoaded extends CafeState {
  final List<CafeModel> recommendations;
  final List<CafeModel> nearbyCafes;
  final List<CafeModel> topRatedCafes;
  final bool isRecommendationsLoaded;
  final bool isNearbyCafesLoaded;
  final bool isTopRatedCafesLoaded;

  CombinedCafesLoaded({
    required this.recommendations,
    required this.nearbyCafes,
    required this.topRatedCafes,
    required this.isRecommendationsLoaded,
    required this.isNearbyCafesLoaded,
    required this.isTopRatedCafesLoaded,
  });
  
  bool get isAllDataLoaded => 
    isRecommendationsLoaded && isNearbyCafesLoaded && isTopRatedCafesLoaded;
}

class CafeDetailsLoaded extends CafeState {
  final CafeModel cafe;

  CafeDetailsLoaded(this.cafe);
}

class CafeError extends CafeState {
  final String message;

  CafeError(this.message);
}

class CafeEmpty extends CafeState {
  final String message;

  CafeEmpty([this.message = 'No cafes found']);
}

// New CRUD States for my_cafe feature
class MyCafesLoading extends CafeState {}

class MyCafesLoaded extends CafeState {
  final List<CafeModel> cafes;

  MyCafesLoaded(this.cafes);
}

class MyCafesEmpty extends CafeState {
  final String message;

  MyCafesEmpty([this.message = 'No cafes found']);
}

class CafeCreating extends CafeState {}

class CafeCreated extends CafeState {
  final CafeModel cafe;

  CafeCreated(this.cafe);
}

class CafeUpdating extends CafeState {}

class CafeUpdated extends CafeState {
  final CafeModel cafe;

  CafeUpdated(this.cafe);
}

class CafeDeleting extends CafeState {}

class CafeDeleted extends CafeState {
  final String cafeId;

  CafeDeleted(this.cafeId);
}

class CafeOperationError extends CafeState {
  final String message;

  CafeOperationError(this.message);
}