import 'package:equatable/equatable.dart';
import '../model/payment_result_model.dart';
import '../model/payment_error_model.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentLinkCreated extends PaymentState {
  final PaymentResultModel paymentResult;

  const PaymentLinkCreated({required this.paymentResult});

  @override
  List<Object?> get props => [paymentResult];
}

class PaymentPending extends PaymentState {
  final int? orderCode;
  const PaymentPending({ this.orderCode});

  @override
  List<Object?> get props => [orderCode];
}

class PaymentStatusChecked extends PaymentState {
  final bool isPaid;

  const PaymentStatusChecked({required this.isPaid});

  @override
  List<Object?> get props => [isPaid];
}

class PaymentVerified extends PaymentState {
  final bool isVerified;

  const PaymentVerified({required this.isVerified});

  @override
  List<Object?> get props => [isVerified];
}

class PaymentCancelled extends PaymentState {
  final bool isCancelled;

  const PaymentCancelled({required this.isCancelled});

  @override
  List<Object?> get props => [isCancelled];
}

class PaymentError extends PaymentState {
  final String message;
  final PaymentErrorModel? paymentError;

  const PaymentError({required this.message, this.paymentError});

  @override
  List<Object?> get props => [message, paymentError];

  // Helper methods
  bool get isPendingPaymentError =>
      paymentError?.isPendingPaymentError ?? false;
  bool get canRetry => paymentError?.canRetry ?? true;
  bool get canCancelPending => paymentError?.canCancelPending ?? false;
  String get userFriendlyTitle =>
      paymentError?.userFriendlyTitle ?? 'Lỗi thanh toán';
  String get userFriendlyMessage =>
      paymentError?.userFriendlyMessage ?? message;
}

class PaymentSuccess extends PaymentState {
  final String message;

  const PaymentSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
