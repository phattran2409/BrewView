import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/core/network/token_storage.dart';
import 'package:briewview/features/auth/services/auth_services.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class AuthInterceptor extends Interceptor {
  final TokenStorage storage;
  final Dio _refreshDio;
  final Dio _client;

  // refresh lock shared across instances
  static bool _isRefreshing = false;
  static Completer<void>? _refreshCompleter;

  AuthInterceptor(this.storage, this._client)
    : _refreshDio = _createRefreshDio();

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
      path.contains('/api/auth/email/register') ||
      path.contains('/api/auth/forgot-password') ||
      path.contains('/api/auth/reset-password') ||
      path.contains('/api/auth/email/register') ||
      path.contains('/api/auth/forgot-password') ||
      path.contains('/api/auth/reset-password') ||
      path.contains('/api/users/avatar/');

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthPath(options.path)) {
      // If a refresh is in progress, wait for it so we attach the newest token
      if (_isRefreshing && _refreshCompleter != null) {
        try {
          await _refreshCompleter!.future;
        } catch (_) {}
      }
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
        // If another refresh is in progress, wait and then retry with updated token
        if (_isRefreshing) {
          if (_refreshCompleter != null) {
            await _refreshCompleter!.future;
          }
          final latest = await storage.getAccess();
          if (latest != null) {
            err.requestOptions.headers['Authorization'] = 'Bearer $latest';
          }
          final response = await _client.fetch(err.requestOptions);
          return handler.resolve(response);
        }

        _isRefreshing = true;
        _refreshCompleter = Completer<void>();

        final refreshToken = await storage.getRefresh();
        if (refreshToken != null) {
          final authApi = AuthApi(_refreshDio);
          final res = await authApi.refreshToken(refreshToken);
          if (res != null && res['isSuccess'] == true) {
            final data = res['data'];
            await storage.saveTokens(
              access: data['accessToken'],
              refresh: data['refreshToken'],
            );
            _refreshCompleter?.complete();
            final latest = data['accessToken'] as String;
            err.requestOptions.headers['Authorization'] = 'Bearer $latest';
            final response = await _client.fetch(err.requestOptions);
            return handler.resolve(response);
          }
        }
      } catch (e) {
        // ignore: avoid_print
        print('Error refreshing token: $e');
        _refreshCompleter?.completeError(e);
      } finally {
        _isRefreshing = false;
        _refreshCompleter = null;
      }
      await storage.clear();
    }
    handler.next(err);
  }
}
