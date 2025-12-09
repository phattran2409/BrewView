import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoadingMore extends SearchState {
  final List<CafeModel> currentResults;

  SearchLoadingMore(this.currentResults);

  @override
  List<Object?> get props => [currentResults];
}

class SearchLoaded extends SearchState {
  final List<CafeModel> results;
  final String query;
  final bool hasNextPage;
  final int currentPage;
  final int totalCount;
  final bool isFiltered;

  SearchLoaded({
    required this.results,
    required this.query,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalCount,
    this.isFiltered = false,
  });

  @override
  List<Object?> get props => [
    results,
    query,
    hasNextPage,
    currentPage,
    totalCount,
    isFiltered,
  ];

  SearchLoaded copyWith({
    List<CafeModel>? results,
    String? query,
    bool? hasNextPage,
    int? currentPage,
    int? totalCount,
    bool? isFiltered,
  }) {
    return SearchLoaded(
      results: results ?? this.results,
      query: query ?? this.query,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      isFiltered: isFiltered ?? this.isFiltered,
    );
  }
}

class SearchEmpty extends SearchState {
  final String query;

  SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
