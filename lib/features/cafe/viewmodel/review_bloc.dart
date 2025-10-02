import 'package:briewview/features/cafe/repository/review_repository.dart';
import 'package:briewview/features/cafe/viewmodel/review_event.dart';
import 'package:briewview/features/cafe/viewmodel/review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _repo;
  List reviewsCache = [];
  int _currentPage = 1;
  bool _hasNext = true;

  ReviewBloc(this._repo) : super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<SubmitReview>(_onSubmit);
    on<LoadMoreReviews>(_onLoadMoreReviews);
    on<RefreshReviews>(_onRefreshReviews);
  }

  Future<void> _onLoadReviews(
    LoadReviews event,
    Emitter<ReviewState> emit,
  ) async {
    // Chỉ load trang đầu tiên, nếu page > 1 thì chuyển sang load more
    if (event.page > 1) {
      await _onLoadMoreReviews(
        LoadMoreReviews(cafeId: event.cafeId, page: event.page),
        emit,
      );
      return;
    }

    emit(ReviewLoading());

    final res = await _repo.getReviews(
      cafeId: event.cafeId,
      pageNumber: event.page,
      pageSize: event.size,
    );

    res.fold((failure) => emit(ReviewError(failure.toString())), (reviews) {
      _currentPage = event.page;
      _hasNext = reviews.length == event.size;  
      reviewsCache = List.from(reviews);

      emit(
        ReviewLoaded(
          reviews: reviews,
          currentPage: _currentPage,
          hasNextPage: _hasNext,
        ),
      );
    });
  }

  Future<void> _onLoadMoreReviews(
    LoadMoreReviews event,
    Emitter<ReviewState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ReviewLoaded) return;

    // Emit loading more state
    emit(
      ReviewLoadMore(
        reviews: currentState.reviews,
        currentPage: currentState.currentPage,
        hasNextPage: currentState.hasNextPage,
      ),
    );

    final result = await _repo.getReviews(
      cafeId: event.cafeId,
      pageNumber: event.page,
      pageSize: 10,
    );

    result.fold((failure) => emit(ReviewError(failure.toString())), (
      newReviews,
    ) {
      // Update cache and page info
      _currentPage = event.page;
      // hasNextPage = true nếu số reviews mới trả về bằng pageSize (có thể còn trang tiếp theo)
      _hasNext = newReviews.length == 10;

      // Combine old + new reviews
      final allReviews = [...currentState.reviews, ...newReviews];
      reviewsCache = List.from(allReviews);

      emit(
        ReviewLoaded(
          reviews: allReviews,
          currentPage: _currentPage,
          hasNextPage: _hasNext,
        ),
      );
    });
  }

  Future<void> _onRefreshReviews(
    RefreshReviews event,
    Emitter<ReviewState> emit,
  ) async {
    await _onLoadReviews(LoadReviews(cafeId: event.cafeId, page: 1), emit);
  }

  Future<void> _onSubmit(SubmitReview event, Emitter<ReviewState> emit) async {
    emit(ReviewSubmitting());
    final res = await _repo.createReview(
      cafeId: event.cafeId,
      rating: event.rating,
      content: event.content,
      medias: event.medias,
    );
    res.fold((err) => emit(ReviewError(err.message)), (review) {
      emit(ReviewSubmitted(true));
      emit(
        ReviewLoaded(
          reviews: List.from(reviewsCache),
          hasNextPage: _hasNext,
          currentPage: _currentPage,
        ),
      );
    });
  }
}
