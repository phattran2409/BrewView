import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

@singleton
class LocationService {
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _locationUpdateTimer;

  Function(double lat, double lng)? onLocationChanged;

  // Getter cho current position
  Position? get currentPosition => _currentPosition;
  double? get latitude => _currentPosition?.latitude;
  double? get longitude => _currentPosition?.longitude;

  bool get hasLocation => _currentPosition != null;

  // Khởi tạo location service
  Future<bool> initialize() async {
    try {
      // Kiểm tra xem location service có được bật không
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        return false;
      }

      // Kiểm tra permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return false;
      }

      // Lấy vị trí hiện tại ngay lập tức
      await getCurrentLocation();

      // Bắt đầu theo dõi vị trí liên tục với error handling
      startLocationTracking();

      return true;
    } catch (e) {
      print('Error initializing location: $e');
      // Log chi tiết hơn về lỗi
      if (e.toString().contains('DeadSystemException') ||
          e.toString().contains('DEAD_OBJECT')) {
        print('System location service is not available. Will retry later.');
      }
      return false;
    }
  }

  // Lấy vị trí hiện tại một lần
  Future<Position?> getCurrentLocation() async {
    try {
      // Kiểm tra service trước khi lấy vị trí
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        return null;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Dùng medium thay vì high
        timeLimit: const Duration(seconds: 10),
      );

      if (_currentPosition != null) {
        _notifyLocationChanged();
      }

      return _currentPosition;
    } catch (e) {
      print('Error getting current location: $e');
      // Handle specific errors
      if (e.toString().contains('DeadSystemException') ||
          e.toString().contains('DEAD_OBJECT')) {
        print('Location service is not available at this time');
      }
      return null;
    }
  }

  // Bắt đầu theo dõi vị trí liên tục
  void startLocationTracking() {
    try {
      // Cấu hình location settings với độ chính xác thấp hơn để tránh NMEA listener
      const LocationSettings locationSettings = LocationSettings(
        accuracy:
            LocationAccuracy.medium, // Giảm từ high -> medium để tránh NMEA
        distanceFilter: 10, // Chỉ update khi di chuyển > 10m
      );

      // Stream theo dõi vị trí realtime với better error handling
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _currentPosition = position;
          _notifyLocationChanged();
        },
        onError: (error) {
          print('Location stream error: $error');
          // Nếu stream fail, dừng lại và thử lại sau
          if (error.toString().contains('DeadSystemException') ||
              error.toString().contains('DEAD_OBJECT')) {
            print(
              'Location stream failed due to system error. Stopping tracking.',
            );
            stopLocationTracking();
            // Thử khởi tạo lại sau 30 giây
            Future.delayed(const Duration(seconds: 30), () {
              _retryLocationTracking();
            });
          }
        },
        cancelOnError: false, // Không cancel stream khi có lỗi
      );

      // Timer để update location định kỳ (backup)
      _locationUpdateTimer = Timer.periodic(
        const Duration(minutes: 5), // Update mỗi 5 phút
        (timer) async {
          await getCurrentLocation();
        },
      );
    } catch (e) {
      print('Failed to start location tracking: $e');
      // Nếu không thể start, thử lại sau
      Future.delayed(const Duration(seconds: 30), () {
        _retryLocationTracking();
      });
    }
  }

  // Thử lại việc theo dõi vị trí
  Future<void> _retryLocationTracking() async {
    try {
      // Kiểm tra lại service và permission trước khi retry
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Cannot retry: Location services still disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Cannot retry: Location permissions denied');
        return;
      }

      print('Retrying location tracking...');
      startLocationTracking();
    } catch (e) {
      print('Retry location tracking failed: $e');
    }
  }

  // Dừng theo dõi vị trí
  void stopLocationTracking() {
    _positionStreamSubscription?.cancel();
    _locationUpdateTimer?.cancel();
  }

  // Tính khoảng cách đến một điểm
  double? calculateDistance(double targetLat, double targetLng) {
    if (_currentPosition == null) return null;

    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      targetLat,
      targetLng,
    );
  }

  // Format location cho API call
  Map<String, double> getLocationForApi() {
    if (_currentPosition == null) {
      throw Exception('Location not available');
    }

    return {
      'latitude': _currentPosition!.latitude,
      'longitude': _currentPosition!.longitude,
    };
  }

  // Thông báo khi location thay đổi
  void _notifyLocationChanged() {
    if (_currentPosition != null && onLocationChanged != null) {
      onLocationChanged!(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
    }
  }

  // Cleanup
  void dispose() {
    stopLocationTracking();
    _positionStreamSubscription = null;
    _locationUpdateTimer = null;
    onLocationChanged = null;
  }
}
