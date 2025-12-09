import 'dart:async';
import 'package:briewview/app/router/app_router.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'deep_link_service.dart';

/// Handler để xử lý deep links và navigate đến đúng màn hình
@injectable
class DeepLinkHandler {
  final DeepLinkService _deepLinkService;
  StreamSubscription<Uri>? _subscription;

  DeepLinkHandler(this._deepLinkService);

  /// Bắt đầu lắng nghe deep links
  void startListening() {
    _subscription = _deepLinkService.linkStream.listen(_handleDeepLink);
    print('✅ DeepLinkHandler started listening');
  }

  /// Xử lý deep link
  void _handleDeepLink(Uri uri) {
    print('📱 Handling deep link: $uri');
    print('   Scheme: ${uri.scheme}');
    print('   Host: ${uri.host}');
    print('   Path: ${uri.path}');
    print('   Query: ${uri.queryParameters}');

    // Kiểm tra scheme phải là 'brewview'
    if (uri.scheme != 'brewview') {
      print('❌ Invalid scheme: ${uri.scheme}');
      return;
    }

    // Chuyển đổi deep link thành app route
    final appRoute = _convertToAppRoute(uri);
    print('🎯 Navigating to: $appRoute');

    // Navigate sau một chút delay để đảm bảo router đã sẵn sàng
    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        final router = GetIt.instance<AppRouter>().router;
        router.go(appRoute);
        print('✅ Navigation successful');
      } catch (e) {
        print('❌ Navigation error: $e');
        // Fallback to home
        try {
          final router = GetIt.instance<AppRouter>().router;
          router.go('/home');
        } catch (fallbackError) {
          print('❌ Fallback to home failed: $fallbackError');
        }
      }
    });
  }

  /// Chuyển đổi deep link URI thành app route path
  String _convertToAppRoute(Uri uri) {
    final host = uri.host;
    final path = uri.path;
    final query = uri.queryParameters;

    // brewview://payment/success -> /payment/success
    if (host == 'payment') {
      if (path == '/success') {
        return _buildPath('/payment/success', query);
      }
      if (path == '/failure') {
        return _buildPath('/payment/failure', query);
      }
    }

    // brewview://cafe/123 -> /cafe/123
    if (host == 'cafe') {
      final cafeId = path.replaceFirst('/', '');
      if (cafeId.isNotEmpty) {
        return '/cafe/$cafeId';
      }
    }

    // brewview://profile -> /profile
    if (host == 'profile') {
      return '/profile';
    }

    // brewview://premium -> /premium-plans
    if (host == 'premium') {
      return '/premium-plans';
    }

    // brewview://search -> /search
    if (host == 'search') {
      return _buildPath('/search', query);
    }

    // brewview://home -> /home
    if (host == 'home' || host.isEmpty) {
      return '/home';
    }

    // Default fallback
    print('⚠️ Unknown host: $host, defaulting to home');
    return '/home';
  }

  /// Build path với query parameters
  String _buildPath(String basePath, Map<String, dynamic> queryParams) {
    if (queryParams.isEmpty) {
      return basePath;
    }

    final queryString = queryParams.entries
        .where((e) => e.value != null && e.value.toString().isNotEmpty)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    return queryString.isEmpty ? basePath : '$basePath?$queryString';
  }

  /// Dừng lắng nghe deep links
  void dispose() {
    _subscription?.cancel();
    print('🛑 DeepLinkHandler disposed');
  }
}
