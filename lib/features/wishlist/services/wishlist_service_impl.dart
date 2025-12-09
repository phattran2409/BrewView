import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/features/wishlist/model/wishlist_model.dart';
import 'package:briewview/features/wishlist/services/wishlist_service.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WishlistService)
class WishlistServiceImpl implements WishlistService {
  final Dio dio;
  final UserStorageServices userStorageServices;

  WishlistServiceImpl(this.dio, this.userStorageServices);

  @override
  Future<WishlistResponse> getWishlist() async {
    try {
      final user = await userStorageServices.getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await dio.get(AppConstants.getWishlistEndpoint(user.id));

      if (response.statusCode == 200) {
        return WishlistResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load wishlist');
      }
    } on DioException catch (e) {
      print('DioException in getWishlist: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');

      if (e.response?.statusCode == 404) {
        throw Exception('Wishlist not found');
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
      print('Unexpected error in getWishlist: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<WishlistResponse> addToWishlist(String cafeId) async {
    try {
      final user = await userStorageServices.getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await dio.post(AppConstants.getAddToWishlistEndpoint(user.id), data: {'cafeIds': [cafeId]});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return WishlistResponse.fromJson(response.data);
      }
       else {
        throw Exception('Failed to add to wishlist');
      }
    } on DioException catch (e) {
      print('DioException in addToWishlist: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');

      if (e.response?.statusCode == 400) {
        throw Exception('Cafe already in wishlist');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Cafe not found');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error occurred');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error in addToWishlist: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  // @override
  // Future<WishlistResponse> removeFromWishlist(String cafeId) async {
  //   try {
  //     final userId = await userStorageServices.getCurrentUser();
  //     if (userId == null) {
  //       throw Exception('User not authenticated');
  //     }

  //     final endpoint = '/api/wishlist/$userId/remove';
  //     final response = await dio.delete(endpoint, data: {'cafeId': cafeId});
      
  //     if (response.statusCode == 200) {
  //       return WishlistResponse.fromJson(response.data);
  //     } else {
  //       throw Exception('Failed to remove from wishlist');
  //     }
  //   } on DioException catch (e) {
  //     print('DioException in removeFromWishlist: ${e.type}');
  //     print('DioException message: ${e.message}');
  //     print('DioException response: ${e.response?.data}');

  //     if (e.response?.statusCode == 404) {
  //       throw Exception('Cafe not found in wishlist');
  //     } else if (e.response?.statusCode == 500) {
  //       throw Exception('Server error occurred');
  //     } else {
  //       throw Exception('Network error: ${e.message}');
  //     }
  //   } catch (e) {
  //     print('Unexpected error in removeFromWishlist: $e');
  //     throw Exception('An unexpected error occurred');
  //   }
  // }
}
