import 'dart:io';

import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/features/cafe/model/review.dart';
import 'package:briewview/features/cafe/repository/review_repository.dart';
import 'package:briewview/features/cafe/services/review_service.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReviewRepository)
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewService _service;
  ReviewRepositoryImpl(this._service);

  @override
  Future<Either<Failure, List<Review>>> getReviews({
    required String cafeId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final res = await _service.getReviews(
        cafeId: cafeId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      // Chỉ trả về error nếu là trang đầu tiên và không có reviews
      if (res.isEmpty && pageNumber == 1) {
        return Left(ServerFailure('No reviews found'));
      }

      // Với load more, trả về danh sách rỗng để UI có thể xử lý
      return Right(res.whereType<Review>().toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure,  Map<String, dynamic>>> createReview({
    required String cafeId,
    required int rating,
    required String content,
    List<File>  medias = const [] ,
  }) async {
    try {
      final res = await _service.createReview(
        cafeId: cafeId,
        rating: rating,
        content: content,
        medias: medias,
      );
     var dataJson = res;
      if (dataJson['isSuccess'] == true && dataJson['data'] != null) {
        var reviewData = dataJson['data'] as Map<String, dynamic>;   
        return Right(reviewData);
      } else {
        return Left(ServerFailure(dataJson['message'] ?? 'Failed to create review'));
      }   

    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
