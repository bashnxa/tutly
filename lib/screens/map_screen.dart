import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tutly/models/place.dart';
import 'package:tutly/models/category.dart';

class MapScreen extends StatefulWidget {
  final List<Place> places;
  final List<Category> categories;
  final Place? selectedPlace;
  final Position? currentPosition;

  const MapScreen({
    super.key,
    required this.places,
    required this.categories,
    this.selectedPlace,
    this.currentPosition,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  late final List<Marker> _markers;
  late final List<Polyline> _polylines;

  @override
  void initState() {
    super.initState();
    _markers = _buildMarkers();
    _polylines = _buildPolylines();
    _centerMapOnSelectedPlace();
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Add user location marker if available
    if (widget.currentPosition != null) {
      markers.add(
        Marker(
          point: LatLng(
            widget.currentPosition!.latitude,
            widget.currentPosition!.longitude,
          ),
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 20,
            ),
          ),
        ),
      );
    }

    // Add place markers
    for (final place in widget.places) {
      final category = widget.categories.firstWhere(
        (cat) => cat.id == place.categoryId,
        orElse: () => Category(id: '', title: ''),
      );

      markers.add(
        Marker(
          point: LatLng(place.lat, place.lng),
          width: 40,
          height: 40,
          child: _buildMarkerWidget(place, category),
        ),
      );
    }

    return markers;
  }

  List<Polyline> _buildPolylines() {
    final polylines = <Polyline>[];

    // Add polyline from user location to selected place
    if (widget.currentPosition != null && widget.selectedPlace != null) {
      polylines.add(
        Polyline(
          points: [
            LatLng(
              widget.currentPosition!.latitude,
              widget.currentPosition!.longitude,
            ),
            LatLng(widget.selectedPlace!.lat, widget.selectedPlace!.lng),
          ],
          strokeWidth: 3,
          color: Colors.blue.withOpacity(0.7),
        ),
      );
    }

    return polylines;
  }

  Widget _buildMarkerWidget(Place place, Category category) {
    final isSelected = widget.selectedPlace?.id == place.id;

    return GestureDetector(
      onTap: () {
        _showPlaceDetails(place, category);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue
              : _getCategoryColor(category.id),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _getCategoryIcon(category.id),
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _centerMapOnSelectedPlace() {
    if (widget.selectedPlace != null) {
      _mapController.move(
        LatLng(widget.selectedPlace!.lat, widget.selectedPlace!.lng),
        15,
      );
    } else if (widget.places.isNotEmpty) {
      // Center on all places
      final bounds = _calculateBounds();
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(50),
        ),
      );
    }
  }

  LatLngBounds _calculateBounds() {
    if (widget.places.isEmpty) {
      return LatLngBounds(
        const LatLng(54.5, 55.5),
        const LatLng(55.0, 56.5),
      );
    }

    final lats = widget.places.map((p) => p.lat).toList();
    final lngs = widget.places.map((p) => p.lng).toList();

    return LatLngBounds(
      LatLng(lats.reduce((a, b) => a < b ? a : b), lngs.reduce((a, b) => a < b ? a : b)),
      LatLng(lats.reduce((a, b) => a > b ? a : b), lngs.reduce((a, b) => a > b ? a : b)),
    );
  }

  void _showPlaceDetails(Place place, Category category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                place.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(category.title),
                avatar: Icon(_getCategoryIcon(category.id), size: 18),
              ),
              const SizedBox(height: 16),
              Text(
                place.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              if (place.distance != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      Place.formatDistance(place.distance!),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  _mapController.move(
                    LatLng(place.lat, place.lng),
                    16,
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.center_focus_strong),
                label: const Text('Центрировать на карте'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'sight':
        return const Color(0xFF667eea);
      case 'food':
        return const Color(0xFFf093fb);
      case 'walk':
        return const Color(0xFF4facfe);
      case 'photo':
        return const Color(0xFFfa709a);
      default:
        return const Color(0xFFa18cd1);
    }
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'sight':
        return Icons.landscape_outlined;
      case 'food':
        return Icons.restaurant_outlined;
      case 'walk':
        return Icons.directions_walk_outlined;
      case 'photo':
        return Icons.camera_alt_outlined;
      default:
        return Icons.place_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта'),
        elevation: 0,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: widget.selectedPlace != null
              ? LatLng(widget.selectedPlace!.lat, widget.selectedPlace!.lng)
              : const LatLng(54.735, 55.958),
          initialZoom: 13,
          minZoom: 10,
          maxZoom: 18,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.tutly',
          ),
          PolylineLayer(polylines: _polylines),
          MarkerLayer(markers: _markers),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.places.isNotEmpty)
            FloatingActionButton(
              heroTag: 'fit_bounds',
              mini: true,
              onPressed: () {
                final bounds = _calculateBounds();
                _mapController.fitCamera(
                  CameraFit.bounds(
                    bounds: bounds,
                    padding: const EdgeInsets.all(50),
                  ),
                );
              },
              child: const Icon(Icons.fit_screen),
            ),
          if (widget.places.isNotEmpty) const SizedBox(height: 8),
          if (widget.currentPosition != null)
            FloatingActionButton(
              heroTag: 'my_location',
              onPressed: () {
                _mapController.move(
                  LatLng(
                    widget.currentPosition!.latitude,
                    widget.currentPosition!.longitude,
                  ),
                  15,
                );
              },
              child: const Icon(Icons.my_location),
            ),
        ],
      ),
    );
  }
}