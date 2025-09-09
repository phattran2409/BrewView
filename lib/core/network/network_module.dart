import 'dart:io';

import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/core/network/auth_interceptor.dart';
import 'package:briewview/core/network/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
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
      if (!kReleaseMode) {
    try {
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    } catch (_) {}
  }

    dio.interceptors.add(AuthInterceptor(storage));

    dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      if (!kReleaseMode) {
        // ignore: avoid_print
        print('DIO REQ: ${options.method} ${options.uri}');
      }
      handler.next(options);
    },
    onResponse: (response, handler) {
      if (!kReleaseMode) {
        // ignore: avoid_print
        print('DIO RESP: ${response.statusCode} ${response.requestOptions.uri}');
      }
      handler.next(response);
    },
    onError: (err, handler) {
      if (!kReleaseMode) {
        // ignore: avoid_print
        print('DIO ERR: ${err.type} ${err.message}');
        if (err is DioException && err.error != null) print(err.error);
      }
      handler.next(err);
    },
  ));
    return dio;
  }
}