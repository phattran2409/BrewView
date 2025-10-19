import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthFacebookLoginRequested extends AuthEvent {
  const AuthFacebookLoginRequested();
}

class AuthGoogleLoginRequested extends AuthEvent {
  const AuthGoogleLoginRequested();
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();
}

class AuthInitialized extends AuthEvent {

  const AuthInitialized();
}

class GetCurrentUserEvent extends AuthEvent {
  final String userId;

  const GetCurrentUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
} 

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  final String newPassword;
  final String currentPassword;

  const AuthPasswordResetRequested({
    required this.email,
    required this.newPassword,
    required this.currentPassword,
  });

  @override
  List<Object?> get props => [email, newPassword];
}
