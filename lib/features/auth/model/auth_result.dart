import 'package:briewview/features/user_management/model/user_model.dart';

class AuthResult {
  final bool isSuccess;
  final UserModel? userJson;
  final String? errorMessage;
  final String? errorCode;

  const AuthResult({
    required this.isSuccess,
    this.userJson,
    this.errorMessage,
    this.errorCode,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
     final raw = json['isSuccess'];
     final isSuccess = (raw is bool) ? raw : (raw is String && raw.toLowerCase() == 'true');
    return AuthResult(
      isSuccess: isSuccess,
      userJson: json['userJson'] != null
          ? UserModel.fromJson(json['userJson'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'userJson': userJson?.toJson(),
    };
  }

  factory AuthResult.failure({
    required String message,
    String? errorCode,
  }) {
    return AuthResult(
      isSuccess: false,
      errorMessage: message,
      errorCode: errorCode,
    );
  }
}
