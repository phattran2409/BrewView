import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/cafe/repository/cafes_repository.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_event.dart';
import 'package:briewview/features/cafe/viewmodel/cafe_sate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CafeBloc extends Bloc<CafeEvent, CafeState> {
  final CafesRepository _cafeRepository;

  int _currentPage = 1;
  bool _hasNextPage = true;
  List<CafeModel> _allCafes = [];
  List<CafeModel> _recommendations = [];
  List<CafeModel> _nearbyCafes = [];
  List<CafeModel> _topRatedCafes = [];

  bool _isRecommendationsLoaded = false;
  bool _isNearbyCafesLoaded = false;
  bool _isTopRatedCafesLoaded = false;

  CafeBloc(this._cafeRepository) : super(CafeInitial()) {
    on<LoadCafes>(_onLoadCafes);
    on<LoadCafesRating>(_onLoadCafesRating);
    on<LoadCafesByDistance>(_onLoadCafesByDistance);
    on<LoadRecommendedCafes>(_onLoadRecommendedCafes);
    on<LoadMoreCafes>(_onLoadMoreCafes);
    on<SearchCafes>(_onSearchCafes);
    on<LoadCafeById>(_onLoadCafeById);
    on<RefreshCafes>(_onRefreshCafes);
  }

  void _emitCombinedState(Emitter<CafeState> emit) {
    emit(
      CombinedCafesLoaded(
        recommendations: _recommendations,
        nearbyCafes: _nearbyCafes,
        topRatedCafes: _topRatedCafes,
        isRecommendationsLoaded: _isRecommendationsLoaded,
        isNearbyCafesLoaded: _isNearbyCafesLoaded,
        isTopRatedCafesLoaded: _isTopRatedCafesLoaded,
      ),
    );
  }

  Future<void> _onLoadCafes(LoadCafes event, Emitter<CafeState> emit) async {
    emit(CafeLoading());

    final result = await _cafeRepository.getCafes(
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
    );

    result.fold((failure) => emit(CafeError(failure.message)), (cafes) {
      _recommendations = cafes;
      _isRecommendationsLoaded = true;
      _emitCombinedState(emit);
    });
  }
  Future<void> _onLoadRecommendedCafes(
    LoadRecommendedCafes event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());

    final result = await _cafeRepository.getRecommendedCafes(
      userId: event.userId,
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
    );

    result.fold((failure) => emit(CafeError(failure.message)), (cafes) {
      _recommendations = cafes;
      _isRecommendationsLoaded = true;
      _emitCombinedState(emit);
    });
  } 

  Future<void> _onLoadCafesRating(
    LoadCafesRating event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());

    final result = await _cafeRepository.getCafes(
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
      sortBy: event.sortBy ?? 'rating',
      sortDirection: event.sortDirection ?? 'Descending',
    );

    result.fold((failure) => emit(CafeError(failure.message)), (cafes) {
      _topRatedCafes = cafes;
      _isTopRatedCafesLoaded = true;
      _emitCombinedState(emit);
    });
  }

  Future<void> _onLoadCafesByDistance(
    LoadCafesByDistance event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());

    final result = await _cafeRepository.getCafes(
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
      sortBy: '',
    );

    result.fold((failure) => emit(CafeError(failure.message)), (cafes) {
      _nearbyCafes = cafes;
      _isNearbyCafesLoaded = true;
      _emitCombinedState(emit);
    });
  }

  Future<void> _onLoadMoreCafes(
    LoadMoreCafes event,
    Emitter<CafeState> emit,
  ) async {
    if (!_hasNextPage) return;

    emit(CafeLoadingMore(_allCafes));

    final result = await _cafeRepository.getCafes(
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
    );

    result.fold((failure) => emit(CafeError(failure.message)),
     (newCafes) {
      _allCafes.addAll(newCafes);
      _currentPage = event.pageNumber;
      _hasNextPage = newCafes.length == event.pageSize;

      emit(
        CafesLoaded(
          cafes: _allCafes,
          hasNextPage: _hasNextPage,
          currentPage: _currentPage,
          totalCount: _allCafes.length,
        ),
      );
    });
  }

  Future<void> _onSearchCafes(
    SearchCafes event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());

    final result = await _cafeRepository.getCafes(
      pageNumber: 1,
      pageSize: event.pageSize,
    );

    result.fold((failure) => emit(CafeError(failure.message)), (cafes) {
      _allCafes = cafes;
      _currentPage = 1;

      if (cafes.isEmpty) {
        emit(CafeEmpty('No cafes found for "${event.searchQuery}"'));
      } else {
        emit(
          CafesLoaded(
            cafes: cafes,
            hasNextPage: cafes.length == event.pageSize,
            currentPage: _currentPage,
            totalCount: cafes.length,
          ),
        );
      }
    });
  }

  Future<void> _onLoadCafeById(
    LoadCafeById event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());

    final result = await _cafeRepository.getCafesById(event.cafeId);

    result.fold(
      (failure) => emit(CafeError(failure.message)),
      (cafe) => emit(CafeDetailsLoaded(cafe)),
    );
  }

  Future<void> _onRefreshCafes(
    RefreshCafes event,
    Emitter<CafeState> emit,
  ) async {
    _allCafes.clear();
    _currentPage = 1;
    _hasNextPage = true;

    add(LoadCafes(pageNumber: 1, pageSize: 10));
  }
}
