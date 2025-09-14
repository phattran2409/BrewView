import 'package:briewview/features/auth/model/auth_result.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';

@singleton
class AuthApi {
  final Dio _dio; // inject từ DI, đã có AuthInterceptor, baseUrl, timeout
  AuthApi(this._dio);

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      AppConstants.loginEndpoint,
      data: {'email': email, 'password': password},
    );

    if (res.statusCode == 200) {
      final data = res.data as Map<String, dynamic>;
      print("Data: $data");
      print(data['data']);
      return AuthResult(
        isSuccess: true,
        userJson: UserModel(
          id: data['data']['userId'],
          name: data['data']['name'],
          email: data['data']['email'],
          profilePicture: data['data']['profilePicture'],
          role: data['data']['role'],
          identityId: data['data']['identityId'],
          accessToken: data['data']['accessToken'],
          refreshToken: data['data']['refreshToken'],
        ),
      );
    } else {
      return AuthResult(isSuccess: false, userJson: null);
    }
  }

  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final res = await _dio.post(
        AppConstants.registerEndpoint,
        data: {'email': email, 'password': password, 'name': name},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data as Map<String, dynamic>;
        print("Registration Data: $data");
        final isSuccess =
            data['isSuccess'] is bool
                ? data['isSuccess'] as bool
                : (data['isSuccess'] is String &&
                    (data['isSuccess'] as String).toLowerCase() == 'true');

        final user = UserModel(
          id: data['data']['userId'],
          name: data['data']['name'],
          email: data['data']['email'],
          identityId: data['data']['identityId'],
        );
        if (isSuccess && data['data'] != null) {
          return AuthResult(isSuccess: isSuccess, userJson: user);
        }
      } else {
        final errorMessage = 'Server error: ${res.statusCode}';
        return AuthResult.failure(
          message: errorMessage,
          errorCode: res.statusCode.toString(),
        );
      }
      // Add a return statement to cover all code paths
      return AuthResult(isSuccess: false, userJson: null);
    } on DioException {
      String errorMessage = 'Registration failed';
      String errorCode = 'UNKNOWN_ERROR';

      return AuthResult.failure(message: errorMessage, errorCode: errorCode);
    } catch (e) {
      // Ensure a return statement for all code paths
      print('Error during registration: $e');
      return AuthResult.failure(message: 'Unknown error', errorCode: null);
    }
  }

  Future<AuthResult?> getCurrentUser() async {
    try {
      final res = await _dio.get(AppConstants.currentUserEndpoint);

      final data = res.data as Map<String, dynamic>;
      return AuthResult(
        isSuccess: data['isSuccess'] as bool,
        userJson: data['data'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyOtp(String otp, String userId) async {
    try {
      final res = await _dio.post(
        '${AppConstants.verifyOtpEndpoint}$userId',
        data: {'otp': otp},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data as Map<String, dynamic>;
        final isSuccess =
            data['isSuccess'] is bool
                ? data['isSuccess'] as bool
                : (data['isSuccess'] is String &&
                    (data['isSuccess'] as String).toLowerCase() == 'true');
        return isSuccess;
      } else {
        return false;
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final res = await _dio.post(
        AppConstants.forgotPasswordEndpoint,
        data: {'email': email},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        print('Password reset email sent successfully.');
        return true;
      }
      print(
        'Failed to send password reset email. Status code: ${res.statusCode}',
      );

      return false;
    } catch (e) {
      print('Error during forgot password: $e');
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String currentPassword,  
    required String newPassword,
  }) async {
    try {
      final res = await _dio.post(
        AppConstants.changePasswordEndpoint,
        data: {'email': email, 'newPassword': newPassword , 'currentPassword': currentPassword},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        print('Password reset successfully.');
        return true;
      } else {
        print('Failed to reset password. Status code: ${res.statusCode}');
      }
      return false;
    } catch (e) {
      print('Error during password reset: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    final res = await _dio.post(
      AppConstants.refreshTokenEndpoint,
      data: {'refreshToken': refreshToken},
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.data;
    }
    return null;
  }
}
