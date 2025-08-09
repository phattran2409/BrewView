import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TokenStorage {
  final _s = const FlutterSecureStorage();
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  Future<void> saveTokens({required String access, required String refresh}) async {
    await _s.write(key: _kAccess, value: access);
    await _s.write(key: _kRefresh, value: refresh);
  }

  Future<String?> getAccess() => _s.read(key: _kAccess);
  Future<String?> getRefresh() => _s.read(key: _kRefresh);

  Future<void> clear() async {
    await _s.delete(key: _kAccess);
    await _s.delete(key: _kRefresh);
  }
}