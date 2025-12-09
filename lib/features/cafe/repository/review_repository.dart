import 'dart:io';

import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/features/cafe/model/review.dart';
import 'package:dartz/dartz.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<Review>>> getReviews({
    required String cafeId,
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, Map<String, dynamic>>> createReview({
    required String cafeId,
    required int rating,
    required String content,
    List<File> medias,
  });
}
  