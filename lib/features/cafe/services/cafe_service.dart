import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/features/cafe/model/cafeMutation.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';

@injectable
class CafeService {
  final Dio dio;
  final UserStorageServices userStorageServices;

  CafeService(this.dio, this.userStorageServices);

  Future<Map<String, dynamic>> getCafes({
    int pageNumber = 1,
    int pageSize = 10,
    String? sortBy, 
    String? searchTerm,  
    String? sortDirection,  
  }) async {
    try {
      final endPoint = AppConstants.getCafeList(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortBy: sortBy ?? '',
        sortDirection: sortDirection ?? '',
        searchTerm: searchTerm ?? '',
      );
      final response = await dio.get(endPoint);
      print('Response data layer Services: ${response.data}'); // Debug log
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          final cafeData = data['data'] as Map<String, dynamic>;
          final cafes =
              (cafeData['cafes'] as List)
                  .map((cafeJson) => CafeModel.fromJson(cafeJson))
                  .toList();

          return {
            'isSuccess': true,
            'cafes': cafes,
            'totalCount': cafeData['totalCount'] ?? cafes.length,
            'currentPage': pageNumber,
            'pageSize': pageSize,
          };
        } else {
          throw Exception(data['message'] ?? 'Failed to load cafes');
        }
      } else {
        throw Exception('Failed to load cafes');
      }
    } on DioException catch (e) {
      print('DioException in getCafes: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');

      if (e.response?.statusCode == 404) {
        throw Exception('Cafe endpoint not found');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error occurred');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error in getCafes: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String,dynamic>> getRecommendedCafes({
    String userId = '', 
    int pageNumber = 1, 
    int pageSize = 10,  
  }) async {
    try {
      final endpoint = AppConstants.getCafeByUserPreferences(
        userId: userId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );  
      final response = await dio.get(endpoint);
      print('Response data layer Services: ${response.data}'); // Debug log
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          final cafeData = data['data'] as Map<String, dynamic>;
          final cafes =
              (cafeData['cafes'] as List)
                  .map((cafeJson) => CafeModel.fromJson(cafeJson))
                  .toList();

          return {
            'isSuccess': true,
            'cafes': cafes,
            'totalCount': cafeData['totalCount'] ?? cafes.length,
            'pageNumber': pageNumber,
            'pageSize': pageSize,
          };
        } else {
          throw Exception(data['message'] ?? 'Failed to load recommended cafes');
        }
      } else {
        throw Exception('Failed to load recommended cafes');
      }
    } on DioException catch (e) {
      print('DioException in getRecommendedCafes: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');

      if (e.response?.statusCode == 404) {
        throw Exception('Cafe endpoint not found');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error occurred');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error in getRecommendedCafes: $e');
      throw Exception('An unexpected error occurred');
    }
  } 

  Future<CafeModel?> getCafeById(String cafeId) async {
    try {
      final response = await dio.get(
        '${AppConstants.cafeListEndpoint}/$cafeId',
      );
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          return CafeModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to load cafe details');
        }
      } else {
        throw Exception('Failed to load cafe details');
      }
    } on DioException catch (e) {
      print('DioException in getCafeById: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');

      if (e.response?.statusCode == 404) {
        throw Exception('Cafe not found');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error occurred');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error in getCafeById: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  // New CRUD methods for my_cafe feature
  
  // Get all cafes for current user
  Future<List<CafeModel>> getMyCafes() async {
    try {
      final user = await userStorageServices.getCurrentUser();
      if (user?.id == null) {
        throw Exception('User not authenticated');
      }

      final response = await dio.get(AppConstants.getCafeByOwner(ownerId: user!.id));
        print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
        final responseData = data['data'] as Map<String, dynamic>;
        
        // Based on your backend structure, data contains 'cafes' array
        if (responseData['cafes'] != null && responseData['cafes'] is List) {
          final cafesData = responseData['cafes'] as List<dynamic>;
          return cafesData.map((json) => CafeModel.fromJson(json)).toList();
        } else {
          // If no cafes found, return empty list
          return [];
        }
        }
      } else {
        throw Exception('Failed to fetch cafes');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching cafes: $e');
    }
    throw Exception('Unexpected error in getMyCafes');
  }

  // Create new cafe
  Future<CafeModel> createCafe(CreateCafeRequest request, {List<File>? mediaFiles}) async {
    try {
      final user = await userStorageServices.getCurrentUser();
      if (user?.id == null) {
        throw Exception('User not authenticated');
      }
      // Prepare form data
      final formData = FormData();
      // Add request data
      formData.fields.addAll([
        MapEntry('categoryId', request.categoryId.toString()),
        MapEntry('name', request.name),
        MapEntry('address', request.address),
        MapEntry('description', request.description),
        MapEntry('priceMin', request.priceMin.toString()),
        MapEntry('priceMax', request.priceMax.toString()),
        MapEntry('openingTime', request.openingTime),
        MapEntry('closingTime', request.closingTime),
        MapEntry('ownerId', user!.id),
      ]);

      // Add optional fields
      if (request.linkPage != null) {
        formData.fields.add(MapEntry('linkPage', request.linkPage!));
      }
      if (request.hotline != null) {
        formData.fields.add(MapEntry('hotLine', request.hotline!));
      }

      // Add feature tag IDs
      for (int tagId in request.selectedFeatureTagIds) {
        formData.fields.add(MapEntry('selectedFeatureTagIds', tagId.toString()));
      }

      // Add media files
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (File file in mediaFiles) {
          formData.files.add(MapEntry(
            'mediaFiles',
            await MultipartFile.fromFile(file.path),
          ));
        }
      }

      final response = await dio.post(AppConstants.cafeListEndpoint, data: formData);
      
      if (response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return CafeModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to create cafe');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error creating cafe: $e');
    }
  }

  // Update cafe
  Future<CafeModel> updateCafe(UpdateCafeRequest request, {List<File>? mediaFiles}) async {
    try {
      // Prepare form data
      final formData = FormData();
      
      // Add request data
      formData.fields.addAll([
        MapEntry('cafeId', request.cafeId),
        MapEntry('categoryId', request.categoryId.toString()),
        MapEntry('name', request.name),
        MapEntry('address', request.address),
        MapEntry('description', request.description),
        MapEntry('priceMin', request.priceMin.toString()),
        MapEntry('priceMax', request.priceMax.toString()),
        MapEntry('openingTime', request.openingTime),
        MapEntry('closingTime', request.closingTime),
      ]);

      // Add optional fields
      if (request.linkPage != null) {
        formData.fields.add(MapEntry('linkPage', request.linkPage!));
      }
      if (request.hotline != null) {
        formData.fields.add(MapEntry('hotLine', request.hotline!));
      }

      // Add feature tag IDs
      for (int tagId in request.cafeFeatureTags) {
        formData.fields.add(MapEntry('cafeFeatureTags', tagId.toString()));
      }

      // Add media IDs to delete
      if (request.mediaIdsToDelete != null) {
        for (String mediaId in request.mediaIdsToDelete!) {
          formData.fields.add(MapEntry('mediaIdsToDelete', mediaId));
        }
      }

      // Add new media files
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (File file in mediaFiles) {
          formData.files.add(MapEntry(
            'mediaFiles',
            await MultipartFile.fromFile(file.path),
          ));
        }
      }

      final response = await dio.put(AppConstants.cafeListEndpoint, data: formData);
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return CafeModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to update cafe');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error updating cafe: $e');
    }
  }

  // Delete cafe
  Future<void> deleteCafe(String cafeId) async {
    try {
      final response = await dio.delete('${AppConstants.cafeListEndpoint}/$cafeId');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete cafe');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting cafe: $e');
    }
  }

}
