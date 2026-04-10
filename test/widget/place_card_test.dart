import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutly/models/place.dart';
import 'package:tutly/models/category.dart';
import 'package:tutly/widgets/place_card.dart';

void main() {
  group('PlaceCard', () {
    testWidgets('should display place name', (WidgetTester tester) async {
      // Arrange
      final place = Place(
        id: 1,
        name: 'Монумент Дружбы',
        categoryId: 'sight',
        lat: 54.7181,
        lng: 55.9694,
        description: 'Символ дружбы народов',
      );
      final category = Category(id: 'sight', title: 'Достопримечательности');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceCard(place: place, category: category),
          ),
        ),
      );

      // Assert
      expect(find.text('Монумент Дружбы'), findsOneWidget);
    });

    testWidgets('should display place description', (WidgetTester tester) async {
      // Arrange
      final place = Place(
        id: 1,
        name: 'Набережная',
        categoryId: 'walk',
        lat: 54.7212,
        lng: 55.9398,
        description: 'Лучшее место для прогулок у воды',
      );
      final category = Category(id: 'walk', title: 'Прогулки');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceCard(place: place, category: category),
          ),
        ),
      );

      // Assert
      expect(find.text('Лучшее место для прогулок у воды'), findsOneWidget);
    });

    testWidgets('should display category badge', (WidgetTester tester) async {
      // Arrange
      final place = Place(
        id: 1,
        name: 'Кафе',
        categoryId: 'food',
        lat: 54.7379,
        lng: 55.9602,
        description: 'Национальная кухня',
      );
      final category = Category(id: 'food', title: 'Еда');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceCard(place: place, category: category),
          ),
        ),
      );

      // Assert - Check for category text in badge
      expect(find.text('Еда'), findsOneWidget);
      expect(find.byIcon(Icons.restaurant_outlined), findsWidgets);
    });

    testWidgets('should display map button', (WidgetTester tester) async {
      // Arrange
      final place = Place(
        id: 1,
        name: 'Парк',
        categoryId: 'walk',
        lat: 54.7389,
        lng: 55.9572,
        description: 'Старейший парк',
      );
      final category = Category(id: 'walk', title: 'Прогулки');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceCard(place: place, category: category),
          ),
        ),
      );

      // Assert
      expect(find.text('На карте'), findsOneWidget);
      expect(find.byIcon(Icons.map_outlined), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (WidgetTester tester) async {
      // Arrange
      var tapped = false;
      final place = Place(
        id: 1,
        name: 'Место',
        categoryId: 'sight',
        lat: 54.7181,
        lng: 55.9694,
        description: 'Описание',
      );
      final category = Category(id: 'sight', title: 'Достопримечательности');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceCard(
              place: place,
              category: category,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Tap on the place name instead of InkWell
      await tester.tap(find.text('Место'));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should call onMapTap when map button is pressed', (WidgetTester tester) async {
      // Arrange
      var mapTapped = false;
      final place = Place(
        id: 1,
        name: 'Место',
        categoryId: 'photo',
        lat: 54.7412,
        lng: 55.9823,
        description: 'Фото-спот',
      );
      final category = Category(id: 'photo', title: 'Фото-споты');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceCard(
              place: place,
              category: category,
              onMapTap: () => mapTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('На карте'));
      await tester.pumpAndSettle();

      // Assert
      expect(mapTapped, isTrue);
    });
  });
}