import 'dart:io';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/features/my_cafe/model/cafe_model.dart';
import 'package:briewview/features/my_cafe/model/category_model.dart';
import 'package:briewview/features/my_cafe/model/feature_tag_model.dart';
import 'package:briewview/features/my_cafe/model/create_cafe_request.dart';
import 'package:briewview/features/my_cafe/model/update_cafe_request.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class MyCafeService {
  final Dio _dio;
  final UserStorageServices _userStorageServices;

  MyCafeService(this._dio, this._userStorageServices);

  // Get all cafes for current user
  Future<List<CafeModel>> getMyCafes() async {
    try {
      final user = await _userStorageServices.getCurrentUser();
      if (user?.id == null) {
        throw Exception('User not authenticated');
      }

      // final response = await _dio.get('/api/cafes/owner/${user!.id}');
         final response = await _dio.get('/api/cafes');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final cafesData = data['data'] as List<dynamic>;
        return cafesData.map((json) => CafeModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch cafes');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching cafes: $e');
    }
  }

  // Get cafe by ID
  Future<CafeModel> getCafeById(String cafeId) async {
    try {
      final response = await _dio.get('/api/cafes/$cafeId');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return CafeModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to fetch cafe');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching cafe: $e');
    }
  }

  // Create new cafe
  Future<CafeModel> createCafe(CreateCafeRequest request, List<File>? mediaFiles) async {
    try {
      final user = await _userStorageServices.getCurrentUser();
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
        formData.fields.add(MapEntry('hotline', request.hotline!));
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

      final response = await _dio.post('/api/cafes', data: formData);
      
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
  Future<CafeModel> updateCafe(UpdateCafeRequest request, List<File>? mediaFiles) async {
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
        formData.fields.add(MapEntry('hotline', request.hotline!));
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

      final response = await _dio.put('/api/cafes/${request.cafeId}', data: formData);
      
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
      final response = await _dio.delete('/api/cafes/$cafeId');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete cafe');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting cafe: $e');
    }
  }

  // Get categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('/api/categories');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final categoriesData = data['data'] as List<dynamic>;
        return categoriesData.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch categories');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Get feature tags
  Future<List<FeatureTagModel>> getFeatureTags() async {
    try {
      final response = await _dio.get('/api/feature-tags');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final tagsData = data['data'] as List<dynamic>;
        return tagsData.map((json) => FeatureTagModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch feature tags');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching feature tags: $e');
    }
  }
}
