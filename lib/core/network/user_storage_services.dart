import 'dart:convert';

import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserStorageServices {
  final _storage = const FlutterSecureStorage();
  static const String _userKey  = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _languageKey = 'language_preference'; 

  Future<void> saveUser(UserModel user) async { 
    final  userJson = {
      'id' : user.id,
      'name' : user.name,
      'email' : user.email,
      'profilePicture' : user.profilePicture,
      'role' : user.role,
      'identityId' : user.identityId,
    }; 
    
    await _storage.write(key: _userKey, value: jsonEncode(userJson));
    await _storage.write(key: _isLoggedInKey, value: 'true');
    await _storage.write(key: _languageKey, value: 'en');
  }
  
  Future<UserModel?> getCurrentUser() async { 
    final userJson = await _storage.read(key: _userKey);
    if (userJson == null) return null; 
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel(
        id: userMap['id'] as String,
        name: userMap['name'] as String,
        email: userMap['email'] as String,
        profilePicture: userMap['profilePicture'] as String?,
        role: userMap['role'] as String?,
        identityId: userMap['identityId'] as String?,
      );
    }catch(e) {
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  Future<void> clearUserData() async {
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _isLoggedInKey);
    await _storage.delete(key: _languageKey);
  }
  
}