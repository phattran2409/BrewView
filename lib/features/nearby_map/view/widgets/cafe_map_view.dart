import 'package:briewview/features/cafe/model/cafeMode.dart';
import 'package:briewview/features/nearby_map/viewmodel/map_bloc.dart';
import 'package:briewview/features/nearby_map/viewmodel/map_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CafeMapView extends StatefulWidget {
  final List<CafeModel> cafes;
  final double currentLatitude;
  final double currentLongitude;
  final double zoom;
  final String? selectedCafeId;

  const CafeMapView({
    super.key,
    required this.cafes,
    required this.currentLatitude,
    required this.currentLongitude,
    this.zoom = 14.0,
    this.selectedCafeId,
  });

  @override
  State<CafeMapView> createState() => _CafeMapViewState();
}

class _CafeMapViewState extends State<CafeMapView> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(CafeMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update map center if location changed significantly
    if ((oldWidget.currentLatitude - widget.currentLatitude).abs() > 0.001 ||
        (oldWidget.currentLongitude - widget.currentLongitude).abs() > 0.001) {
      _mapController.move(
        LatLng(widget.currentLatitude, widget.currentLongitude),
        widget.zoom,
      );
    }

    // Zoom to selected cafe if changed
    if (widget.selectedCafeId != null &&
        widget.selectedCafeId != oldWidget.selectedCafeId) {
      final selectedCafe = widget.cafes.firstWhere(
        (c) => c.cafeId == widget.selectedCafeId,
        orElse: () => widget.cafes.first,
      );
      if (selectedCafe.latitude != null && selectedCafe.longitude != null) {
        _mapController.move(
          LatLng(selectedCafe.latitude!, selectedCafe.longitude!),
          15.0, // Zoom in closer for selected cafe
        );
      }
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(widget.currentLatitude, widget.currentLongitude),
        initialZoom: widget.zoom,
        minZoom: 5.0,
        maxZoom: 18.0,
        onPositionChanged: (position, hasGesture) {
          if (hasGesture && position.zoom != null) {
            // Update zoom level in bloc
            context.read<MapBloc>().add(UpdateMapZoom(position.zoom!));
          }
        },
      ),
      children: [
        // OpenStreetMap tile layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.briewview.app',
          tileProvider: NetworkTileProvider(),
        ),

        // Markers layer
        MarkerLayer(markers: _buildMarkers()),

        // Attribution (required by OpenStreetMap)
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () {
                // Could open browser to https://openstreetmap.org/copyright
              },
            ),
          ],
        ),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Debug: print the number of cafes being processed
    for (var cafe in widget.cafes) {
      print('latitude: ${cafe.latitude}, longitude: ${cafe.longitude}');
    }

    // Add current location marker (blue)
    markers.add(
      Marker(
        point: LatLng(widget.currentLatitude, widget.currentLongitude),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            // Show current location info
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vị trí của bạn'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 3),
            ),
            child: const Icon(Icons.my_location, color: Colors.blue, size: 20),
          ),
        ),
      ),
    );

    // Add cafe markers (orange/brown)
    int validCafes = 0;
    for (var cafe in widget.cafes) {
      if (cafe.latitude != null && cafe.longitude != null) {
        validCafes++;
        final isSelected = cafe.cafeId == widget.selectedCafeId;

        // Debug: print cafe coordinates
        print(
          cafe != null
              ? 'Cafe "${cafe.name}" at (${cafe.latitude}, ${cafe.longitude})'
              : 'Invalid cafe',
        );

        markers.add(
          Marker(
            point: LatLng(cafe.latitude!, cafe.longitude!),
            width: isSelected ? 50 : 40,
            height: isSelected ? 50 : 40,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                context.read<MapBloc>().add(
                  SelectCafeMarker(cafe.cafeId ?? ''),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.brown,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.coffee,
                  color: Colors.white,
                  size: isSelected ? 28 : 22,
                ),
              ),
            ),
          ),
        );
      }
    }

    print(
      'Total markers created: ${markers.length} (${validCafes} cafes + 1 current location)',
    );
    return markers;
  }
}
