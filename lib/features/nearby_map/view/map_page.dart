import 'package:briewview/app/di/locator.dart';
import 'package:briewview/app/theme/app_color.dart';
import 'package:briewview/core/services/location_service.dart';
import 'package:briewview/features/nearby_map/viewmodel/map_bloc.dart';
import 'package:briewview/features/nearby_map/viewmodel/map_event.dart';
import 'package:briewview/features/nearby_map/viewmodel/map_state.dart';
import 'package:briewview/features/nearby_map/view/widgets/cafe_map_view.dart';
import 'package:briewview/features/nearby_map/view/widgets/cafe_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapBloc _mapBloc;
  late LocationService _locationService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _mapBloc = getIt<MapBloc>();
    _locationService = getIt<LocationService>();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      // Initialize location service if not already initialized
      if (!_locationService.hasLocation) {
        final initialized = await _locationService.initialize();
        if (!initialized) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Không thể truy cập vị trí của bạn'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      // Load nearby cafes
      if (_locationService.hasLocation) {
        _mapBloc.add(
          LoadNearbyCafesOnMap(
            latitude: _locationService.latitude!,
            longitude: _locationService.longitude!,
            maxDistanceKm: 10,
            pageSize: 50,
          ),
        );
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mapBloc,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColor.primaryGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Map view
                BlocConsumer<MapBloc, MapState>(
                  listener: (context, state) {
                    if (state is MapError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is MapLoading || !_isInitialized) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (state is MapLocationPermissionDenied) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_off,
                              size: 80,
                              color: Colors.white54,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Quyền truy cập vị trí bị từ chối',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Open app settings
                              },
                              child: const Text('Mở cài đặt'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is MapLoaded) {
                       print('Rendering MapLoaded with ${state.cafes.length} cafes');  
                      return Column(
                        children: [
                          // Map view
                          Expanded(
                            child: CafeMapView(
                              cafes: state.cafes,
                              currentLatitude: state.currentLatitude,
                              currentLongitude: state.currentLongitude,
                              zoom: state.zoom,
                              selectedCafeId: state.selectedCafeId,
                            ),
                          ),
                          // Selected cafe bottom sheet
                          if (state.selectedCafeId != null)
                            CafeBottomSheet(
                              cafe: state.cafes.firstWhere(
                                (c) => c.cafeId == state.selectedCafeId,
                              ),
                              onClose: () {
                                _mapBloc.add(const DeselectCafeMarker());
                              },
                            ),
                        ],
                      );
                    }

                    return const Center(
                      child: Text(
                        'Không thể tải bản đồ',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),

                // Header with back button
                Positioned(top: 10, left: 10, right: 10, child: _buildHeader()),

                // Refresh button
                // Positioned(
                //   bottom: 100,
                //   right: 20,
                //   child: FloatingActionButton(
                //     onPressed: () {
                //       _mapBloc.add(const RefreshNearbyCafes());
                //     },
                //     backgroundColor: Colors.brown,
                //     child: const Icon(Icons.refresh, color: Colors.white),
                //   ),
                // ),

                // // Current location button
                // Positioned(
                //   bottom: 170,
                //   right: 20,
                //   child: FloatingActionButton(
                //     onPressed: () {
                //       if (_locationService.hasLocation) {
                //         _mapBloc.add(
                //           LoadNearbyCafesOnMap(
                //             latitude: _locationService.latitude!,
                //             longitude: _locationService.longitude!,
                //           ),
                //         );
                //       }
                //     },
                //     backgroundColor: Colors.brown,
                //     child: const Icon(Icons.my_location, color: Colors.white),
                //   ),
                // ),

                BlocBuilder<MapBloc, MapState>(
                  builder: (context, state) {
                     final hasBottomSheet =
                        state is MapLoaded && state.selectedCafeId != null; 
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 300), 
                      bottom: hasBottomSheet ? 320 : 20,    
                      right: 20,
                      child : Column(       
                        mainAxisSize: MainAxisSize.min,         
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              _mapBloc.add(const RefreshNearbyCafes());
                            },
                            backgroundColor: Colors.brown,
                            child: const Icon(Icons.refresh, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          FloatingActionButton(
                            onPressed: () {
                              if (_locationService.hasLocation) {
                                _mapBloc.add(
                                  LoadNearbyCafesOnMap(
                                    latitude: _locationService.latitude!,
                                    longitude: _locationService.longitude!,
                                  ),
                                );
                              }
                            },
                            backgroundColor: Colors.brown,
                            child: const Icon(Icons.my_location, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),  
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();  
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Quán cafe gần đây',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              if (state is MapLoaded) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${state.cafes.length} quán',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
