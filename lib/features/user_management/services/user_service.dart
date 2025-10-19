import 'dart:convert';

import 'package:briewview/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../model/user_model.dart';

@lazySingleton
class UserService {
  final Dio _dio;
  UserService(this._dio);

  Future<List<UserModel>> fetchUsers() async {
    final res = await _dio.get('/users'); // cập nhật baseUrl ở network module
    final list = (res.data as List).map((e) => UserModel.fromJson(e)).toList();
    return list;
  }

}