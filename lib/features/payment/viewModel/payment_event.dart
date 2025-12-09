import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentLinkEvent extends PaymentEvent {
  final String userId;

  const CreatePaymentLinkEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CheckPaymentStatusEvent extends PaymentEvent {
  final int orderCode;

  const CheckPaymentStatusEvent({required this.orderCode});

  @override
  List<Object?> get props => [orderCode];
}

class VerifyPaymentEvent extends PaymentEvent {
  final int orderCode;
  final String subscriptionId;

  const VerifyPaymentEvent({
    required this.orderCode,
    required this.subscriptionId,
  });

  @override
  List<Object?> get props => [orderCode, subscriptionId];
}

class CancelPaymentEvent extends PaymentEvent {
  final int orderCode;

  const CancelPaymentEvent({required this.orderCode});

  @override
  List<Object?> get props => [orderCode];
}

class ResetPaymentEvent extends PaymentEvent {
  const ResetPaymentEvent();
}
