import 'package:flutter_test/flutter_test.dart';
import 'package:tutly/models/route.dart';

void main() {
  group('Route', () {
    test('should create Route from JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Уфа за 2 часа',
        'description': 'Быстрый маршрут',
        'placeIds': [1, 2, 3],
        'estimatedTimeMinutes': 120,
        'difficulty': 'easy',
      };

      // Act
      final route = Route.fromJson(json);

      // Assert
      expect(route.id, 1);
      expect(route.title, 'Уфа за 2 часа');
      expect(route.description, 'Быстрый маршрут');
      expect(route.placeIds, [1, 2, 3]);
      expect(route.estimatedTimeMinutes, 120);
      expect(route.difficulty, 'easy');
    });

    test('should convert Route to JSON', () {
      // Arrange
      final route = Route(
        id: 2,
        title: '1 день в Уфе',
        description: 'Полноценный маршрут',
        placeIds: [4, 5, 6],
        estimatedTimeMinutes: 480,
        difficulty: 'medium',
      );

      // Act
      final json = route.toJson();

      // Assert
      expect(json['id'], 2);
      expect(json['title'], '1 день в Уфе');
      expect(json['description'], 'Полноценный маршрут');
      expect(json['placeIds'], [4, 5, 6]);
      expect(json['estimatedTimeMinutes'], 480);
      expect(json['difficulty'], 'medium');
    });

    test('should maintain data consistency through JSON round-trip', () {
      // Arrange
      final original = Route(
        id: 3,
        title: 'Вечерний маршрут',
        description: 'Прогулка по вечернему городу',
        placeIds: [7, 8, 9],
        estimatedTimeMinutes: 90,
        difficulty: 'easy',
      );

      // Act
      final json = original.toJson();
      final restored = Route.fromJson(json);

      // Assert
      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.description, original.description);
      expect(restored.placeIds, original.placeIds);
      expect(restored.estimatedTimeMinutes, original.estimatedTimeMinutes);
      expect(restored.difficulty, original.difficulty);
    });
  });
}