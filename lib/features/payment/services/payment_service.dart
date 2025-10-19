import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/features/payment/model/payment_method_model.dart';
import 'package:briewview/features/payment/model/payment_result_model.dart';
import 'package:briewview/features/payment/model/payment_error_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class PaymentService {
  final Dio _dio;

  PaymentService(this._dio);

  /// Tạo payment link cho subscription
  Future<PaymentResultModel?> createPaymentLink({
    required String userId,
  }) async {
    try {
      var response = await _dio.post(AppConstants.getCreatePaymentLink(userId));
      if (response.statusCode == 200) {
        var responseData = response.data['data'] as Map<String, dynamic>;
        print('Response Data: $responseData');  
        if (responseData != null ) {
          var dataResult = PaymentResultModel.fromJson(responseData); 
          return dataResult;
        }
      }
      return null;
    } catch (e) {
      print('Error creating payment link: $e');
      throw Exception(e);
    }
  }

  /// Kiểm tra trạng thái thanh toán
  Future<Map<String, dynamic>?> checkPaymentStatus({
    required int orderCode,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.getPaymentStatus(orderCode),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      print('Error checking payment status: $e');
      throw _handleDioError(e);
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Verify payment sau khi thanh toán thành công
  Future<bool> verifyPayment({
    required int orderCode,
    required String subscriptionId,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.verifyPayment,
        data: {
          'orderCode': orderCode,
          'subscriptionId': subscriptionId,
        },
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        return responseData['success'] ?? false;
      }
      return false;
    } on DioException catch (e) {
      print('Error verifying payment: $e');
      throw _handleDioError(e);
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Cancel payment
  Future<bool> cancelPayment({
    required int orderCode,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.cancelPayment,
        data: {'orderCode': orderCode},
      );

      if (response.statusCode == 200) {
        return response.data['success'] ?? false;
      }
      return false;
    } on DioException catch (e) {
      print('Error cancelling payment: $e');
      throw _handleDioError(e);
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Handle Dio errors với PaymentErrorModel
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return PaymentServiceException('Kết nối timeout', null);
      case DioExceptionType.sendTimeout:
        return PaymentServiceException('Gửi request timeout', null);
      case DioExceptionType.receiveTimeout:
        return PaymentServiceException('Nhận phản hồi timeout', null);
      case DioExceptionType.badResponse:
        // Parse API error response
        try {
          if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
            final errorData = e.response!.data as Map<String, dynamic>;
            final paymentError = PaymentErrorModel.fromJson(errorData);
            return PaymentServiceException(
              paymentError.userFriendlyMessage,
              paymentError,
            );
          }
        } catch (parseError) {
          print('Error parsing PaymentErrorModel: $parseError');
        }
        
        // Fallback cho các lỗi không parse được
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 
                       e.response?.data?['detail'] ?? 
                       'Lỗi không xác định';
        return PaymentServiceException('Lỗi server [$statusCode]: $message', null);
      case DioExceptionType.cancel:
        return PaymentServiceException('Request bị hủy', null);
      case DioExceptionType.connectionError:
        return PaymentServiceException('Lỗi kết nối', null);
      default:
        return PaymentServiceException('Lỗi mạng: ${e.message}', null);
    }
  }
}

/// Custom exception để chứa PaymentErrorModel
class PaymentServiceException implements Exception {
  final String message;
  final PaymentErrorModel? paymentError;

  PaymentServiceException(this.message, this.paymentError);

  @override
  String toString() => message;
}
