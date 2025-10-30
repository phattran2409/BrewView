import 'package:briewview/features/payment/model/payment_result_model.dart';

abstract class PaymentRepository {
  Future<PaymentResultModel?> createPaymentLink({required String userId});
  Future<bool> checkPaymentStatus({required int orderCode});
  Future<bool> verifyPayment({
    required int orderCode,
    required String subscriptionId,
  });
  Future<bool> cancelPayment({required int orderCode});
}
