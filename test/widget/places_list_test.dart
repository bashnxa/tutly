import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutly/screens/places_list.dart';
import 'package:tutly/widgets/place_card.dart';

void main() {
  group('PlacesList', () {
    testWidgets('should display app bar with title', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PlacesList(),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Tutly'), findsOneWidget);
    });

    testWidgets('should display category filter chips', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PlacesList(),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Assert - Find filter chips
      expect(find.text('Все'), findsOneWidget);
      expect(find.byType(FilterChip), findsWidgets);
    });

    testWidgets('should display place cards', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PlacesList(),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Монумент Дружбы'), findsOneWidget);
      expect(find.byType(PlaceCard), findsWidgets);
    });

    testWidgets('should show place details when card is tapped', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: PlacesList(),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Tap on first place card
      await tester.tap(find.text('Монумент Дружбы'));
      await tester.pumpAndSettle();

      // Assert - Modal should be visible
      expect(find.text('Открыть на карте'), findsOneWidget);
      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });
  });
}