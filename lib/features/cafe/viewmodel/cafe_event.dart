import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'dart:io';

import 'package:briewview/features/cafe/model/cafeMutation.dart';

abstract class CafeEvent {}

class LoadCafes extends CafeEvent {
  final int pageNumber;
  final int pageSize;
  final String? search;
  final String? sortBy;
  final String? sortDirection;

  LoadCafes({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.search,
    this.sortBy,
    this.sortDirection,
  });
}

class LoadCafesRating extends CafeEvent {
  final int pageNumber;
  final int pageSize;
  final String? sortBy;
  final String? sortDirection;

  LoadCafesRating({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.sortBy,
    this.sortDirection,
  });
}

class LoadMoreCafes extends CafeEvent {
  final int pageNumber;
  final int pageSize;
  final String? search;
  final String? sortBy;

  LoadMoreCafes({
    required this.pageNumber,
    this.pageSize = 10,
    this.search,
    this.sortBy,
  });
}

class SearchCafes extends CafeEvent {
  final String searchQuery;
  final int pageSize;

  SearchCafes({required this.searchQuery, this.pageSize = 10});
}

class LoadCafeById extends CafeEvent {
  final String cafeId;

  LoadCafeById(this.cafeId);
}

class LoadCafesByDistance extends CafeEvent {
  final int maxDistanceKm;
  final int pageNumber;
  final int pageSize;

  LoadCafesByDistance({
    this.maxDistanceKm = 10,
    this.pageNumber = 1,
    this.pageSize = 10
  });
  @override
  List<Object?> get props => [maxDistanceKm, pageNumber, pageSize];
}

class LocationUpdated extends CafeEvent {
  final double latitude;
  final double longitude;

  LocationUpdated({required this.latitude, required this.longitude});
  
  @override
  List<Object?> get props => [latitude, longitude];
}

class RefreshCafes extends CafeEvent {}

class LoadRecommendedCafes extends CafeEvent {
  final String userId;
  final int pageNumber;
  final int pageSize;

  LoadRecommendedCafes({
    required this.userId,
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}

// New CRUD Events for my_cafe feature
class LoadMyCafes extends CafeEvent {}

class CreateCafe extends CafeEvent {
  final CreateCafeRequest request;
  final List<File>? mediaFiles;

  CreateCafe(this.request, {this.mediaFiles});
}

class UpdateCafe extends CafeEvent {
  final UpdateCafeRequest request;
  final List<File>? mediaFiles;

  UpdateCafe(this.request, {this.mediaFiles});
}

class DeleteCafe extends CafeEvent {
  final String cafeId;

  DeleteCafe(this.cafeId);
}

class RefreshMyCafes extends CafeEvent {} 