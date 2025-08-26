import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/core/network/auth_interceptor.dart';
import 'package:briewview/core/network/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// @module
// class NetworkModule {
//   @lazySingleton
//   Dio makeDio(TokenStorage storage) {
//     final dio = Dio(
//       BaseOptions(
//         baseUrl: AppConstants.apiBaseUrl,
//         connectTimeout: const Duration(seconds: 20),
//         receiveTimeout: const Duration(seconds: 20),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       ),
//     );
//     dio.interceptors.add(AuthInterceptor(storage)); // <-- gắn interceptor 1 lần
//     return dio;
//   }
// }


@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(TokenStorage storage) {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    dio.interceptors.add(AuthInterceptor(storage));
    return dio;
  }
}