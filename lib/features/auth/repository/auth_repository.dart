import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/features/auth/model/auth_result.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResult>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, AuthResult>> loginWithFacebook();

  Future<Either<Failure, AuthResult>> loginWithGoogle();

  Future<bool> isLoggedIn();

  Future<void> logout();

  Future<Either<Failure, AuthResult?>> getCurrentUser();
  Future<Either<Failure, AuthResult>> saveAuthResult(AuthResult authResult);

  Future<bool> verifyOtp(String otp, String userId);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String newPassword,
    required String currentPassword,
  });
}
