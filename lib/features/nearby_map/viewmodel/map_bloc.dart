import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:briewview/features/cafe/repository/cafes_repository.dart';
import 'package:briewview/core/services/location_service.dart';
import 'package:briewview/features/nearby_map/viewmodel/map_event.dart';
import 'package:briewview/features/nearby_map/viewmodel/map_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MapBloc extends Bloc<MapEvent, MapState> {
  final CafesRepository cafesRepository;
  final LocationService locationService;

  MapBloc({required this.cafesRepository, required this.locationService})
    : super(const MapInitial()) {
    on<LoadNearbyCafesOnMap>(_onLoadNearbyCafesOnMap);
    on<SelectCafeMarker>(_onSelectCafeMarker);
    on<DeselectCafeMarker>(_onDeselectCafeMarker);
    on<UpdateCurrentLocation>(_onUpdateCurrentLocation);
    on<RefreshNearbyCafes>(_onRefreshNearbyCafes);
    on<UpdateMapZoom>(_onUpdateMapZoom);

    // Listen to location changes
    _setupLocationListener();
  }

  void _setupLocationListener() {
    locationService.onLocationChanged = (lat, lng) {
      add(UpdateCurrentLocation(latitude: lat, longitude: lng));
    };
  }

  Future<void> _onLoadNearbyCafesOnMap(
    LoadNearbyCafesOnMap event,
    Emitter<MapState> emit,
  ) async {
    emit(const MapLoading());
    try {
      final result = await cafesRepository.getCafesByDistance(
        latitude: event.latitude,
        longitude: event.longitude,
        maxDistanceKm: event.maxDistanceKm,
        pageNumber: 1,
        pageSize: event.pageSize,
      );

      result.fold((failure) => emit(MapError(failure.message)), (cafes) {
        emit(
          MapLoaded(
            cafes: cafes,
            currentLatitude: event.latitude,
            currentLongitude: event.longitude,
            zoom: 14.0,
          ),
        );
      });
    } catch (e) {
      emit(MapError('Failed to load nearby cafes: ${e.toString()}'));
    }
  }

  Future<void> _onSelectCafeMarker(
    SelectCafeMarker event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(selectedCafeId: event.cafeId));
    }
  }

  Future<void> _onDeselectCafeMarker(
    DeselectCafeMarker event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(clearSelection: true));
    }
  }

  Future<void> _onUpdateCurrentLocation(
    UpdateCurrentLocation event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(
        currentState.copyWith(
          currentLatitude: event.latitude,
          currentLongitude: event.longitude,
        ),
      );
    }
  }

  Future<void> _onRefreshNearbyCafes(
    RefreshNearbyCafes event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      add(
        LoadNearbyCafesOnMap(
          latitude: currentState.currentLatitude,
          longitude: currentState.currentLongitude,
        ),
      );
    } else if (locationService.hasLocation) {
      add(
        LoadNearbyCafesOnMap(
          latitude: locationService.latitude!,
          longitude: locationService.longitude!,
        ),
      );
    }
  }

  Future<void> _onUpdateMapZoom(
    UpdateMapZoom event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(zoom: event.zoom));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
