import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/features/payment/model/payment_method_model.dart';
import 'package:briewview/features/payment/model/payment_result_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class PaymentService {
  final Dio _dio;

  PaymentService(this._dio);

  // Get user's payment methods
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final response = await _dio.get(AppConstants.paymentMethodsEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          final methods =
              (data['data'] as List)
                  .map((methodJson) => PaymentMethodModel.fromJson(methodJson))
                  .toList();
          return methods;
        }
      }
      return [];
    } catch (e) {
      print('Error loading payment methods: $e');
      return [];
    }
  }

  // Add new payment method
  Future<PaymentMethodModel?> addPaymentMethod({
    required String type,
    required String name,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? bankCode,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.addPaymentMethodEndpoint,
        data: {
          'type': type,
          'name': name,
          'cardNumber': cardNumber,
          'expiryDate': expiryDate,
          'cvv': cvv,
          'bankCode': bankCode,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          return PaymentMethodModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error adding payment method: $e');
      return null;
    }
  }

  // Process payment
  Future<PaymentResultModel?> processPayment({
    required String subscriptionId,
    required String paymentMethodId,
    required double amount,
    required String currency,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.processPaymentEndpoint,
        data: {
          'subscriptionId': subscriptionId,
          'paymentMethodId': paymentMethodId,
          'amount': amount,
          'currency': currency,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          return PaymentResultModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error processing payment: $e');
      return null;
    }
  }

  // Get payment history
  Future<List<PaymentResultModel>> getPaymentHistory() async {
    try {
      final response = await _dio.get(AppConstants.paymentHistoryEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          final payments =
              (data['data'] as List)
                  .map(
                    (paymentJson) => PaymentResultModel.fromJson(paymentJson),
                  )
                  .toList();
          return payments;
        }
      }
      return [];
    } catch (e) {
      print('Error loading payment history: $e');
      return [];
    }
  }

  // Remove payment method
  Future<bool> removePaymentMethod(String paymentMethodId) async {
    try {
      final response = await _dio.delete(
        '${AppConstants.removePaymentMethodEndpoint}/$paymentMethodId',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['isSuccess'] == true;
      }
      return false;
    } catch (e) {
      print('Error removing payment method: $e');
      return false;
    }
  }

  // Set default payment method
  Future<bool> setDefaultPaymentMethod(String paymentMethodId) async {
    try {
      final response = await _dio.post(
        '${AppConstants.setDefaultPaymentMethodEndpoint}/$paymentMethodId',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['isSuccess'] == true;
      }
      return false;
    } catch (e) {
      print('Error setting default payment method: $e');
      return false;
    }
  }
}

