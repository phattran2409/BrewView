import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

// Load cafes on map
class LoadNearbyCafesOnMap extends MapEvent {
  final double latitude;
  final double longitude;
  final int maxDistanceKm;
  final int pageSize;

  const LoadNearbyCafesOnMap({
    required this.latitude,
    required this.longitude,
    this.maxDistanceKm = 10,
    this.pageSize = 50,
  });

  @override
  List<Object?> get props => [latitude, longitude, maxDistanceKm, pageSize];
}

// Select a cafe marker
class SelectCafeMarker extends MapEvent {
  final String cafeId;

  const SelectCafeMarker(this.cafeId);

  @override
  List<Object?> get props => [cafeId];
}

// Deselect cafe marker
class DeselectCafeMarker extends MapEvent {
  const DeselectCafeMarker();
}

// Update current location
class UpdateCurrentLocation extends MapEvent {
  final double latitude;
  final double longitude;

  const UpdateCurrentLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

// Refresh nearby cafes
class RefreshNearbyCafes extends MapEvent {
  const RefreshNearbyCafes();
}

// Update zoom level
class UpdateMapZoom extends MapEvent {
  final double zoom;

  const UpdateMapZoom(this.zoom);

  @override
  List<Object?> get props => [zoom];
}
