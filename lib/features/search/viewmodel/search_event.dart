abstract class SearchEvent {}

class InitializeSearch extends SearchEvent {}

class SearchCafesEvent extends SearchEvent {
  final String query;
  final int pageNumber;
  final int pageSize;

  SearchCafesEvent({
    required this.query,
    this.pageNumber = 1,
    this.pageSize = 20,
  });
}

class LoadMoreSearchResults extends SearchEvent {
  final String query;
  final int pageNumber;

  LoadMoreSearchResults({required this.query, required this.pageNumber});
}

class ClearSearch extends SearchEvent {}

class FilterCafes extends SearchEvent {
  final String? sortBy;
  final String? sortDirection;
  final double? minPrice;
  final double? maxPrice;
  final List<int>? categoryIds;
  final List<int>? featureTagIds;

  FilterCafes({
    this.sortBy,
    this.sortDirection,
    this.minPrice,
    this.maxPrice,
    this.categoryIds,
    this.featureTagIds,
  });
}

class ToggleFavorite extends SearchEvent {
  final String cafeId;

  ToggleFavorite(this.cafeId);
}
