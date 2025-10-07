import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/cafe/model/cafeMutation.dart';
import 'package:briewview/features/cafe/repository/cafes_repository.dart';
import 'package:briewview/features/cafe/services/cafe_service.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';

@Singleton(as: CafesRepository)
class CafesRepositoryImpl implements CafesRepository {
  final CafeService cafeService;
  CafesRepositoryImpl(this.cafeService);

  @override
  Future<Either<Failure, List<CafeModel>>> getCafes({
    int pageNumber = 1,
    int pageSize = 10,
    String? searchTerm,
    String? sortBy,
    String? sortDirection,
  }) async {
    try {
      var result = await cafeService.getCafes(
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchTerm: searchTerm,
        sortBy: sortBy,
        sortDirection: sortDirection,
      );
      var cafeData = result;
      var listCafes = cafeData['cafes'] as List<CafeModel>;
      if (cafeData['isSuccess'] != true) {
        return Future.value(Right(listCafes));
      }
      return Future.value(Right(listCafes));
    } catch (e) {
      return Future.value(Left(ServerFailure(e.toString())));
    }
  }
  
  @override 
  Future<Either<Failure, List<CafeModel>>> getRecommendedCafes({
    required String userId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      var result = await cafeService.getRecommendedCafes(
        userId: userId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      
      var cafeData = result;
      var listCafes = cafeData['cafes'] as List<CafeModel>;
      if (cafeData['isSuccess'] != true) {
        return Future.value(Right(listCafes));
      }
      return Future.value(Right(listCafes));
    } catch (e) {
      return Future.value(Left(ServerFailure(e.toString())));
    }
  } 
  @override
  Future<Either<Failure, CafeModel>> getCafesById(String cafeId) async {
    try {
      var result = await cafeService.getCafeById(cafeId);
      if (result == null) {
        return Future.value(Left(ServerFailure('Cafe not found')));
      } 
      return Future.value(Right(result));
    } catch (e) {
      return Future.value(Left(ServerFailure(e.toString())));
    }
  }

  // New CRUD methods implementation
  @override
  Future<Either<Failure, List<CafeModel>>> getMyCafes() async {
    try {
      var result = await cafeService.getMyCafes();
      return Future.value(Right(result));
    } catch (e) {
      return Future.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, CafeModel>> createCafe(
    CreateCafeRequest request, 
    List<File>? mediaFiles
  ) async {
    try {
      var result = await cafeService.createCafe(request, mediaFiles: mediaFiles);
      return Future.value(Right(result));
    } catch (e) {
      return Future.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, CafeModel>> updateCafe(
    UpdateCafeRequest request, 
    List<File>? mediaFiles
  ) async {
    try {
      var result = await cafeService.updateCafe(request, mediaFiles: mediaFiles);
      return Future.value(Right(result));
    } catch (e) {
      return Future.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCafe(String cafeId) async {
    try {
      await cafeService.deleteCafe(cafeId);
      return Future.value(Right(null));
    } catch (e) {
      return Future.value(Left(ServerFailure(e.toString())));
    }
  }
}
