import 'package:injectable/injectable.dart';

import 'user_repository.dart';
import '../services/user_service.dart';
import '../model/user.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserService _service;
  UserRepositoryImpl(this._service);

  @override
  Future<List<User>> getAll() async {
    final dtos = await _service.fetchUsers();
    return dtos.map((e) => e.toEntity()).toList();
  }
}