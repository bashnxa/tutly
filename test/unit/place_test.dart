import 'package:flutter_test/flutter_test.dart';
import 'package:tutly/models/place.dart';

void main() {
  group('Place', () {
    test('should create Place from JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'Монумент Дружбы',
        'categoryId': 'sight',
        'lat': 54.7181,
        'lng': 55.9694,
        'description': 'Символ дружбы народов',
      };

      // Act
      final place = Place.fromJson(json);

      // Assert
      expect(place.id, 1);
      expect(place.name, 'Монумент Дружбы');
      expect(place.categoryId, 'sight');
      expect(place.lat, 54.7181);
      expect(place.lng, 55.9694);
      expect(place.description, 'Символ дружбы народов');
    });

    test('should convert Place to JSON', () {
      // Arrange
      final place = Place(
        id: 2,
        name: 'Набережная',
        categoryId: 'walk',
        lat: 54.7212,
        lng: 55.9398,
        description: 'Лучшее место для прогулок',
      );

      // Act
      final json = place.toJson();

      // Assert
      expect(json['id'], 2);
      expect(json['name'], 'Набережная');
      expect(json['categoryId'], 'walk');
      expect(json['lat'], 54.7212);
      expect(json['lng'], 55.9398);
      expect(json['description'], 'Лучшее место для прогулок');
    });

    test('should maintain data consistency through JSON round-trip', () {
      // Arrange
      final original = Place(
        id: 3,
        name: 'Парк',
        categoryId: 'walk',
        lat: 54.7389,
        lng: 55.9572,
        description: 'Старейший парк',
      );

      // Act
      final json = original.toJson();
      final restored = Place.fromJson(json);

      // Assert
      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.categoryId, original.categoryId);
      expect(restored.lat, original.lat);
      expect(restored.lng, original.lng);
      expect(restored.description, original.description);
    });
  });
}