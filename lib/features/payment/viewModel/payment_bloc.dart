import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../repository/payment_repository.dart';
import '../repository/payment_repository_impl.dart';
import 'payment_event.dart';
import 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentBloc(this._paymentRepository) : super(const PaymentInitial()) {
    on<CreatePaymentLinkEvent>(_onCreatePaymentLink);
    on<CheckPaymentStatusEvent>(_onCheckPaymentStatus);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<CancelPaymentEvent>(_onCancelPayment);
    on<ResetPaymentEvent>(_onResetPayment);
  }

  Future<void> _onCreatePaymentLink(
    CreatePaymentLinkEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(const PaymentLoading());
      
      final result = await _paymentRepository.createPaymentLink(
        userId: event.userId,
      );

      if (result != null) {
        emit(PaymentLinkCreated(paymentResult: result));
      } else {
        emit(const PaymentError(message: 'Không thể tạo link thanh toán'));
      }
    } on PaymentRepositoryException catch (e) {
      emit(PaymentError(
        message: e.userFriendlyMessage,
        paymentError: e.paymentError,
      ));
    } catch (e) {
      emit(PaymentError(message: 'Lỗi tạo link thanh toán: ${e.toString()}'));
    }
  }

  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(const PaymentLoading());
      
      final statusData = await _paymentRepository.checkPaymentStatus(
        orderCode: event.orderCode,
      );

      if (statusData != null) {
        emit(PaymentStatusChecked(statusData: statusData));
      } else {
        emit(const PaymentError(message: 'Không thể kiểm tra trạng thái thanh toán'));
      }
    } on PaymentRepositoryException catch (e) {
      emit(PaymentError(
        message: e.userFriendlyMessage,
        paymentError: e.paymentError,
      ));
    } catch (e) {
      emit(PaymentError(message: 'Lỗi kiểm tra trạng thái: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(const PaymentLoading());
      
      final isVerified = await _paymentRepository.verifyPayment(
        orderCode: event.orderCode,
        subscriptionId: event.subscriptionId,
      );

      emit(PaymentVerified(isVerified: isVerified));
      
      if (isVerified) {
        emit(const PaymentSuccess(message: 'Thanh toán thành công!'));
      }
    } on PaymentRepositoryException catch (e) {
      emit(PaymentError(
        message: e.userFriendlyMessage,
        paymentError: e.paymentError,
      ));
    } catch (e) {
      emit(PaymentError(message: 'Lỗi xác thực thanh toán: ${e.toString()}'));
    }
  }

  Future<void> _onCancelPayment(
    CancelPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(const PaymentLoading());
      
      final isCancelled = await _paymentRepository.cancelPayment(
        orderCode: event.orderCode,
      );

      emit(PaymentCancelled(isCancelled: isCancelled));
      
      if (isCancelled) {
        emit(const PaymentSuccess(message: 'Đã hủy thanh toán'));
      }
    } on PaymentRepositoryException catch (e) {
      emit(PaymentError(
        message: e.userFriendlyMessage,
        paymentError: e.paymentError,
      ));
    } catch (e) {
      emit(PaymentError(message: 'Lỗi hủy thanh toán: ${e.toString()}'));
    }
  }

  void _onResetPayment(
    ResetPaymentEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentInitial());
  }
}