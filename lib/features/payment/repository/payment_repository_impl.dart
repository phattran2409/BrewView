
import 'package:briewview/features/payment/model/payment_result_model.dart';
import 'package:briewview/features/payment/model/payment_error_model.dart';
import 'package:briewview/features/payment/repository/payment_repository.dart';
import 'package:briewview/features/payment/services/payment_service.dart';
import 'package:injectable/injectable.dart';


@Singleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentService _paymentService;  
  
  PaymentRepositoryImpl(this._paymentService);

  @override
  Future<PaymentResultModel?> createPaymentLink({required String userId}) async {
    try {
      return await _paymentService.createPaymentLink(userId: userId);
    } on PaymentServiceException catch (e) {
      throw PaymentRepositoryException(
        message: e.message,
        paymentError: e.paymentError,
        originalException: e,
      );
    } catch (e) {
      print('Repository error creating payment link: $e');
      throw PaymentRepositoryException(
        message: 'Repository error: ${e.toString()}',
        paymentError: null,
        originalException: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> checkPaymentStatus({required int orderCode}) async {
    try {
      return await _paymentService.checkPaymentStatus(orderCode: orderCode);
    } on PaymentServiceException catch (e) {
      throw PaymentRepositoryException(
        message: e.message,
        paymentError: e.paymentError,
        originalException: e,
      );
    } catch (e) {
      print('Repository error checking payment status: $e');
      throw PaymentRepositoryException(
        message: 'Repository error: ${e.toString()}',
        paymentError: null,
        originalException: e,
      );
    }
  }

  @override
  Future<bool> verifyPayment({
    required int orderCode,
    required String subscriptionId,
  }) async {
    try {
      return await _paymentService.verifyPayment(
        orderCode: orderCode,
        subscriptionId: subscriptionId,
      );
    } on PaymentServiceException catch (e) {
      throw PaymentRepositoryException(
        message: e.message,
        paymentError: e.paymentError,
        originalException: e,
      );
    } catch (e) {
      print('Repository error verifying payment: $e');
      throw PaymentRepositoryException(
        message: 'Repository error: ${e.toString()}',
        paymentError: null,
        originalException: e,
      );
    }
  }

  @override
  Future<bool> cancelPayment({required int orderCode}) async {
    try {
      return await _paymentService.cancelPayment(orderCode: orderCode);
    } on PaymentServiceException catch (e) {
      throw PaymentRepositoryException(
        message: e.message,
        paymentError: e.paymentError,
        originalException: e,
      );
    } catch (e) {
      print('Repository error cancelling payment: $e');
      throw PaymentRepositoryException(
        message: 'Repository error: ${e.toString()}',
        paymentError: null,
        originalException: e,
      );
    }
  }
}

/// Repository layer exception chứa PaymentErrorModel từ backend
class PaymentRepositoryException implements Exception {
  final String message;
  final PaymentErrorModel? paymentError;
  final dynamic originalException;

  PaymentRepositoryException({
    required this.message,
    this.paymentError,
    this.originalException,
  });

  @override
  String toString() => message;

  /// Có phải lỗi từ backend không (có PaymentErrorModel)
  bool get isBackendError => paymentError != null;
  
  /// Lấy user-friendly message
  String get userFriendlyMessage => 
      paymentError?.userFriendlyMessage ?? message;
      
  /// Lấy user-friendly title
  String get userFriendlyTitle => 
      paymentError?.userFriendlyTitle ?? 'Lỗi thanh toán';
}
