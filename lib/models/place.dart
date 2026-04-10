import 'package:geolocator/geolocator.dart';

class Place {
  final int id;
  final String name;
  final String categoryId;
  final double lat;
  final double lng;
  final String description;
  final double? distance;

  Place({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.lat,
    required this.lng,
    required this.description,
    this.distance,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'lat': lat,
      'lng': lng,
      'description': description,
    };
  }

  Place copyWith({
    int? id,
    String? name,
    String? categoryId,
    double? lat,
    double? lng,
    String? description,
    double? distance,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      description: description ?? this.description,
      distance: distance ?? this.distance,
    );
  }

  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} м';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} км';
    }
  }
}