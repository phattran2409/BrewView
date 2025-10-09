import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/cafe/model/cafeMutation.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

abstract class CafesRepository {
  // Existing methods
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

  // New CRUD methods for my_cafe feature
  Future<Either<Failure, List<CafeModel>>> getMyCafes();
  
  Future<Either<Failure, CafeModel>> createCafe(
    CreateCafeRequest request, 
    List<File>? mediaFiles
  );
  
  Future<Either<Failure, CafeModel>> updateCafe(
    UpdateCafeRequest request, 
    List<File>? mediaFiles
  );
  
  Future<Either<Failure, void>> deleteCafe(String cafeId);
}
