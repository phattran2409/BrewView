import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:dartz/dartz.dart';

abstract class CafesRepository {
  Future<Either<Failure, List<CafeModel>>> getCafes({
    int pageNumber = 1,
    int pageSize = 10, 
    String? searchTerm,
    String? sortBy,
    String? sortDirection,
  });
  Future<Either<Failure, List<CafeModel>>> getRecommendedCafes({
    required String userId,
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, CafeModel>> getCafesById(String cafeId);
}
