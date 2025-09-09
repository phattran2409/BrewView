import 'package:briewview/features/auth/model/auth_result.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthResult user;  
  final String? provider; // 'email', 'facebook', 'google'

  const AuthAuthenticated({
    required this.user,
    this.provider,
  });

  @override
  List<Object?> get props => [user, provider];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class AuthFacebookLoginInProgress extends AuthState {
  const AuthFacebookLoginInProgress();
}

class AuthGoogleLoginInProgress extends AuthState {
  const AuthGoogleLoginInProgress();
}

class AuthEmailLoginInProgress extends AuthState {
  const AuthEmailLoginInProgress();
}

// ✅ Additional registration states for better flow control
class AuthEmailRegisterInProgress extends AuthState {
  const AuthEmailRegisterInProgress();
}

class AuthRegisterSuccess extends AuthState {
  final String email;
  final String? userId;
  final bool requiresEmailVerification;

  const AuthRegisterSuccess({
    required this.email,
    this.userId,
    this.requiresEmailVerification = true,
  });

  @override
  List<Object?> get props => [email, userId, requiresEmailVerification];
}

class AuthEmailVerificationSent extends AuthState {
  final String email;

  const AuthEmailVerificationSent({required this.email});

  @override
  List<Object?> get props => [email];
}