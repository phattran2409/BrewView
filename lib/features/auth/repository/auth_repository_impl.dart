import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/core/network/token_storage.dart';
import 'package:briewview/features/auth/model/auth_result.dart';
import 'package:briewview/features/auth/repository/auth_repository.dart';
import 'package:briewview/features/auth/services/auth_services.dart';
import 'package:briewview/features/auth/services/facebook_auth_service.dart';
import 'package:briewview/features/auth/services/google_signin_service.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final TokenStorage _tokenStorage;
  final GoogleSignInService _googleSignInService;
  final FacebookAuthService fbService;

  AuthRepositoryImpl(this._api, this._tokenStorage, this._googleSignInService, this.fbService);

  @override
  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    // TODO: implement loginWithEmail
    try {
      // Simulate a network call
      final res = await _api.login(email: email, password: password);
      if (res != null) {
        // Save tokens to secure storage
        await _tokenStorage.saveTokens(
          access: res.accessToken,
          refresh: res.refreshToken,
        );
      }
      return AuthResult(
        accessToken: res.accessToken,
        refreshToken: res.refreshToken,
      );
    } catch (e) {
      rethrow;
    }
  }
   
  @override
  Future<void> logout() async{
    try {
      await _tokenStorage.clear();
    } catch (e) {
      await _tokenStorage.clear();
    }
  }

  @override
  Future<Either<Failure, AuthResult>> loginWithFacebook() async {
    try {
      final res = await fbService.signIn(); // gọi provider service
      final user = res.credential.user;
      if (user == null) return left(ServerFailure('No Firebase user'));

      final idToken = await user.getIdToken(); // Firebase ID token
      if (idToken == null) return left(ServerFailure('Empty ID token'));

      await _tokenStorage.saveTokens(access: idToken, refresh: idToken); // secure storage

      // Map sang entity của bạn
      final entity = AuthResult(
        accessToken: idToken,
        refreshToken: res.fbAccessToken,
        userJson: res.fbProfile,
      );

      return right(entity);
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure(e.message ?? 'Firebase error'));
    } catch (e) {
      return left(ServerFailure('Facebook login failed: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> loginWithGoogle() async {
    try {
      final cred = await _googleSignInService.signInWithGoogle();
      if (cred == null || cred.user == null) {
        return Left(ServerFailure('Google Sign-In canceled or failed'));
      }

      final idToken = await _googleSignInService.getIdToken();
      await _tokenStorage.saveTokens(
        access: idToken ?? '',
        refresh: idToken ?? '',
      );
      return Right(
        AuthResult(accessToken: idToken ?? '', refreshToken: idToken ?? ''),
      );
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Google Sign-In failed'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final accessToken = await _tokenStorage.getAccess();
    return accessToken != null;
  }
  
  @override
  Future<Either<Failure, AuthResult?>> getCurrentUser() async {
    try {
      final result = await _api.getCurrentUser();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<bool> signInWithEmail({required String email, required String password, required String name}) async {
    try {
      final result = await _api.register(email: email, password: password, name: name);
      return result;
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<bool> registerWithEmail({required String email, required String password, required String name}) {
    // TODO: implement registerWithEmail
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, AuthResult>> saveAuthResult(AuthResult authResult) async {
    try {
      await _tokenStorage.saveTokens(
        access: authResult.accessToken,
        refresh: authResult.refreshToken,
      );
      return Right(authResult);
    } catch (e) {
      return Left(ServerFailure('Failed to save authentication data: $e'));
    }
  }

}
