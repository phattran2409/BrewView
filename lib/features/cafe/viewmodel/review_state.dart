import 'package:briewview/features/cafe/model/review.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;
  final bool hasNextPage;
  final int currentPage;
  ReviewLoaded({
    required this.reviews,
    required this.hasNextPage,
    required this.currentPage,
  });
}

class ReviewLoadMore extends ReviewState {
  final List<Review> reviews;
  final int currentPage;
  final bool hasNextPage;
  ReviewLoadMore({
    required this.reviews,
    required this.currentPage,
    required this.hasNextPage,
  });
}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitted extends ReviewState {
  final bool isSuccess;
  ReviewSubmitted(this.isSuccess);
}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}
