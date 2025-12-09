import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TokenStorage {
  final _s = const FlutterSecureStorage();
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kUserId = 'user_id';

  Future<void> saveTokens({
    required String access,
    String? refresh,
    String? userId,
  }) async {
    await _s.write(key: _kAccess, value: access);
    await _s.write(key: _kRefresh, value: refresh ?? '');
    await _s.write(key: _kUserId, value: userId ?? '');
  }

  Future<String?> getAccess() => _s.read(key: _kAccess);
  Future<String?> getRefresh() => _s.read(key: _kRefresh);
  Future<String?> getUserId() => _s.read(key: _kUserId);

  Future<void> clear() async {
    await _s.delete(key: _kAccess);
    await _s.delete(key: _kRefresh);
    await _s.delete(key: _kUserId);
  }

  // Debug method to check token status
  Future<Map<String, String?>> getTokenStatus() async {
    final access = await getAccess();
    final refresh = await getRefresh();
    final userId = await getUserId();

    return {
      'accessToken': access != null ? '${access.substring(0, 20)}...' : 'null',
      'refreshToken':
          refresh != null ? '${refresh.substring(0, 20)}...' : 'null',
      'userId': userId ?? 'null',
    };
  }
}
