import 'dart:io';

import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/features/cafe/model/review.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReviewService {
  final Dio _dio;
  ReviewService(this._dio);

  Future<List<Review?>> getReviews({
    required String cafeId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      var response = await _dio.get(
        AppConstants.getReviewEndpoint(
          cafeId: cafeId,
          pageSize: pageSize,
          pageNumber: pageNumber,
        ),
      );
      if (response.statusCode == 200) {
        var responseData = response.data['data'] as Map<String, dynamic>;
      

        var reviewJson = responseData['reviews'] as List<dynamic>;
        var reviewData =
            reviewJson
                .map(
                  (review) => Review.fromJson(review as Map<String, dynamic>),
                )
                .toList();
        print('Reviews Data : $reviewData');
        if (reviewData.isNotEmpty) {
          return reviewData;
        }
        return List<Review>.empty();
      }
      return [];
    } catch (e) {
      print('Error fetching reviews: $e');
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> createReview({
    required String cafeId,
    required int rating,
    required String content,
    List<File> medias = const [],
  }) async {
     try {
      final requestBody = FormData.fromMap({
        'Rating': rating.toString(),  // PascalCase as expected by API
        'Content': content,           // PascalCase as expected by API
        // Add media files if present
        if (medias.isNotEmpty)
          for (int i = 0; i < medias.length; i++)
            'MediaFiles': await MultipartFile.fromFile(
              medias[i].path,
              filename: 'review_media_$i.jpg',
            ),
      });
    
      final response = await _dio.post(
        '/api/reviews/$cafeId',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );

      
      return response.data;
      
    } on DioException catch (dioError) {
      String errorMessage = 'Tạo đánh giá thất bại';
      
      if (dioError.response?.data != null) {
        final responseData = dioError.response!.data;
        
        if (responseData is Map<String, dynamic>) {
          // Try different error message fields
          errorMessage = responseData['message'] ?? 
                        responseData['error'] ?? 
                        responseData['detail'] ?? 
                        'Server trả về lỗi 400';
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      }
      
      throw Exception('Create review error: $errorMessage');
      
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
