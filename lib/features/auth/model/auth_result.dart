
import 'package:briewview/features/user_management/model/user.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:flutter/foundation.dart';

class AuthResult {
  final String accessToken;
  final String refreshToken;
  final UserModel? userJson;

  const AuthResult({
    required this.accessToken,
    required this.refreshToken,
     this.userJson,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userJson: json['userJson'] != null
          ? UserModel.fromJson(json['userJson'] as Map<String, dynamic>)
          : null,
    );
  } 

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userJson': userJson?.toJson(),
    };
  }
}