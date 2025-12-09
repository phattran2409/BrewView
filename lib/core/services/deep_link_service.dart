import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';

/// Service để lắng nghe và xử lý deep links
@singleton
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  // Stream để broadcast deep links
  final StreamController<Uri> _linkController =
      StreamController<Uri>.broadcast();
  Stream<Uri> get linkStream => _linkController.stream;

  StreamSubscription<Uri>? _linkSubscription;
  Uri? _initialUri;

  /// Khởi tạo deep link service
  Future<void> initialize() async {
    try {
      // 1. Get initial deep link (khi app được mở từ deep link)
      _initialUri = await _appLinks.getInitialLink();

      if (_initialUri != null) {
        print('🔗 Initial deep link: $_initialUri');
        // Delay để đảm bảo app đã sẵn sàng
        Future.delayed(const Duration(seconds: 2), () {
          _linkController.add(_initialUri!);
        });
      }

      // 2. Lắng nghe deep links khi app đang chạy
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          print('🔗 Incoming deep link: $uri');
          _linkController.add(uri);
        },
        onError: (error) {
          print('❌ Deep link error: $error');
        },
      );

      print('✅ DeepLinkService initialized successfully');
    } catch (e) {
      print('❌ Error initializing deep link service: $e');
    }
  }

  /// Giải phóng resources
  void dispose() {
    _linkSubscription?.cancel();
    _linkController.close();
  }
}
