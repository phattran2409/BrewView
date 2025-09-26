abstract class CafeEvent {}

class LoadCafes extends CafeEvent {
  final int pageNumber;
  final int pageSize;
  final String? search;
  final String? sortBy;
  final String? sortDirection;

  LoadCafes({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.search,
    this.sortBy,
    this.sortDirection,
  });
}

class LoadCafesRating extends CafeEvent {
  final int pageNumber;
  final int pageSize;
  final String? sortBy;
  final String? sortDirection;

  LoadCafesRating({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.sortBy,
    this.sortDirection,
  });
}

class LoadMoreCafes extends CafeEvent {
  final int pageNumber;
  final int pageSize;
  final String? search;
  final String? sortBy;

  LoadMoreCafes({
    required this.pageNumber,
    this.pageSize = 10,
    this.search,
    this.sortBy,
  });
}

class SearchCafes extends CafeEvent {
  final String searchQuery;
  final int pageSize;

  SearchCafes({required this.searchQuery, this.pageSize = 10});
}

class LoadCafeById extends CafeEvent {
  final String cafeId;

  LoadCafeById(this.cafeId);
}

class LoadCafesByDistance extends CafeEvent {
  final int pageNumber;
  final int pageSize;
  final String? sortBy;
  final String? sortDirection;

  LoadCafesByDistance({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.sortBy,
    this.sortDirection,
  });
}

class RefreshCafes extends CafeEvent {}

class LoadRecommendedCafes extends CafeEvent {
  final String userId;
  final int pageNumber;
  final int pageSize;

  LoadRecommendedCafes({
    required this.userId,
    this.pageNumber = 1,
    this.pageSize = 10,
  });
} 