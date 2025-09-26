import 'package:briewview/core/errors/failures.dart';
import 'package:briewview/core/network/token_storage.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/features/auth/model/auth_result.dart';
import 'package:briewview/features/auth/repository/auth_repository.dart';
import 'package:briewview/features/auth/services/auth_services.dart';
import 'package:briewview/features/auth/services/facebook_auth_service.dart';
import 'package:briewview/features/auth/services/google_signin_service.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final TokenStorage _tokenStorage;
  final GoogleSignInService _googleSignInService;
  final FacebookAuthService fbService;
  final UserStorageServices _userStorageServices;

  AuthRepositoryImpl(
    this._api,
    this._tokenStorage,
    this._googleSignInService,
    this.fbService,
    this._userStorageServices,
  );

  @override
  Future<Either<Failure, AuthResult>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final authResp = await _api.login(email: email, password: password);

      if (!authResp.isSuccess) {
        // Trả về Left với Failure nếu đăng nhập thất bại
        return Left(ServerFailure('Email or password is incorrect'));
      }
      final access = authResp.userJson?.accessToken ?? '';
      final refresh = authResp.userJson?.refreshToken ?? '';

      // Lưu token
      await _tokenStorage.saveTokens(access: access, refresh: refresh);

      // Lưu user vào local storage
      final userDataSave = UserModel(
        id: authResp.userJson?.id ?? '',
        name: authResp.userJson?.name ?? '',
        email: authResp.userJson?.email ?? '',
        profilePicture: authResp.userJson?.profilePicture ?? '',
        role: authResp.userJson?.role ?? '',
        identityId: authResp.userJson?.identityId ?? '',
      );
      await _userStorageServices.saveUser(userDataSave);

      // Map lại UserModel đầy đủ
      final Map<String, dynamic> userMap = authResp.userJson?.toJson() ?? {};
      final userModel = userMap.isNotEmpty ? UserModel.fromJson(userMap) : null;

      return Right(AuthResult(isSuccess: true, userJson: userModel));
    } catch (e) {
       if (e is DioError) {
         if(e.response?.statusCode == 400 || e.response?.statusCode == 401) {
           final errorMessage = e.response?.data['detail'] ?? 'Login error: ${e.message}';
           return Left(ServerFailure(errorMessage));
         } else {
           return Left(NetworkFailure('Network error'));
         } 
       }
      return Left(ServerFailure('Login error'));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _googleSignInService.signOut();
      await fbService.signOut();
    } catch (e) {
      print('Error logging out: $e');
    } finally {
      await _tokenStorage.clear();
      await _userStorageServices.clearUserData();
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

      await _tokenStorage.saveTokens(
        access: idToken,
        refresh: idToken,
      ); // secure storage

      // Map sang entity của bạn
      final entity = AuthResult(
        isSuccess: true,
        userJson: UserModel.fromJson({
          'id': user.uid,
          'name': user.displayName,
          'email': user.email,
          'profilePicture': user.photoURL,
          'accessToken': idToken,
          'refreshToken': res.fbProfile.refreshToken,
        }),
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
 
      final userDataFromServer =
          await _googleSignInService.getUserDataFromServer();

      if (userDataFromServer == null ||
          userDataFromServer.userJson == null ||
          !userDataFromServer.isSuccess) {
        return Left(ServerFailure('Failed to fetch user data from server'));
      }
      UserModel serverUserModel;

      if (userDataFromServer.userJson is UserModel) {
        serverUserModel = userDataFromServer.userJson as UserModel;
      } else if (userDataFromServer.userJson is Map<String, dynamic>) {
        serverUserModel = UserModel.fromJson(
          userDataFromServer.userJson as Map<String, dynamic>,
        );
      } else {
        print('❌ Invalid user data type from server');
        return Left(ServerFailure('Invalid user data format from server'));
      }

      print('✅ Server user model created: $serverUserModel');

      // ✅ Step 4: Save tokens from SERVER (not empty strings!)
      final accessToken = serverUserModel.accessToken ?? '';
      final refreshToken = serverUserModel.refreshToken ?? '';
      // Save tokens
      await TokenStorage().saveTokens(
        access: accessToken ?? '',
        refresh: refreshToken ?? '',
      );

      print('✅ Tokens saved: access=$accessToken, refresh=$refreshToken');
      await _userStorageServices.saveUser(
        UserModel(
          id: serverUserModel.id,
          name: cred.user?.displayName ?? '',
          email: cred.user?.email ?? '',
          profilePicture: cred.user?.photoURL ?? '',
          role: 'customer',
          identityId: '',
        ),
      );
      print('✅ User data saved locally');
      return Right(AuthResult(isSuccess: true, userJson: serverUserModel));
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Google Sign-In failed'));
    } catch (e) {
      print('❌ Unexpected error during Google Sign-In: $e');
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
    // try {
    //   final result = await _api.getCurrentUser(userId);
    //   return Right(result);
    // } catch (e) {
    //   return Left(CacheFailure());
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthResult>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final result = await _api.register(
        email: email,
        password: password,
        name: name,
      );
      if (!result.isSuccess) {
        return Left(ServerFailure('Registration failed'));
      }
      final user = UserModel(
        id: result.userJson?.id ?? '',
        email: result.userJson?.email ?? '',
        name: result.userJson?.name ?? '',
        profilePicture: result.userJson?.profilePicture ?? '',
        role: result.userJson?.role ?? '',
        identityId: result.userJson?.identityId ?? '',
      );
      return Right(AuthResult(isSuccess: true, userJson: user));
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  @override
  Future<Either<Failure, AuthResult>> saveAuthResult(
    AuthResult authResult,
  ) async {
    try {
      await _tokenStorage.saveTokens(
        access: authResult.userJson?.accessToken ?? '',
        refresh: authResult.userJson?.refreshToken ?? '',
      );
      return Right(authResult);
    } catch (e) {
      return Left(ServerFailure('Failed to save authentication data: $e'));
    }
  }

  @override
  Future<bool> verifyOtp(String otp, String userId) async {
    try {
      final result = await _api.verifyOtp(otp, userId);
      return result;
    } catch (e) {
      print('Error verifying OTP: $e');
      rethrow;
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    try {
      final result = await _api.forgotPassword(email);
      if (result) {
        return Right(true);
      } else {
        return Left(ServerFailure('Failed to initiate password reset'));
      }
    } catch (e) {
      print('Error in forgot password: $e');
      return Left(ServerFailure('Failed to initiate password reset: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String newPassword,
    required String currentPassword,  
  }) async {
    try {
      final result = await _api.resetPassword(
        email: email,
        newPassword: newPassword,
        currentPassword: currentPassword,
      );
      print('Reset password result: $result');  
      print('email: $email, newPassword: $newPassword, currentPassword: $currentPassword');
      if (result) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to reset password'));
      }
    } catch (e) {
      print('Error in reset password: $e');
      return Left(ServerFailure('Failed to reset password: $e'));
    }
  }
}
