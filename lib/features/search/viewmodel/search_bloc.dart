import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/cafe/repository/cafes_repository.dart';
import 'package:briewview/features/search/viewmodel/search_event.dart';
import 'package:briewview/features/search/viewmodel/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CafesRepository _cafesRepository;

  List<CafeModel> _allResults = [];
  String _currentQuery = '';
  int _currentPage = 1;
  bool _hasNextPage = true;

  SearchBloc(this._cafesRepository) : super(SearchInitial()) {
    on<InitializeSearch>(_onInitializeSearch);
    on<SearchCafesEvent>(_onSearchCafes);
    on<LoadMoreSearchResults>(_onLoadMoreSearchResults);
    on<ClearSearch>(_onClearSearch);
    on<FilterCafes>(_onFilterCafes);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onInitializeSearch(
    InitializeSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchInitial());
    _allResults.clear();
    _currentQuery = '';
    _currentPage = 1;
    _hasNextPage = true;
  }

  Future<void> _onSearchCafes(
    SearchCafesEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    _currentQuery = event.query;
    _currentPage = 1;

    try {
      final result = await _cafesRepository.getCafes(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
        searchTerm:  event.query,
        sortBy: 'name', // You can make this configurable
        sortDirection: 'Ascending',
      );

      result.fold((failure) => emit(SearchError(failure.message)), (cafes) {
        // Filter cafes based on search query (client-side filtering)
        // In a real app, you'd want server-side search
        final filteredCafes =
            cafes.where((cafe) {
              final query = event.query.toLowerCase();
              final name = cafe.name?.toLowerCase() ?? '';
              final address = cafe.address?.toLowerCase() ?? '';
              final description = cafe.description?.toLowerCase() ?? '';

              return name.contains(query) ||
                  address.contains(query) ||
                  description.contains(query);
            }).toList();

        _allResults = filteredCafes;
        _hasNextPage = filteredCafes.length == event.pageSize;

        if (filteredCafes.isEmpty) {
          emit(SearchEmpty(event.query));
        } else {
          emit(
            SearchLoaded(
              results: filteredCafes,
              query: event.query,
              hasNextPage: _hasNextPage,
              currentPage: _currentPage,
              totalCount: filteredCafes.length,
            ),
          );
        }
      });
    } catch (e) {
      emit(SearchError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResults event,
    Emitter<SearchState> emit,
  ) async {
    if (!_hasNextPage || state is! SearchLoaded) return;

    final currentState = state as SearchLoaded;
    emit(SearchLoadingMore(currentState.results));

    try {
      final result = await _cafesRepository.getCafes(
        pageNumber: event.pageNumber,
        pageSize: 20,
        sortBy: 'name',
        sortDirection: 'Ascending',
      );

      result.fold((failure) => emit(SearchError(failure.message)), (cafes) {
        // Filter new cafes based on current query
        final filteredCafes =
            cafes.where((cafe) {
              final query = event.query.toLowerCase();
              final name = cafe.name?.toLowerCase() ?? '';
              final address = cafe.address?.toLowerCase() ?? '';
              final description = cafe.description?.toLowerCase() ?? '';

              return name.contains(query) ||
                  address.contains(query) ||
                  description.contains(query);
            }).toList();

        _allResults.addAll(filteredCafes);
        _currentPage = event.pageNumber;
        _hasNextPage = filteredCafes.length == 20;

        emit(
          SearchLoaded(
            results: List.from(_allResults),
            query: event.query,
            hasNextPage: _hasNextPage,
            currentPage: _currentPage,
            totalCount: _allResults.length,
          ),
        );
      });
    } catch (e) {
      emit(SearchError('Lỗi tải thêm kết quả: $e'));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    _allResults.clear();
    _currentQuery = '';
    _currentPage = 1;
    _hasNextPage = true;
    emit(SearchInitial());
  }

  Future<void> _onFilterCafes(
    FilterCafes event,
    Emitter<SearchState> emit,
  ) async {
    if (state is! SearchLoaded) return;

    emit(SearchLoading());

    try {
      final result = await _cafesRepository.getCafes(
        pageNumber: 1,
        pageSize: 50, // Get more results for filtering
        sortBy: event.sortBy ?? 'name',
        sortDirection: event.sortDirection ?? 'Ascending',
      );

      result.fold((failure) => emit(SearchError(failure.message)), (cafes) {
        // Apply filters
        var filteredCafes =
            cafes.where((cafe) {
              // Search query filter
              if (_currentQuery.isNotEmpty) {
                final query = _currentQuery.toLowerCase();
                final name = cafe.name?.toLowerCase() ?? '';
                final address = cafe.address?.toLowerCase() ?? '';
                final description = cafe.description?.toLowerCase() ?? '';

                if (!(name.contains(query) ||
                    address.contains(query) ||
                    description.contains(query))) {
                  return false;
                }
              }

              // Price filter
              if (event.minPrice != null && cafe.priceMin != null) {
                if (cafe.priceMin! < event.minPrice!) return false;
              }
              if (event.maxPrice != null && cafe.priceMax != null) {
                if (cafe.priceMax! > event.maxPrice!) return false;
              }

              // Category filter
              if (event.categoryIds != null && event.categoryIds!.isNotEmpty) {
                if (cafe.categoryId == null ||
                    !event.categoryIds!.contains(cafe.categoryId)) {
                  return false;
                }
              }

              // Feature tags filter
              if (event.featureTagIds != null &&
                  event.featureTagIds!.isNotEmpty) {
                if (cafe.cafeFeatureTags == null ||
                    cafe.cafeFeatureTags!.isEmpty) {
                  return false;
                }

                final cafeTagIds =
                    cafe.cafeFeatureTags!.map((tag) => tag.tagId).toList();
                final hasMatchingTag = event.featureTagIds!.any(
                  (tagId) => cafeTagIds.contains(tagId),
                );

                if (!hasMatchingTag) return false;
              }

              return true;
            }).toList();

        _allResults = filteredCafes;

        if (filteredCafes.isEmpty) {
          emit(SearchEmpty(_currentQuery));
        } else {
          emit(
            SearchLoaded(
              results: filteredCafes,
              query: _currentQuery,
              hasNextPage: false, // Filtered results don't have pagination
              currentPage: 1,
              totalCount: filteredCafes.length,
              isFiltered: true,
            ),
          );
        }
      });
    } catch (e) {
      emit(SearchError('Lỗi tìm kiếm: $e'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<SearchState> emit,
  ) async {
    // Implement favorite toggle logic here
    // This would typically involve calling a favorites repository
    print('Toggling favorite for cafe: ${event.cafeId}');
  }
}
