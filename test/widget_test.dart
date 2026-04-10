import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutly/main.dart';
import 'package:tutly/screens/places_list.dart';

void main() {
  testWidgets('App should start with PlacesList screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TutlyApp());

    // Wait for initial load
    await tester.pumpAndSettle();

    // Verify that PlacesList is displayed
    expect(find.byType(PlacesList), findsOneWidget);
  });

  testWidgets('App should have correct title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TutlyApp());

    // Wait for initial load
    await tester.pumpAndSettle();

    // Verify the app title
    expect(find.text('Tutly'), findsOneWidget);
  });
}