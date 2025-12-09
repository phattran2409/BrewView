import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../repository/auth_repository.dart';

// Events
abstract class OtpEvent {}

class OtpVerifyRequested extends OtpEvent {
  final String otp;
  final String userId;
  
  OtpVerifyRequested({required this.otp, required this.userId});
}

class OtpResendRequested extends OtpEvent {
  final String userId;
  
  OtpResendRequested({required this.userId});
}

// States
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpVerificationInProgress extends OtpState {}

class OtpVerificationSuccess extends OtpState {}

class OtpVerificationFailure extends OtpState {
  final String message;
  
  OtpVerificationFailure({required this.message});
}

class OtpResendInProgress extends OtpState {}

class OtpResendSuccess extends OtpState {
  final String message;
  
  OtpResendSuccess({required this.message});
}

class OtpResendFailure extends OtpState {
  final String message;
  
  OtpResendFailure({required this.message});
}

// BLoC
@injectable
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthRepository _authRepository;
  
  OtpBloc(this._authRepository) : super(OtpInitial()) {
    on<OtpVerifyRequested>(_onOtpVerifyRequested);
    on<OtpResendRequested>(_onOtpResendRequested);
  }
  
  Future<void> _onOtpVerifyRequested(
    OtpVerifyRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(OtpVerificationInProgress());
    
    try {
      final result = await _authRepository.verifyOtp(
        event.otp,
        event.userId,
      );
      
      if (result) {
        emit(OtpVerificationSuccess());
      } else {
        emit(OtpVerificationFailure(message: 'Invalid OTP code'));
      }
    } catch (e) {
      emit(OtpVerificationFailure(message: 'Verification failed: $e'));
    }
  }
  
  Future<void> _onOtpResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(OtpResendInProgress());
    
    try {
      // Add resend OTP API call here
      // await _authRepository.resendOtp(userId: event.userId);
      emit(OtpResendSuccess(message: 'OTP sent successfully'));
    } catch (e) {
      emit(OtpResendFailure(message: 'Failed to resend OTP: $e'));
    }
  }
}