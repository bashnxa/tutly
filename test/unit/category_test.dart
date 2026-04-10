import 'package:flutter_test/flutter_test.dart';
import 'package:tutly/models/category.dart';

void main() {
  group('Category', () {
    test('should create Category from JSON', () {
      // Arrange
      final json = {
        'id': 'sight',
        'title': 'Достопримечательности',
      };

      // Act
      final category = Category.fromJson(json);

      // Assert
      expect(category.id, 'sight');
      expect(category.title, 'Достопримечательности');
    });

    test('should convert Category to JSON', () {
      // Arrange
      final category = Category(id: 'food', title: 'Еда');

      // Act
      final json = category.toJson();

      // Assert
      expect(json['id'], 'food');
      expect(json['title'], 'Еда');
    });

    test('should maintain data consistency through JSON round-trip', () {
      // Arrange
      final original = Category(id: 'walk', title: 'Прогулки');

      // Act
      final json = original.toJson();
      final restored = Category.fromJson(json);

      // Assert
      expect(restored.id, original.id);
      expect(restored.title, original.title);
    });
  });
}