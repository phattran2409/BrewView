import 'package:briewview/features/auth/model/auth_result.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';

class LoginDto {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic>? user;
  LoginDto({required this.accessToken, required this.refreshToken, this.user});
}



@singleton
class AuthApi {
  final Dio _dio; // inject từ DI, đã có AuthInterceptor, baseUrl, timeout
  AuthApi(this._dio);

  Future<LoginDto> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      AppConstants.loginEndpoint,
      data: {'email': email, 'password': password},
    );
    final data = res.data as Map<String, dynamic>;
    return LoginDto(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      user: data['user'] as Map<String, dynamic>?,
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final res = await _dio.post(
      AppConstants.registerEndpoint,
      data: {'email': email, 'password': password, 'name': name},
    );
    final data = res.data as Map<String, dynamic>;
    if (data != null) {
      String message = data['message'] as String;
      if (message == 'success') {
        return true;
      }
    }
    return false; 
  }

  Future<AuthResult?> getCurrentUser() async {
    try {
      final res = await _dio.get(AppConstants.currentUserEndpoint);

      final data = res.data as Map<String, dynamic>;
      return AuthResult(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
        userJson: data['user'],
      );
    } catch (e) {
      rethrow;
    }
  }
}
