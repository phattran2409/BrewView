import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/core/network/token_storage.dart';
import 'package:briewview/features/auth/services/auth_services.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage storage;
  final Dio _refreshDio;
  AuthInterceptor(this.storage) : _refreshDio = _createRefreshDio();

  // avoid circular dependency
  static Dio _createRefreshDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return dio;
  }

  bool _isAuthPath(String path) =>
      path.contains('/api/auth/email/login') ||
      path.contains('/api/users/avatar/');

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
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !_isAuthPath(err.requestOptions.path)) {
      try {
        final refreshToken = await storage.getRefresh();
        if (refreshToken != null) {
          final authApi = AuthApi(_refreshDio);
          final res = await authApi.refreshToken(refreshToken);
          if (res != null) {
            if (res['isSuccess'] == true) {
              final data = res['data'];
              await storage.saveTokens(
                access: data['accessToken'],
                refresh: data['refreshToken'],
              );
              err.requestOptions.headers['Authorization'] =
                  'Bearer ${data['accessToken']}';
              return handler.resolve(await Dio().fetch(err.requestOptions));
            }
          }
        }
      } catch (err) {
        print('Error refreshing token: $err');
      }
      await storage.clear();
    }
    handler.next(err);
  }
}
