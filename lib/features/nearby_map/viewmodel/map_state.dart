import 'package:equatable/equatable.dart';
import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:latlong2/latlong.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

// Initial state
class MapInitial extends MapState {
  const MapInitial();
}

// Loading state
class MapLoading extends MapState {
  const MapLoading();
}

// Loaded state with cafes
class MapLoaded extends MapState {
  final List<CafeModel> cafes;
  final double currentLatitude;
  final double currentLongitude;
  final String? selectedCafeId;
  final double zoom;

  const MapLoaded({
    required this.cafes,
    required this.currentLatitude,
    required this.currentLongitude,
    this.selectedCafeId,
    this.zoom = 14.0,
  });

  // Helper to get LatLng for current location
  LatLng get currentLocation => LatLng(currentLatitude, currentLongitude);

  @override
  List<Object?> get props => [
    cafes,
    currentLatitude,
    currentLongitude,
    selectedCafeId,
    zoom,
  ];

  MapLoaded copyWith({
    List<CafeModel>? cafes,
    double? currentLatitude,
    double? currentLongitude,
    String? selectedCafeId,
    bool clearSelection = false,
    double? zoom,
  }) {
    return MapLoaded(
      cafes: cafes ?? this.cafes,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      selectedCafeId:
          clearSelection ? null : (selectedCafeId ?? this.selectedCafeId),
      zoom: zoom ?? this.zoom,
    );
  }
}

// Error state
class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}

// Location permission denied state
class MapLocationPermissionDenied extends MapState {
  const MapLocationPermissionDenied();
}
