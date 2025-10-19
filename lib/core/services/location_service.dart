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
      // Kiểm tra permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return false;
      }
      
      // Lấy vị trí hiện tại ngay lập tức
      await getCurrentLocation();
      
      // Bắt đầu theo dõi vị trí liên tục
      startLocationTracking();
      
      return true;
    } catch (e) {
      print('Error initializing location: $e');
      return false;
    }
  }
  
  // Lấy vị trí hiện tại một lần
  Future<Position?> getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      if (_currentPosition != null) {
        _notifyLocationChanged();
      }
      
      return _currentPosition;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }
  
  // Bắt đầu theo dõi vị trí liên tục
  void startLocationTracking() {
    // Cấu hình location settings
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Chỉ update khi di chuyển > 10m
    );
    
    // Stream theo dõi vị trí realtime
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _currentPosition = position;
        _notifyLocationChanged();
      },
      onError: (error) {
        print('Location stream error: $error');
      },
    );
    
    // Timer để update location định kỳ (backup)
    _locationUpdateTimer = Timer.periodic(
      const Duration(minutes: 5), // Update mỗi 5 phút
      (timer) async {
        await getCurrentLocation();
      },
    );
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