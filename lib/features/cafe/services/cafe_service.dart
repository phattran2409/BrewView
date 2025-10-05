import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class CafeService {
  final Dio dio;

  CafeService(this.dio);

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
  

}
