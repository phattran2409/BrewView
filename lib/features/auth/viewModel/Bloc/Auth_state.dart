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