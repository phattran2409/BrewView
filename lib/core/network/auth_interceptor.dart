import 'package:briewview/core/network/token_storage.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage storage;
  AuthInterceptor(this.storage);

  bool _isAuthPath(String path) => path.contains('/auth/login');

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthPath(options.path)) {
      final token = await storage.getAccess();
      if (token != null && options.headers['Authorization'] == null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Handle token expiration or unauthorized access
      await storage.clear();
    }
    handler.next(err);
  }
}
