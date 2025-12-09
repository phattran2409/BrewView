import 'dart:io';

abstract class ReviewEvent {}

class LoadReviews extends ReviewEvent {
  final String cafeId;
  final int page;
  final int size;
  final bool isRefresh;
  LoadReviews({required this.cafeId, this.page = 1, this.size = 10 ,  this.isRefresh = false});
}
class LoadMoreReviews extends ReviewEvent {
   final String cafeId;
  final int page;
  LoadMoreReviews({required this.cafeId, required this.page});
}

class RefreshReviews extends ReviewEvent {
  final String cafeId;
  
  RefreshReviews({required this.cafeId});
}

class SubmitReview extends ReviewEvent {
  final String cafeId;
  final int rating;
  final String content;
  final List<File> medias;
  SubmitReview({
    required this.cafeId,
    required this.rating,
    required this.content,
    this.medias = const [], 
  });
}

