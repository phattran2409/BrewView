 import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';

@singleton
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  
  // Callback functions
  Function(String token)? onPasswordReset;
  Function(String token)? onEmailVerification;
  Function(Map<String, String> params)? onCustomLink;
  
  Future<void> initialize() async {
    try {
      // ✅ Handle initial link (when app is closed)
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
      
      // ✅ Handle incoming links (when app is running)
      _linkSubscription = _appLinks.uriLinkStream.listen(
        _handleDeepLink,
        onError: (err) {
          print('❌ Deep link error: $err');
        },
      );
      
      print('✅ Deep link service initialized');
    } catch (e) {
      print('❌ Failed to initialize deep links: $e');
    }
  }
  
  void _handleDeepLink(Uri uri) {
    print('📱 Received deep link: $uri');
    
    try {
      // ✅ Handle different link types
      switch (uri.path) {
        case '/reset':
          _handlePasswordReset(uri);
          break;
        case '/verify':
          _handleEmailVerification(uri);
          break;
        default:
          _handleCustomLink(uri);
      }
    } catch (e) {
      print('❌ Error handling deep link: $e');
    }
  }
  
  void _handlePasswordReset(Uri uri) {
    final token = uri.queryParameters['token'];
    final email = uri.queryParameters['email'];
    
    if (token != null && token.isNotEmpty) {
      print('🔑 Password reset token received: $token');
      onPasswordReset?.call(token);
    } else {
      print('❌ Invalid password reset link - no token');
    }
  }
  
  void _handleEmailVerification(Uri uri) {
    final token = uri.queryParameters['token'];
    final userId = uri.queryParameters['userId'];
    
    if (token != null && token.isNotEmpty) {
      print('✅ Email verification token received: $token');
      onEmailVerification?.call(token);
    } else {
      print('❌ Invalid email verification link - no token');
    }
  }
  
  void _handleCustomLink(Uri uri) {
    final params = uri.queryParameters;
    print('🔗 Custom link received: $params');
    onCustomLink?.call(params);
  }
  
  void dispose() {
    _linkSubscription?.cancel();
  }
}